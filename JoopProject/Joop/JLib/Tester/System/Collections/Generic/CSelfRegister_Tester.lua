--region CSelfRegister_Tester.lua
--Author : jefflwq
--Date   : 2016/03/06
--说明   : CSelfRegister 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Collections.Generic"

namespace "Testers.JLib.SelfRegister"
{
    static_class "CSelfRegisterBase" : CSelfRegister
    {
        OnProcess =
            function(self)
                Print("CSelfRegisterBase")
            end,
    },
    static_class "CSelfRegisterBase2" : CSelfRegister
    {
        OnProcess =
            function(self)
                Print("CSelfRegisterBase2")
            end,
    },
    class "CSelfRegisterA" : CSelfRegisterBase
    {
        OnProcess =
            function(self)
                Print("CSelfRegisterA")
            end,
    },
    class "CSelfRegisterB" : CSelfRegisterBase
    {
        OnProcess =
            function(self)
                Print("CSelfRegisterB")
            end,
    },
    class "CSelfRegisterC" : CSelfRegisterBase
    {
        OnProcess =
            function(self)
                Print("CSelfRegisterC")
            end,
    },
    class "CSelfRegisterA2" : CSelfRegisterBase2
    {
        OnProcess =
            function(self)
                Print("CSelfRegisterA2")
            end,
    },
    class "CSelfRegisterB2" : CSelfRegisterBase2
    {
        OnProcess =
            function(self)
                Print("CSelfRegisterB2")
            end,
    },
    class "CSelfRegisterC2" : CSelfRegisterBase2
    {
        OnProcess =
            function(self)
                Print("CSelfRegisterC2")
            end,
    },
    
    static_class "CSelfRegister_Tester" : CJoopTester
    {
        IsEnabled = true,
        OnTest = 
            function(self, ...)
                CSelfRegisterBase.SelfRegisterManager:ProcessContent()
                Print("==========")
                CSelfRegisterBase2.SelfRegisterManager:ProcessContent()
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
