--region CTableString_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CTableString 类的测试程序
--endregion

if false then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Text"

namespace "Testers.JLib"
{
    static_class "CTableString_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CTableString()
                local t1 = { tk1 = "tv1"}
                local t2 = { tk2 = "tv2", tt2 = t1}
                t1.tt1 = t2
                local t = {a = "av", b = "bv", "iv", tb1 = t1, tb2 = t2}
                local s = obj:GetTableString(t)
                Print(s)
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
