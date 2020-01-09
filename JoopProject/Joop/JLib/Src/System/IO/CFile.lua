--region CFile.lua
--Author : jefflwq
--Date   : 2015/3/27
--说明   : CFile类
--endregion

using "Joop"

namespace "System.IO"
{
    class "CFile"
    {
        Path = false,
        Mode = false,
        File = false,
        Open = 
            function(self, path , mode)
                self:Close()
                self.Path = path or self.Path
                self.Mode = mode or "r"
                self.File = assert(io.open(self.Path, self.Mode))
                return self.File
            end,
        Close = 
            function(self)
                if self.File then
                    self.File:close()
                    self.File = false
                end
            end,
        ReadAll = 
            function(self)
                if self.File then
                    return self.File:read("*all")
                end
            end,
        Write = 
            function(self, str)
                if self.File then
                    return self.File:write(str)
                end
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
