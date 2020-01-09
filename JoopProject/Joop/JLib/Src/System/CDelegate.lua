--region CDelegate.lua
--Author : jefflwq
--Date   : 2015/2/19
--说明   : 事件控制类
--endregion

using "Joop"

--local SetOnCall = SetOnCall
import "System.Collections.Generic.CArgList"

namespace "System"
{
    class "CDelegate"
    {
        PutAdditionalParamToTail = false,
        AdditionalParamCount = false,
        Object = false,
        Function = false,
        Params = false,
        SavedToFunc = false,
        CDelegate = 
            function(self, obj, func, ...)
                self.PutAdditionalParamToTail = false
                self.AdditionalParamCount = 0
                self:Set(obj, func, ...)
                --SetOnCall(self, self.Run)
            end,
        Set = 
            function (self, obj, func, ...)
                self.Object = obj or false
                self.Function = func or false
                if type(func) == "string" then
                    self.Function = obj[func] or false
                elseif type(func) == "function" then
                    self.Function = func
                else
                    self.Function = false
                end
                self.Params = CArgList(...)
            end,
        ToFunc = 
            function (self)
                self.SavedToFunc = function(...) return self:Run(...) end
                return self.SavedToFunc
            end,

--        ToFunc = 
--            function (self)
--                return function(...) self:Run(...) end
--            end,

        Run = 
            function (self, ...)
                if not self.Function then
                    return nil
                end
                if self.Params:Size() == 0 then
                    if self.Object then
                        return self.Function(self.Object, ...)
                    else
                        return self.Function(...)
                    end
                else
                    if self.Object then
                        return self.Function(self.Object, self:UnpackParams(...))
                    else
                        return self.Function(self:UnpackParams(...))
                    end
                end
            end,
        UnpackParams = 
            function (self, ...)
                self.AdditionalParamCount = select("#", ...)
                if self.AdditionalParamCount == 0 then
                    return self.Params:Unpack()
                elseif self.PutAdditionalParamToTail then
                    return self.Params:Unpack(...)
                else
                    local arglist = CArgList(...)
                    return arglist:Unpack(self.Params:Unpack())
                end
            end,
    }
}
