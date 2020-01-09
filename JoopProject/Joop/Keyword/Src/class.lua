--region class.lua
--Author : jefflwq
--Date   : 2016/02/27
--说明   : 由于子类的构造函数参数可能与父类不同,所以无法自动调用父类的构造函数
--         需要保证每一个class都有一个与class同名的构造函数,并在其中主动调用父类的构造函数
--用例
--            class "CBase"
--            {
--                baseMember = false
--                CBase = 
--                    function(self, ...)
--                        self.baseMember = 0
--                    end,
--            }
--            class "CInherit" : CBase --这里不能使用namespace, 如果必须要使用namespace,可以这样: 
--            {                         --local ClsA = namespaceXX.CBase    class "CInherit" : ClsA
--                member = false
--                Init = 
--                    function(self, ...)
--                        self.member = 1
--                    end,
--                CInherit = 
--                    function(self, ...)
--                        self.super(...) --调用父类的构造函数, 如果构造函数中只有这一句(参数顺序和数量都相同),那么是可以省略的(会自动调用CBase的构造函数)
--                        self:Init(...)   --但是如果有别的语句或参数顺序和数量不同,那么请手动调用父类的构造函数,就像这个例子中的一样
--                    end,
--            }
--endregion

using "Joop"

local getmetatable = getmetatable
local setmetatable = setmetatable
local rawget = rawget
local rawset = rawset
local getfenv = getfenv
local type = type
local pairs = pairs
local Joop = Joop
local JStack = JStack
local JFEnv = JFEnv
local GetJoopTypeName = Joop.GetJoopTypeName
local GetJoopTypeInfo = Joop.GetJoopTypeInfo
local GetMetaKey = Joop.GetMetaKey
local SetMetaKey = Joop.SetMetaKey
local SetOnCall = Joop.SetOnCall
local CheckModifiers = modifier.CheckModifiers
local keyword = keyword
local super = super

-- 重载JPrototype.___OnCreating, 先于OnRegisterClass调用
local function OnCreating(self, newClass)
    local curNs = JStack:Top()
    local typeInfo = GetJoopTypeInfo(newClass)
    --print(typeInfo.___name)
    if rawget(curNs, typeInfo.___name) then
        Error("Redefined : " .. typeInfo.___name, 3)
        return
    end
    typeInfo.___isBuildinType = false
    typeInfo.___owner = curNs
    rawset(typeInfo.___owner, typeInfo.___name, newClass)--注册到owner, maybe a namespace or else?
    typeInfo.___modifiedKeys = {}
    typeInfo.___fileEnv = getfenv(3)
    rawset(newClass, "OnFindKey", rawget)--?????
    --SetOnIndex(newClass, FindClassKey)
                
    --将当前生成的class压栈，在读取{}后出栈
    JStack:Push(newClass) --modifier 要用
    return true
end

--用class定义新类的时候,使用OnRegisterClass注册,class会被注册到相应的namespace中
local function OnRegisterClass(newClass)
    rawset(newClass, "OnFindKey", nil) --清除OnCreating中的设置
    return true
end


local function FindKeyInFunction(fenv, key)
    --see class.owner of the function
    local v = rawget(fenv, "___class")
    if not v then
        return
    end
    v = GetJoopTypeInfo(v, "___owner")
    if not v then
        return
    end
    v = v[key]
    if v ~= nil then
        return v
    end
    --see fileEnv of the function 
    v = rawget(fenv, "___fileEnv")
    if not v then
        return
    end
    v = v[key]
    if v ~= nil then
        return v
    end
end

---查找Ctor，包括基类
local function GetCtor(cls)
    --首先查找自身
    local typeInfo = GetJoopTypeInfo(cls)
    local ctor = false
    while typeInfo and typeInfo.___name ~= "class" do
        ctor = typeInfo.___ctor
        if ctor then
            return ctor
        end
        typeInfo = GetJoopTypeInfo(typeInfo.___super)
    end
    return ctor
end

---取得基类的__index函数
local super__index = GetMetaKey(keyword, "__index")

---查找class的key
local function FindClassKey(self, key)
    if key == "super" then
        return super(self)
    end
    return super__index(self, key)
end

---查找object的key
local function FindObjectKey(self, key)
    if key == "super" then
        return super(self, true)
    end
    local v = GetJoopTypeInfo(self, "___type")
    if not v then --判定该对象是否为Joop对象
        return nil
    end

    local v = v[key]
    if type(v) == "function" then
        rawset(self, key, v)
    end
    return v
end

---查找指定key的ModifierInfo，包括基类
local function GetModifierInfo(self, key)
    local v = GetJoopTypeInfo(self)
    local mdfInfo = v.___modifiedKeys[key]
    while v and v.___name ~= "class" and v.___modifiedKeys do
        mdfInfo = v.___modifiedKeys[key]
        if mdfInfo then
            return mdfInfo
        end
        v = GetJoopTypeInfo(v.___super)
    end
end

--增加一个key
local function CreateNewObjectKey(self, key, value)
    local v = self[key]
    if v == nil then
        Error("<" .. key .. "> is not a member of".. "<" .. GetJoopTypeName(self) .. ">", 2)--ok
        return nil
    end
    --这里检查是否指定了修饰符,并作相应处理
    local mdfInfo = GetModifierInfo(self, key)
    if mdfInfo == nil then --未指定modifier
        rawset(self, key, value)
        return
    end

    if CheckModifiers(self, mdfInfo, key, value) then
        rawset(self, key, value)
    end
end

--构造该类的实例, 调用构造函数,如该类没有构造函数,则尝试调用父类的构造函数,此时将无法保证传递的参数的正确性
local function ConstructObject(self, obj, ...)--self is the class of the object
    local ctor = self.___ctor
    if ctor then
        ctor(obj, ...)
    end
end
-- 生成新实例
local function CreateNewObject(self, ...)
    local obj={___isObject = true}-- ___typeInfo = self.___typeInfo 
    setmetatable(obj,{ __index=FindObjectKey, __newindex=CreateNewObjectKey })
    SetMetaKey(obj, "___typeInfo", GetJoopTypeInfo(self))
    --调用构造函数
    ConstructObject(self, obj, ...)
    return obj
end

--设置class的body，由{}包含的部分
local function OnSetClassBody(self, body)
    local typeInfo = GetJoopTypeInfo(self)
    --将用modifier修饰的成员加入到类的body中
    for k, v in pairs(typeInfo.___modifiedKeys) do
        rawset(typeInfo.___body, k, v.___value)
        v.___value = nil
    end
            
    --为class的function设置一个env
    local funcEnv
    for k, v in pairs(typeInfo.___body) do
        if type(v) == "function" then
            funcEnv = JFEnv(v)
            funcEnv.___class = self
            if GetJoopTypeName(typeInfo.___super) ~= "class" then
                funcEnv.___super = typeInfo.___super
            end
            funcEnv.___funcname = k
            funcEnv.___fileEnv = typeInfo.___fileEnv
            if k == typeInfo.___name then ---保存ctor
                typeInfo.___ctor = v
                funcEnv.___isctor = true
            end
            funcEnv.FindKey = FindKeyInFunction
        end
    end
    if not typeInfo.___ctor then
        typeInfo.___ctor = GetCtor(self)
    end
    rawset(self, "___ctor", typeInfo.___ctor)
    --出栈
    local curObj = JStack:Top()
    if curObj ~= self then
        Error("stack error. current : <" .. GetJoopTypeName(self) .. ">, wanted : <" .. GetJoopTypeName(curObj) .. ">", 3)
        return nil
    else
        JStack:Pop()
    end
    SetOnCall(self, CreateNewObject)
    SetOnIndex(self, FindClassKey)
    return true
end

keyword "class"
{
    ___class = 
        function(self)
            
        end,
    ___OnCreating = OnCreating,-- 重载JPrototype.___OnCreating

    ___OnRegister = --响应keyword的___OnRegister事件,把class关键字注册到keyword当中
        function(self)
            keyword.___OnRegister(self)
            --替换掉class的___OnRegister函数,在使用class定义新类的时候,将使用OnRegisterClass
            self.___OnRegister = OnRegisterClass 
            return true
        end,


    ___OnSetBody = 
        function(self, body)
            self.___OnSetBody = OnSetClassBody
            return true
        end,
    Clone = 
        function(self)
            if not self.___isObject then
                return
            end
            local cls = GetJoopTypeInfo(self, "___type")
            if not IsJoopType(cls) then
                return
            end
            local obj = cls()
            for k, v in pairs(self) do
                obj[k] = v
            end
            return obj
        end,

}
