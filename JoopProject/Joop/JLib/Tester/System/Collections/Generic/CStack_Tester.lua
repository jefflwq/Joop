--region CStack_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CStack 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Collections.Generic"

namespace "Testers.JLib"
{
    static_class "CStack_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CStack()
                obj:Push(1)
                obj:Push(2)
                obj:Push(3)
                obj:Push(4)
                Print(obj:Size(), obj:Top(),obj:Get(3))
                obj:Pop()
                Print(obj:Size(), obj:Top(),obj:Get(3))
                obj:Pop()
                Print(obj:Size(), obj:Top(),obj:Get(3))
                obj:Clear()
                Print(obj:Size(), obj:Top(),obj:Get(3))
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
