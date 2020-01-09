--region CEventManager.lua
--Author : jefflwq
--Date   : 2015/2/27
--说明   : CEventManager类
--endregion

using "Joop"

import "System.CEvent"

namespace "System"
{
    class "CEventManager" 
    {
        m_Events = false, --以eventName为key保存为{}，可能对应多个event
        CEventManager = 
            function(self)
                self.m_Events = {}
            end,

        OnEvent = 
            function (self, sender, eventName, ...)
                local events = self.m_Events[eventName]
                if not events then
                    return
                end
                for _, e in pairs(events) do
                    --- 执行函数
                    e:Fire(sender, ...)
                end
            end,
        ---注册事件 
        ---用法1：event = mgr:Register("EVENT_NAME", CDelegate(obj, func))
        ---用法2：event = mgr:Register(CEvent("EVENT_NAME", CDelegate(obj, func)))
        ---如果该Event需要注销的话，请务必保存注册时返回的event，在注销时作为参数传入Unregister
        Register = 
            function(self, eventOrName, delegateOrFuncName, handler) 
                -- 仅注册一次
                local event = self:Contains(eventOrName, delegateOrFuncName, handler)
                if event then
                    return event
                end
                local name
                if string.IsTypeOf(eventOrName) then
                    name = eventOrName
                    event = CEvent(name, delegateOrFuncName, handler)
                elseif CEvent:IsTypeOf(eventOrName) then
                    name = eventOrName.Name
                    event = eventOrName
                else
                    return
                end

                local t
                t = self.m_Events[name]
                if not t then
                    t = {}
                    self.m_Events[name] = t
                end
                t[tostring(event)] = event
                self:OnRegister(name, event)
                return event
            end,
        Contains = --查找是否已注册
            function(self, eventOrName, delegateOrFuncName, handler) 
                local events
                if CEvent:IsTypeOf(eventOrName) then
                    events = self.m_Events[eventOrName.Name]
                    if not events then
                        return
                    end
                    if not delegateOrFuncName then --仅指定了event
                        return events[tostring(eventOrName)]
                    end
                elseif string.IsTypeOf(eventOrName) then
                    events = self.m_Events[eventOrName]
                    if not events then
                        return
                    end
                    if not delegateOrFuncName then --仅指定了eventName
                        return events
                    end
                else
                    return
                end
                if type(delegateOrFuncName) == "string" then
                    for _, event in pairs(events) do
                        if event.FuncName == delegateOrFuncName then --按函数名查找
                            if not handler then --未指定handler时，返回event
                                return event
                            else --指定了handler，则需继续查找handler
                                local delegate = event:Contains(handler)
                                if delegate then
                                    return event, delegate
                                end
                            end
                        end
                    end
                elseif CDelegate:IsTypeOf(delegateOrFuncName) then --按委托查找
                    for  _, event in pairs(events) do
                        local delegate = event:Contains(delegateOrFuncName)
                        if delegate then
                            return event, delegate
                        end
                    end
                end
            end,
        OnRegister = 
            function(self, eventName, event) ---注册事件
                --在子类中重写
            end,

        --- eventOrName为string时将清除所有event
        --- eventOrName为CEvent时将清除指定event
        Unregister = --self.m_Events={"EVENT" = {"eventA" = CEvent}}
            function (self, eventOrName)
                if string.IsTypeOf(eventOrName) then
                    self:OnUnregister(eventOrName)
                    self.m_Events[eventOrName] = nil
                    return true
                end
                if not (CEvent:IsTypeOf(eventOrName)) then
                    return
                end

                local eventName = eventOrName.Name
                local t = self.m_Events[eventName]
                if not t then --未注册该Event
                    return
                end
                local key = tostring(eventOrName)
                if t[key] then
                    t[key] = nil
                end
                if table.Count(t) <= 0 then
                    self.m_Events[eventName] = nil
                    self:OnUnregister(eventName)
                end
                return true
            end,
        OnUnregister = 
            function(self, eventName) ---注消事件
                --在子类中重写
            end,
    }
}