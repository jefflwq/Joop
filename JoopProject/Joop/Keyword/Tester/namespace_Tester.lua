--region namespace_Tester.lua
--Author : jefflwq
--Date   : 2016/03/02
--说明   : namespace 的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

--namespace可以很灵活的定义,下面这些都是合法的定义方式
namespace "nsa.nsb"
{
    namespace "nsc1"
    {
        namespace "nsd.nse"
        {
        },
    },
    namespace "nsc2"
    {
    }
}
--上面定义结构实际上是这样的
--nsa
--{
--    nsb
--    {
--        nsc1
--        {
--            nsd
--            {
--                nse
--            }
--        },
--        nsc2,
--    }
--}
--用using 引用一个namespace后,在这个文件里就可以直接使用该namespace里的名字了.(仅当前文件有效)
using "nsa.nsb"
using "nsa.nsb.nsc1.nsd.nse"
using "nsa.nsb.nsc2"

using "System.Tester"

namespace "Testers.Keyword"
{
    static_class "namespace_Tester" : CJoopTester
    {
        --IsEnabled = true,

        TestNamespace = 
            function()
                Print("nsa :", nsa)
                Print("nsb :", nsb, "--because not [using \"nsa\"], so [nsb] can't be found.")--因为没有 using \"nsa\", 所以只写nsb是找不到的
                Print("nsa.nsb :", nsa.nsb)
                Print("nsc1 :", nsc1)
                Print("nsc2 :", nsc2)
                Print("nsd :", nsd, "--because not [using \"nsa.nsb.nsc1\"], so [nsd] can't be found.")--因为没有 using \"nsa.nsb.nsc1\", 所以只写nsd是找不到的
                Print("nse :", nse, "--because not [using \"nsa.nsb.nsc1.nsd\"], so [nse] can't be found.")--因为没有 using \"nsa.nsb.nsc1.nsd\", 所以只写nse是找不到的
                Print("nsa.nsb.nsc1.nsd.nse :", nsa.nsb.nsc1.nsd.nse)
                Print("nsc1.nsd.nse :", nsc1.nsd.nse)
            end,
        OnTest = 
            function(self, ...)
                self:TestNamespace()
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
