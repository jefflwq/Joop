--region CEvent.lua
--Author : jefflwq
--Date   : 2015/3/8
--说明   : 事件处理
--endregion

using "Joop"

namespace "System"
{
    class "CEvent"
    {
        Name = false,
        FuncName = false,
        Delegates = false,
        CEvent = 
            function(self, name, delegateOrFuncName, handler)
                self.Name = name or false
                self.Delegates = {}
                if not delegateOrFuncName then
                    return
                end
                if self:AddDelegate(delegateOrFuncName) then
                    return
                end
                if type(delegateOrFuncName) == "string" and delegateOrFuncName ~= "" then
                    self.FuncName = delegateOrFuncName
                    self:AddHandler(handler)
                end
            end,
        Contains = --查找Event中是否已有该委托
            function(self, delegateOrHandler)
                if not delegateOrHandler then
                    return
                end
                if CDelegate:IsTypeOf(delegateOrHandler) then
                    return self.Delegates[tostring(delegateOrHandler)]
                end
                local func = GetFunc(delegateOrHandler, self.FuncName)
                if not func then
                    return
                end
                for _, delegate in pairs(self.Delegates) do
                    if delegate.Object == delegateOrHandler and delegate.Function == func then
                        return delegate
                    end
                end
            end,
        AddHandler = 
            function (self, handler) --handler is a table
                if not handler then
                    return
                end
                local func = GetFunc(handler, self.FuncName)
                if not func then
                    return
                end
                local delegate = CDelegate(handler, func)
                self.Delegates[tostring(delegate)] = delegate
                return delegate
            end,
        AddDelegate = 
            function (self, delegate)
                if type(delegate) ~= "table" or not CDelegate:IsTypeOf(delegate) then
                    return
                end
                self.Delegates[tostring(delegate)] = delegate
                return delegate
            end,
        Remove = 
            function (self, delegateOrHandler)
                local delegate = self:Contains(delegateOrHandler)
                if delegate then
                    self.Delegates[tostring(delegate)] = nil
                    return delegate
                end
            end,
        Count = 
            function (self)
                return table.Count(self)
            end,

   --     MakeDelegateID = 
            --function (self, obj, func)
            --    return tostring(obj) .. tostring(func)
            --end,
        Fire = 
            function (self, sender, ...)
                for _, delegate in pairs(self.Delegates) do
                    delegate:Run(self.Name, sender, ...)
                end
            end,
--        OnXXXX = 
--            function (self, eventName, sender, ...)
--            end,
    }
}
