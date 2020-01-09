--region import.lua
--Author : jefflwq
--Date   : 2016/03/03
--说明   : 引用一个类
--endregion

using "Joop"

local rawset = rawset
local getfenv = getfenv
local ipairs = ipairs
local JStack = Joop.JStack
local GetJoopTypeName = Joop.GetJoopTypeName

local function GetJoopType(fullName)
    local names = fullName:Split(".", true)
    local parent = JStack:Top()
    local t
    for _, name in ipairs(names) do
        t = parent[name]
        if t == nil then
            Error("Unknown type: <" .. fullName .. ">", 3)
            return
        end
        parent = t
    end
    return t
end

local function ImportToCache(self, fullName)
    local fileEnv = getfenv(2)
    local t = GetJoopType(fullName)
    rawset(fileEnv.___Cache, GetJoopTypeName(t), t)
end

keyword "import"
{
    ___import = 
        function(self)
            SetOnCall(self, ImportToCache)
        end,
}
