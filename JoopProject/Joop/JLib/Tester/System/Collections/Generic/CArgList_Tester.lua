--region CArgList_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CArgList 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Collections.Generic"

namespace "Testers.JLib"
{
    static_class "CArgList_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CArgList(1,2,3)
                Print(obj:GetItem(1),obj:GetItem(2),obj:GetItem(3))
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
