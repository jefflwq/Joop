--region CJoopTester.lua
--Author : jefflwq
--Date   : 2015/2/28
--说明   : CJoopTester类
--endregion

using "Joop"

local super___OnRegister = class.___OnRegister
namespace "System.Collections.Generic"
{
    class "CSelfRegister"
    {
        IsEnabled = true,
        SelfRegisterManager = false,

        ___OnRegister = --响应static_class的___OnRegister事件,把Class注册到Manager当中
            function(self)
                super___OnRegister(self)
                self.___OnRegister = self.___InitSelfRegister
                return true
            end,
        ___InitSelfRegister =
            function(self)
                super___OnRegister(self)
                self.SelfRegisterManager = self:___GetSelfRegisterManager()
                if not self.SelfRegisterManager or type(self.SelfRegisterManager.Register) ~= "function" then
                    Error("SelfRegisterManager must have a function named 'Register'.", 3)
                    return false
                end
                self.___OnRegister = self.___RegisterSelf
                return true
            end,
        ___RegisterSelf =
            function(self)
                super___OnRegister(self)
                return self:OnRegisterSelf()
            end,
        ___GetSelfRegisterManager =
            function(self)
                return CContentManager()
            end,
        OnRegisterSelf =
            function(self)
                if type(self.OnInit) == "function" then
                    if self:OnInit() == false then
                        return
                    end
                end
                --自注册到Manager中
                if self.SelfRegisterManager then
                    self.SelfRegisterManager:Register(self)
                end
                if type(self.OnPostRegisterSelf) == "function" then
                    if self:OnPostRegisterSelf() == false then
                        return
                    end
                end
                return true
            end,
        ProcessAll =
            function(self, ...)
                return self.SelfRegisterManager:ProcessContent(...)
            end,
    },
}
