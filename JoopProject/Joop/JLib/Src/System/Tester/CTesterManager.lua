--region CTesterManager.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CTesterManager类
--endregion

using "Joop"

using "System.Collections.Generic"

namespace "System.Tester"
{
    class "CTesterManager" : CContentManager
    {
        StartTest = 
            function(self, ...)
                return self:ProcessContent(...)
            end,
    }
}

