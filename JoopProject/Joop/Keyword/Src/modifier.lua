--region modifier.lua
--Author : jefflwq
--Date   : 2016/02/27
--说明   : 定义modifier关键字,可以用这个关键字定义用于class成员的修饰符
--用例   : public.static.const.A("111")
--endregion

using "Joop"

local rawset = rawset
local rawget = rawget
local Joop = Joop
local JStack = JStack
local keyword = keyword
local GetJoopTypeName = Joop.GetJoopTypeName
local GetJoopTypeInfo = Joop.GetJoopTypeInfo
local SetOnCall = Joop.SetOnCall
local SetOnIndex = Joop.SetOnIndex

--存储用modifier定义的modifiers
local RegisteredModifiers = {}
--存储使用了modifier的key  modifiedKeys = { key = {const = true, static = true}}
local ModifiedKeys = false --obj.___ModifiedKeys的引用
local KeyModifiers = {} --{const = true, static = true}
---取得keyword__index的__index函数
local keyword__index = GetMetaKey(keyword, "__index")

local function IsModifier(name)
    return rawget(RegisteredModifiers, name)
end

local function GetModifiedKeys()
    if ModifiedKeys then
        return ModifiedKeys
    end
    if JStack:Size() <= 1 then
        --当前不在一个对象中
        return false
    end
    
    local v = GetJoopTypeInfo(JStack:Top(), "___modifiedKeys")
    if not v then
        --当前对象不支持___modifiedKeys
        return false 
    end
    ModifiedKeys = v --保存引用
    return v
end

--用于设置初始值, 例如 const.AAA("123")
local function InitValue(self, value)
    self.___value = value
    setmetatable(self, nil)
end

local function OnModifierIndex(self, key)
    local v = keyword__index(self, key)
    if v then
        return v
    end
    local modifiedKeys = GetModifiedKeys()
    if not modifiedKeys then
        --当前对象不支持 modifier
        return
    end

    --看一下key是不是还是modifier,如果是的话,暂时将当前modifier入栈保存
    v = rawget(RegisteredModifiers, key)
    if v then
        rawset(KeyModifiers, GetJoopTypeName(self), true)
        return v
    end
    --key不是modifier了   
    if rawget(modifiedKeys, key) then --检查时候重复定义了该key
        Error("Redefined '" .. key .. "' in " .. GetJoopTypeName(JStack:Top()), 4)
        return
    end
    rawset(KeyModifiers, GetJoopTypeName(self), true)
    rawset(KeyModifiers, "___value", false)--用modifier修饰的成员默认值为false
    --把这个key加入到该类的___modifiedKeys中  modifiedKeys{ key1 = {const = true, static = true, ___value = false}}
    rawset(modifiedKeys, key, KeyModifiers)
    SetOnCall(KeyModifiers, InitValue) --用于设置初始值, 例如 const.AAA("123")

    v = KeyModifiers
    KeyModifiers = {}
    ModifiedKeys = false

    return v
end

--用modifier定义新修饰符的时候,使用OnRegisterModifier注册
local function OnRegisterModifier(mdfr)
    keyword.___OnRegister(mdfr)--新定义的modifier，也是一个keyword，所以也要注册到keyword中
    local name = GetJoopTypeName(mdfr)
    RegisteredModifiers[name] = mdfr--注册到modifier.RegisteredModifiers中
    RegisteredModifiers[mdfr.___Priority] = name--注册到modifier.RegisteredModifiers中
    SetOnIndex(mdfr, OnModifierIndex)--将新定义的modifier的__index替换为OnModifierIndex
    return true
end

local function CheckModifiers(obj, mdfInfo, key, value)
    --按___Priority的顺序遍历指定的modifier
    for _, v in ipairs(RegisteredModifiers) do
        if mdfInfo[v] then --该key指定了这个modifier
            v = RegisteredModifiers[v]
            --返回值：true(检查通过,继续下一个) false(检查未通过，终止) nil(检查通过，并终止其他的)
            if not v:___OnCheckModifier(obj, key, value) then
                return
            end
        end
    end
    return true
end

keyword "modifier"
{
    ___OnRegister = --响应keyword的___OnRegister事件,把modifier关键字注册到keyword当中
        function(self)
            keyword.___OnRegister(self)--注册modifier关键字到keyword中
            self.___OnRegister = OnRegisterModifier--用modifier定义新修饰符的时候,将使用OnRegisterModifier注册
            return true
        end,

    ___OnCheckModifier = --返回值：true(检查通过,继续下一个) false(检查未通过，终止) nil(检查通过，并终止其他的)
        function(self, obj, key, value)
            return true
        end,

    CheckModifiers = CheckModifiers,
}
