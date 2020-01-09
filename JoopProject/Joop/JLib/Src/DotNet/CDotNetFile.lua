--region CFile.lua
--Author : jefflwq
--Date   : 2015/3/27
--说明   : CFile类
--endregion

using "Joop"
require "luanet"
----加载CLR的类型、实例化CLR对象
luanet.load_assembly("System")
luanet.load_assembly("System.IO")
local ___DotNetFile = luanet.import_type("System.IO.File")

namespace "DotNet"
{
    static_class "CDotNetFile"
    {
        DotNetFile = ___DotNetFile,
        CompareModifyTime =
            function(self, path1, path2) 
                if not ___DotNetFile.Exists(path1) then
                    if not ___DotNetFile.Exists(path2) then
                        return false
                    else
                        return -2
                    end
                elseif not ___DotNetFile.Exists(path2) then
                    return 2
                end
                return ___DotNetFile.GetLastWriteTime(path1):CompareTo(___DotNetFile.GetLastWriteTime(path2))
            end,
        --GetModifyTime =
        --    function(self, path) 
        --        return RunVbs("GetFileModifyTime.vbs", path or self.Path)
        --    end,

    --    GetLength =
    --        function(self) 
                --local fh = assert(io.open(filename, "rb"))
                --local len = assert(fh:seek("end"))
                --fh:close()
                --return len
    --        end,

        Exists =
            function(self, path) 
               local f = io.open(path or self.Path, "rb")
               if f then f:close() end
               return f ~= nil
            end,

    }
}
