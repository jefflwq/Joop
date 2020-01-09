--region CColor_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CColor 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Drawing"

namespace "Testers.JLib"
{
    static_class "CColor_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CColor(EColor.Purple, 0.5)
                obj:SetColor(EColor.Purple)
                Print(obj.RGB, obj.R,obj.G, obj.B, obj.Alpha)
                obj:SetColor(128, 140, 158)
                Print(obj.RGB, obj.R,obj.G, obj.B, obj.Alpha)
                obj:SetR(160)
                Print(obj.RGB, obj.R,obj.G, obj.B, obj.Alpha)
                obj:SetG(170)
                Print(obj.RGB, obj.R,obj.G, obj.B, obj.Alpha)
                obj:SetB(180)
                Print(obj.RGB, obj.R,obj.G, obj.B, obj.Alpha)
                obj:SetB(0.4)
                Print(obj.RGB, obj.R,obj.G, obj.B, obj.Alpha)
                obj:SetRGB("ffeedd")
                Print(obj.RGB, obj.R,obj.G, obj.B, obj.Alpha)
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
