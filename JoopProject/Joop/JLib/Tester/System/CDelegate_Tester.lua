--region CDelegate_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CDelegate 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System"
using "System.Tester"
using "System.Collections.Generic"

namespace "Testers.JLib"
{
    static_class "CDelegate_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local lst = CList()
                local obj = CDelegate(lst,lst.Insert)
                obj:Run(1)
                obj:Run(2)
                obj:Run(3)
                Print(lst:GetItem(1),lst:GetItem(2),lst:GetItem(3))
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
