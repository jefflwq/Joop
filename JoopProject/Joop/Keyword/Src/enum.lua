--region static_class.lua
--Author : jefflwq
--Date   : 2016/02/28
--说明   : 定义枚举类型
--         枚举类型只可以继承自另一个枚举类型
--         枚举的成员都是public const的
--         枚举的成员也可以是function,但是不推荐使用,除非你知道你在干什么
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
local GetJoopTypeName = Joop.GetJoopTypeName
local GetJoopTypeInfo = Joop.GetJoopTypeInfo
local GetMetaKey = Joop.GetMetaKey
local SetMetaKey = Joop.SetMetaKey
local SetOnCall = Joop.SetOnCall
local SetOnIndex = Joop.SetOnIndex
local SetOnNewindex = Joop.SetOnNewindex
local CheckModifiers = modifier.CheckModifiers
local keyword = keyword
local super = super

--禁止增加一个key
local function No__newindex(self, key, value)
    if self[key] == nil then
        Error("<" .. key .. "> is not a member of".. "<" .. GetJoopTypeName(self) .. ">", 3)--ok
    else
        Error("enum type can't be set to a new value : <" .. GetJoopTypeName(self) .. "." .. key .. ">", 3)--ok
    end
end

--禁止实例化
local function No__call(self, key, value)
    Error("enum type can't be Instantiated : <" .. GetJoopTypeName(self) .. ">", 3)--ok
end

--设置enum的body，由{}包含的部分
local function OnSetEnumBody(self, body)
    --出栈
    local curObj = JStack:Top()
    if curObj ~= self then
        Error("stack error. current : <" .. GetJoopTypeName(self) .. ">, wanted : <" .. GetJoopTypeName(curObj) .. ">", 3)
        return nil
    else
        JStack:Pop()
    end
    SetOnCall(self, No__call)
    SetOnNewindex(self, No__newindex)
    return true
end

-- 生成新enum
local function OnCreating(self, newEnum)
    local curNs = JStack:Top()
    local typeInfo = GetJoopTypeInfo(newEnum)
    if rawget(curNs, typeInfo.___name) then
        Error("Redefined : " .. typeInfo.___name, 4)
        return
    end
    typeInfo.___isBuildinType = false
    typeInfo.___owner = curNs--owner, maybe a namespace or else?
    rawset(typeInfo.___owner, typeInfo.___name, newEnum)
    rawset(newEnum, "OnFindKey", rawget)    

    --将当前生成的enum压栈，在读取{}后出栈
    JStack:Push(newEnum) --modifier 要用
    return true
end

--用enum定义新枚举的时候,使用OnRegisterEnum注册,enum会被注册到相应的namespace中
local function OnRegisterEnum(self)
    rawset(self, "OnFindKey", nil) --清除OnCreating中的设置
    return true
end

local function GetElements(self)
    return GetJoopTypeInfo(self, "___body")
end


keyword "enum"
{
    ___OnCreating = OnCreating,-- 重载JPrototype.___OnCreating

    ___OnRegister = --响应keyword的___OnRegister事件,把enum关键字注册到keyword当中
        function(self)
            keyword.___OnRegister(self)--注册enum关键字到keyword中
            --用enum关键字定义的新类型将使用___OnRegisterEnum注册
            self.___OnRegister = OnRegisterEnum
            return true
        end,

    ___OnSetBody = 
        function(self, body)
            self.___OnSetBody = OnSetEnumBody
            return true
        end,

    OnFindKey = rawget,
    GetElements = GetElements,
}
