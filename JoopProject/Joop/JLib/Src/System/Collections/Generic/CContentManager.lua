--region CContentManager.lua
--Author : jefflwq
--Date   : 2015/2/26
--说明   : 内容管理器,可以将实现 IContent接口的对象添加到 CContentManager中,以实现自动调用该对象
--endregion

using "Joop"

namespace "System.Collections.Generic"
{
    class "IContent" --只要实现这个接口中的函数即可,不是必须从这个类派生
    {
        IsEnabled = true,

        OnProcess = false,
            --function(self, ...)
                --return nil --继续下一个
            --end,
        GetSpecifiedParams = false, --你可以定义这个函数以指定传递给OnProcess的参数
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
    },

    class "CContentManager" : CList
    {
--        CContentManager = 
--            function(self, ...)
--                self.m_ContentList = CList() 
--            end,

        Register = 
            function(self, content)
                if content == nil then
                    return false
                end
                if self:Contains(content) then
                    return false
                end
                self:Insert(content)
                return true
            end,

        Unregister = 
            function(self, content)
                if content == nil then
                    return false
                end
                if not self:Contains(content) then
                    return false
                end
                self:RemoveItem(content)
                return true
            end,
        ProcessContent = 
            function(self, ...)
                local content
                local ret = nil
                local i
                for i = 1, self:Size() do
                    content = self:GetItem(i)
                    if content.IsEnabled and content.OnProcess then
                        if content.GetSpecifiedParams then
                            ret = content:OnProcess(content:GetSpecifiedParams(...))
                        else
                            ret = content:OnProcess(...)
                        end
                        if ret ~= nil then
                            return ret
                        end
                    end
                end
                return nil
            end,
    }
}
