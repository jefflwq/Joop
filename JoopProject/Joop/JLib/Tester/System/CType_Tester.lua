--region CType_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CType 类的测试程序
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
    static_class "CType_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                --local obj = CType()
                --local tbls = 
                      --{
                        --s1 = 3,
                        --S2 = 4,
                      --}
                --local obj = CType(tbls)
                --Print(obj.LuaType)
                --Print(obj.JoopType)
                --Print(obj.TypeName)
                --Print(obj:GetJoopFullType())
                --local var = CVarString()
                --Print(var:GetVarString(obj))
                --obj = CType(var)
                --Print(obj.LuaType)
                --Print(obj.JoopType)
                --Print(obj.TypeName)
                --Print(obj:GetJoopFullType())
                --obj = CType(CVarString)
                --Print(obj.LuaType)
                --Print(obj.JoopType)
                --Print(obj.TypeName)
                --Print(obj:GetJoopFullType())
                --obj = CType(CStringSpliter)
                --Print(obj.LuaType)
                --Print(obj.JoopType)
                --Print(obj.TypeName)
                --Print(obj:GetJoopFullType())
                --obj = CType(CStringSpliter())
                --Print(obj.LuaType)
                --Print(obj.JoopType)
                --Print(obj.TypeName)
                --Print(obj:GetJoopFullType())
                --obj = CType(class)
                --Print(obj.LuaType)
                --Print(obj.JoopType)
                --Print(obj.TypeName)
                --Print(obj:GetJoopFullType())
                --obj = CType(System)
                --Print(obj.LuaType)
                --Print(obj.JoopType)
                --Print(obj.TypeName)
                --Print(obj:GetJoopFullType())
                --obj = CType(keyword)
                --Print(obj.LuaType)
                --Print(obj.JoopType)
                --Print(obj.TypeName)
                --Print(obj:GetJoopFullType())
                --obj = CType(CColor.EmColor)
                --Print(obj.LuaType)
                --Print(obj.JoopType)
                --Print(obj.TypeName)
                --Print(obj:GetJoopFullType())
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
