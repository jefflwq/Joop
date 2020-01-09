--region enum_Tester.lua
--Author : jefflwq
--Date   : 2016/03/02
--说明   : enum 的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

namespace "aaa"
{
    namespace "bb"
    {
        enum "CC"
        {
            enum "EMA"
            {
                A = "EMA.A",
                B = "EMA.B",
            },
            enum "EMB" : EMA
            {
                A = "EMB.A",
                C = "EMB.C",
            },
            enum "EMB1"
            {
                A = "EMB.A",
                C = "EMB.C",
            },
        },
        --namespace "CC"
        --{
        --},
        enum "EMC"-- : CC     ----枚举类型只能继承自另一个枚举类型
        {
            A = "EMC.A",
            B = 2,
            C =  --可以是function,但是不推荐使用,除非你知道你在干什么
                function()
                    return "func"
                end,
        },
    },
}
using "aaa.bb"

local Test = 
    function()
        --local em = CC() --error枚举型不能实例化
        Print(CC.EMA.A1)
        --Print(cc.EMA.B)
        --EMA.A = "asdf"
        --Print(cc.EMB.A)
        Print(CC.EMB.B)
        Print(CC.EMB.C)
        Print(EMC.A)
        Print(EMC.B)
        Print(EMC.C)
        Print(EMC.C())
        --CC.EMA.Aq = 1
    end
using "System.Tester"

namespace "Testers.Keyword"
{
    static_class "enum_Tester" : CJoopTester
    {
        IsEnabled = true,
        OnTest = 
            function(self, ...)
                Test()
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}


