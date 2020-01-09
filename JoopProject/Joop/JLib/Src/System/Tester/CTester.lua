--region CTester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CTester类
--endregion

using "Joop"

local Print = Print
local GetJoopTypeName = GetJoopTypeName

using "System.Collections.Generic"

namespace "System.Tester"
{
    class "CTester" : IContent
    {
        OnProcess = 
            function(self, ...)
                Print("\n==========", GetJoopTypeName(self) .. ":OnTest() Start ...", "==========")
                Print("Param is :", ...)
                Print("Return value is :", self:OnTest(...))
                Print(  "==========", GetJoopTypeName(self) .. ":OnTest() End .....", "==========")
            end,
        OnTest = 
            function(self, ...)
                Print("you should override this function and add your own test code for special testclass.")
            end,
    }
}

