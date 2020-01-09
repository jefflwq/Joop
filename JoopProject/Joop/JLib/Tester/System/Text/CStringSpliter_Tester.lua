--region CStringSpliter_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CStringSpliter 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Text"

namespace "Testers.JLib"
{
    static_class "CStringSpliter_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CStringSpliter()
                obj.Spliter = "."
                obj.IgnoreEmpty = false
                obj.Plain = true
                obj:Split("ab.asd.fa.sfasd..fasdf")
                Print(obj:Size(), obj:GetItem(1), obj:GetItem(2), obj:GetItem(3), obj:GetItem(4), obj:GetItem(5), obj:GetItem(6))
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
