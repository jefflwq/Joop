--region CUtf8String_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CUtf8String 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Text"

namespace "Testers.JLib"
{
    static_class "CUtf8String_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CUtf8String("阿三地方asdf发的")
                Print(obj:Sub())
                Print(obj:Sub(1, 5))
                Print(obj:Sub(5, 6))
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
