--region CInfo.lua
--Author : jefflwq
--Date   : 2016/08/14
--说明   : CInfo类
--endregion

using "Joop"

namespace "System.Diagnostics"
{
    class "CInfo"
    {
        FatalError = 1000,
        Exception = 2000,
        Error = 3000,
        Warning = 4000,
        Info = 5000,
        --Debug = 10000,
        DebugMode = false,
        Threshold = 0,
        Title = false,
        CInfo = 
            function(self, title, threshold)
                self.Title = title or false
                self.Threshold = threshold or self.Info
            end,

        Print = 
            function(self, infoLevel, ...)
                if infoLevel <= self.Threshold then
                    if self.Title then
                        print(self.Title, ...)
                    else
                        print(...)
                    end
                end
            end,
        Debug = 
            function(self, ...)
                if self.DebugMode then
                    print(...)
                end
            end,
        DebugWithTitle = 
            function(self, ...)
                if self.DebugMode then
                    if self.Title then
                        print(self.Title, ...)
                    else
                        print(...)
                    end
                end
            end,
    }
}
