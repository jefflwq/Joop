--region CContentManager_Tester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CContentManager 类的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

using "System.Tester"
using "System.Collections.Generic"

namespace "Testers.JLib"
{
    namespace "CContentManagerTester"
    {
        class "CContentBase1"
        {
            IsEnabled = false,
            CContentBase1 = 
                function(self)    
                    self.IsEnabled = true
                end,
            OnProcess = 
                function(self, ...)
                    Print("CContentBase1", ...)
                end,
            GetSpecifiedParams = 
                function(self, ...)    
                    return "SpecifiedParam1", "SpecifiedParam2"
                end,
        },
        class "CContentBase2" : IContent
        {
            CContentBase2 = 
                function(self)    
                    self.super(true)
                end,
            OnProcess = 
                function(self, ...)
                    Print("CContentBase2", ...)
                end,
        },
    },
    static_class "CContentManager_Tester" : CJoopTester
    {
        --IsEnabled = true,
        OnTest = 
            function(self, ...)
                local cb1 = CContentManagerTester.CContentBase1()
                local cb2 = CContentManagerTester.CContentBase2()
                local cm = CContentManager()
                cm:Register(cb1)
                cm:Register(cb2)
                cm:ProcessContent()
                Print("==================================================")
                cm:Unregister(cb1)
                cm:ProcessContent()
                Print("==================================================")
                cb2.IsEnabled = false
                cm:ProcessContent()
                Print("==================================================")
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },
}
