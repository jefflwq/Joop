--region keyword_Tester.lua
--Author : jefflwq
--Date   : 2016/03/02
--说明   : keyword的测试类
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

keyword "kwd1"
{
}
    
keyword "kwd2" : kwd1
{
}
keyword "kwd3" : kwd2
{
}

using "System.Tester"

namespace "Testers.Keyword"
{
    static_class "keyword_Tester" : CJoopTester
    {
        IsEnabled = true,
--        OnTest = 
--            function(self, ...)
--                --write your test code here
--                --local obj = CXXX()
--                Print("Welcom for using JoopTester.")
--                return "CJoopTester:OnTest()'s return value."
--            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
