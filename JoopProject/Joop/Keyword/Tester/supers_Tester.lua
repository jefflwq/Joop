--region supers_Tester.lua
--Author : jefflwq
--Date   : 2016/03/02
--说明   : supers 的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"
using "System.Tester"
import "System.CType"
import "System.Drawing.CColor"
import "System.Drawing.EColor"

namespace "Testers.Keyword.SupersTester"
{
    static_class "supers_Tester" : CJoopTester
    {
        IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CMultiSuper()
                Print(obj:GetJoopTypeName()) --true, false
                --obj:SetColor(EColor.Red)
                Print(obj.RGB, obj.R, obj.G, obj.B)
                local obj2 = CMultiSuper2()
                local obj3 = CMultiSuper3()
                local obj4 = CMultiSuper4()
                print("CBase1:IsTypeOf(obj2)", CBase1:IsTypeOf(obj2))
                print("CBase2:IsTypeOf(obj2)", CBase2:IsTypeOf(obj2))
                print("CBase3:IsTypeOf(obj2)", CBase3:IsTypeOf(obj2))
                print("CBase4:IsTypeOf(obj2)", CBase4:IsTypeOf(obj2))
                print("CBase1:IsTypeOf(obj3)", CBase1:IsTypeOf(obj3))
                print("CBase2:IsTypeOf(obj3)", CBase2:IsTypeOf(obj3))
                print("CBase3:IsTypeOf(obj3)", CBase3:IsTypeOf(obj3))
                print("CBase4:IsTypeOf(obj3)", CBase4:IsTypeOf(obj3))
                print("CBase1:IsTypeOf(obj4)", CBase1:IsTypeOf(obj4))
                print("CBase2:IsTypeOf(obj4)", CBase2:IsTypeOf(obj4))
                print("CBase3:IsTypeOf(obj4)", CBase3:IsTypeOf(obj4))
                print("CBase4:IsTypeOf(obj4)", CBase4:IsTypeOf(obj4))
                --Print(obj.super[CType].GetJoopTypeName())
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
    class "CMultiSuper" : supers(CType, CColor)
    {
        CMultiSuper = 
            function(self)
                CType.CType(self, self)
                CColor.CColor(self, 0.1, 0.2, 0.3, 0.5)
            end,
    },
    class "CBase1"
    {
    },
    class "CBase2"
    {
    },
    class "CBase3"
    {
    },
    class "CBase4"
    {
    },
    class "CMultiSuper2" : supers(CBase1, CBase2)
    {
    },
    class "CMultiSuper3" : supers(CBase3, CBase4)
    {
    },
    class "CMultiSuper4" : supers(CMultiSuper2, CMultiSuper3)
    {
    },
}
