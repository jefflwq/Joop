--region CList_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CList 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Collections.Generic"

namespace "Testers.JLib"
{
    static_class "CList_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CList()
                local obj2 = CList()
                obj:Insert("CList1_Item1")
                obj:Insert("CList1_Item2")
                obj:Insert("CList1_Item3")
                obj:Insert("CList1_Item4")
                obj2:Insert("CList2_Item1")
                obj2:Insert("CList2_Item2")
                obj2:Insert("CList2_Item3")
                obj2:Insert("CList2_Item4")
                obj2:Insert("CList2_Item5")
                obj:Merge(obj2,3)
                Print(obj:GetItem(1),obj:GetItem(2),obj:GetItem(3),obj:GetItem(4),obj:GetItem(5),obj:GetItem(6),obj:GetItem(7),obj:GetItem(8),obj:GetItem(9))
                obj:Remove(5)
                Print(obj:GetItem(1),obj:GetItem(2),obj:GetItem(3),obj:GetItem(4),obj:GetItem(5),obj:GetItem(6),obj:GetItem(7),obj:GetItem(8),obj:GetItem(9))
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
