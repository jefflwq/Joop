--region CArgList.lua
--Author : jefflwq
--Date   : 2016/02/28
--说明   : 参数列表类
--endregion

using "Joop"

namespace "System.Collections.Generic"
{
    class "CArgList" : CList
    {
        CArgList = 
            function(self, ...)
                self.super({...})
                --self:SetArgs(...)
            end,

        SetArgs = 
            function(self, ...)
                self:Clear()
                self:AddArgs(...)
            end,

        AddArgs = 
            function(self, ...)
                local n = select("#", ...)
                local s
                for i = 1, n do
                    s = select(i, ...)
                    self:Insert(s)
                end
            end,
    }
}
