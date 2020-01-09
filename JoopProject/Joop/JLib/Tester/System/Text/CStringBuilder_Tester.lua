--region CStringBuilder_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CStringBuilder 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Text"

namespace "Testers.JLib"
{
    static_class "CStringBuilder_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CStringBuilder()
                obj:Insert("sq1")
                obj:Insert("sq2")
                obj:Insert("sq3")
                obj:Insert("sq4")
                Print(obj:BuildString())
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
