--region CDynamicList_Tester.lua
--Author : jefflwq
--Date   : 2018/4/25
--说明   : CDynamicList 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Collections.Generic"
using "System.Drawing"

namespace "Testers.JLib"
{
    static_class "CDynamicList_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local obj = CDynamicList(table)
                local t = obj:Add()
                t.Key = 1
                t = obj:Add(2)
                t.Key = 2
                obj:GetItem(3).Key = 3
                print("obj:Size()", obj:Size(), #obj.ListData)
                self:PrintObj(obj)
                obj:Resize(5)
                print("obj:Resize(5)", obj:Size(), #obj.ListData)
                self:PrintObj(obj)
                obj:Resize(2)
                print("obj:Resize(2)", obj:Size(), #obj.ListData)
                self:PrintObj(obj)
                obj:Resize(7)
                print("obj:Resize(7)", obj:Size(), #obj.ListData)
                self:PrintObj(obj)

                obj:Insert(nil)
                print("obj:Insert(nil)", obj:Size(), #obj.ListData)
                self:PrintObj(obj)
                obj:Insert(nil, 11)
                print("obj:Insert(nil, 11)", obj:Size(), #obj.ListData)
                self:PrintObj(obj)
                obj:Insert({Key=13}, 13)
                print("obj:Insert({Key=13}, 13)", obj:Size(), #obj.ListData)
                self:PrintObj(obj)
                obj:Insert({Key=5}, 5)
                print("obj:Insert({Key=5}, 5)", obj:Size(), #obj.ListData)
                self:PrintObj(obj)
                obj:Remove(5)
                print("obj:Remove(5), 5)", obj:Size(), #obj.ListData)
                self:PrintObj(obj)
                obj:Resize(2, true)
                print("obj:Resize(2, true)", obj:Size(), #obj.ListData)
                self:PrintObj(obj)

            end,

        PrintObj = 
            function(self, obj)    
                for i = 1, obj:Size() do
                    local item = obj:GetItem(i)
                    if item then
                        print("Key" .. i, item.Key)
                    else
                        print("Key" .. i, "___Nil")
                    end
                end
            end,

        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
