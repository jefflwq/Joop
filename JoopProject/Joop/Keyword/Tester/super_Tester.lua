--region super_Tester.lua
--Author : jefflwq
--Date   : 2018/03/26
--说明   : super 的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"
using "System.Tester"
import "System.CType"
import "System.Drawing.CColor"

namespace "Testers.Keyword.SupersTester"
{
    static_class "super_Tester" : CJoopTester
    {
        IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CSuperClass(1,2,3)
                Print(obj)
                obj:Func(1,2,3)
                obj:FuncWrongCall(1,2,3)
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
    class "CBaseClass"
    {
        CBaseClass = 
            function(self, ...)
                Print("CBaseClass.ctor", self, ...)
            end,
        Func = 
            function(self, ...)
                Print("CBaseClass.Func", self, ...)
            end,
        FuncWrongCall = 
            function(self, ...)
                Print("CBaseClass.FuncWrongCall", self, ...)
            end,
    },
    class "CSuperClass" : CBaseClass
    {
        CSuperClass = 
            function(self, ...)
                self.super(...)
                Print("CSuperClass.ctor", self, ...)
            end,
        Func = 
            function(self, ...)
                self.super.Func(...)
                Print("CSuperClass.Func", self, ...)
            end,
        FuncWrongCall = 
            function(self, ...)
                self.super:FuncWrongCall(...)
                Print("CSuperClass.FuncWrongCall", self, ...)
            end,
    },
}
