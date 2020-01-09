--region CJoopTester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CJoopTester类
--endregion

using "Joop"

import "System.Collections.Generic.CSelfRegister"
namespace "System.Tester"
{
    static_class "CJoopTester" : supers(CSelfRegister, CTester)
    {
        IsEnabled = true,
        ___GetSelfRegisterManager = 
            function(self)
                return System.Tester.CTesterManager()
            end,
    },
}
System.Tester.StartTest = 
    function() 
        return System.Tester.CJoopTester.SelfRegisterManager:StartTest() 
    end