--region namespace.lua
--Author : jefflwq
--Date   : 2016/02/24
--说明   : 定义命名空间
--endregion

--用于声明一个命名空间
--Sample
--namespace "aaa.bbb.ccc"
--{
--    namespace "bb"
--    {
--        namespace "dd"
--        {
--        },
--    },
--    namespace "cc"
--    {
--    }
--}

using "Joop"

local rawget = rawget
local rawset = rawset
local type = type
--local pairs = pairs
local ipairs = ipairs

local SetOnCall = Joop.SetOnCall
local SetMetaKey = Joop.SetMetaKey
local GetJoopTypeInfo = Joop.GetJoopTypeInfo
local JStack = Joop.JStack

local function NewNamespace(name, parentNs)-- 生成新namespace，并放置到parentNs中
    local ns =
    {
        OnFindKey = rawget,
    }
    --BabeLua
    --print("<word>" .. name .. "</word>")
    SetMetaKey(ns, "___typeInfo", {___name = name, ___type = "namespace", ___owner = parentNs})
    if parentNs then
        rawset(parentNs, name, ns)
    end
    return ns
end

local RegisteredNamespaces = NewNamespace("RegisteredNamespaces", false) --保存所有注册的namespace
JStack:Push(RegisteredNamespaces)

-- 检查并拆分name
local function SplitName(name) 
    --检查名字的合法性
    if name == nil or type(name) ~= "string" or name == "" then
        Error("Invalid namespace name : " .. name, 4)
        return nil
    end
    local names = name:Split(".", true)
    for i, nsName in ipairs(names) do
        if not nsName:IsValidVarName() then
            Error("Invalid namespace name : <" .. nsName .. ">", 4)
            return nil
        end
    end
    return names
end

--检查一个对象是不是namespace
local function IsNamespace(obj) 
    return type(obj) == "table" and (GetJoopTypeInfo(obj, "___type") == "namespace")
end

-- 取得已注册的namespace
local function GetNamespace(nsName) 
    local names = SplitName(nsName)
    local parentNs, ns
    parentNs = RegisteredNamespaces
    for _, name in ipairs(names) do
        ns = rawget(parentNs, name)
        if ns == nil then
            Error("Unknown namespace name : <" .. name .. ">", 3)
            return
        end
        if not IsNamespace(ns) then
            Error("<" .. name .. "> is not a namespace", 3)
            return nil
        end
        parentNs = ns
    end
    return ns
end

--在读取{}后出栈
local function OnNamespaceCreated(ns)
    local curStack = JStack:Top()
    if curStack ~= ns then
        Error("stack error. current : <" .. GetJoopTypeName(ns) .. ">, wanted : <" .. GetJoopTypeName(curStack) .. ">", 2)
    else
        JStack:Pop()
    end
    SetOnCall(ns, nil)--取消该ns的metatable的__call
end

-- 定义namespace
local function DefineNamespace(_, name)
    local names = SplitName(name)
    local ns, parentNs
    local size = #names
    local i = 1

    -- 在当前NamespaceStack中查看是否该namespace已经存在
    parentNs = JStack:Top()
    while i <= size do
        if not IsNamespace(parentNs) then
            Error("namespace must be defined under a namespace.", 4)--ok
            return nil
        end        
        ns = rawget(parentNs, names[i])
        if ns == nil then
            break --这个namespace在JStack:Top()中不存在
        end
        if not IsNamespace(ns) then
            Error("Redefined : " .. names[i], 4)
            return nil
        end        
        parentNs = ns --已存在,继续检查下一层
        i = i + 1
    end
    while i <= size do  --生成所有的不存在的namespace
        ns = NewNamespace(names[i], parentNs)
        parentNs = ns
        i = i + 1
    end
    --将当前生成的namespace压栈，在读取{}后出栈(仅为最后一个ns)
    SetOnCall(ns, OnNamespaceCreated)
    JStack:Push(ns)
    return ns
end

keyword "namespace"
{
    ___namespace = 
        function(self)
            SetOnCall(self, DefineNamespace) --代替 JPrototype.___NewPrototype
--            Joop:RegisterOnCall(
--                function(self, fenv, name)
--                    fenv.___KeyFinder:Register(namespace.NamespaceStack)--RegisteredNamespaces
--                end
--                )
        end,

    ___OnCheckName = false,-- 屏蔽掉JPrototypeHelper.NewPrototype中的___OnCheckName, 在RegisterNamespace中CheckName

    --IsNamespace = IsNamespace,
    GetNamespace = GetNamespace,
}
