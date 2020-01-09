--region using.lua
--Author : jefflwq
--Date   : 2016/02/24
--说明   : 引用一个命名空间
--endregion

using "Joop"

local getfenv = getfenv
local GetNamespace = namespace.GetNamespace
local usingJoop = using 

local function UsingNamespace(self, name)
    if name == "Joop" then
        usingJoop(name, 4)
        return 
    end
    local fileEnv = getfenv(2)
    fileEnv.___KeyFinder:Register(GetNamespace(name))                --注册ns到fileEnv.KeyFinder
end

keyword "using"
{
    ___using = 
        function(self)
            SetOnCall(self, UsingNamespace)
            _G.using = self
        end,
}
