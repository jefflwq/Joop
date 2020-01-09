--region CStack.lua
--Author : jefflwq
--Date   : 2016/02/28
--说明   : 堆栈类
--endregion

--local Get_OnFindKey = JKeyFinder.Get_OnFindKey

using "Joop"

namespace "System.Collections.Generic"
{
    class "CStack"
    {
        StackData = false,

        CStack =
            function (self)
                self.StackData = {}
            end,

        Push =
            function (self, obj)
                table.insert(self.StackData, obj)
            end,

        Pop = 
            function (self)
                local size = #self.StackData
                if size > 0 then
                    local obj = self.StackData[size]
                    table.remove(self.StackData, size)
                    return obj
                end
            end,

        Top = 
            function (self)
                local size = #self.StackData
                if size > 0 then
                    return self.StackData[size]
                end
            end,

        Get = 
            function (self, depth)
                depth = #self.StackData - (depth or 0)
                if depth > 0 then
                    return self.StackData[depth]
                else
                    return nil
                end
            end,

        Clear = 
            function (self)
                while #self.StackData > 0 do
                    table.remove(self.StackData, #self.StackData)
                end
            end,

        Size = 
            function (self)
                return #self.StackData
            end,

        --返回obj的堆栈深度, 如果未找到,返回-1
        GetDepth = 
            function (self, obj)
                local depth = #self.StackData
                while depth > 0 do
                    if self.StackData[depth] == obj then
                        return #self.StackData - depth
                    end
                    depth = depth - 1
                end
                return -1
            end,

        --如果不指定depth, 则遍历堆栈中的所有元素, 返回找到的对象和堆栈深度
        FindElementKey = 
            function (self, key, depth)
                if depth == nil then
                    local v
                    for i = 0, #self.StackData do
                        v, depth = self:FindElementKey(key, i)
                        if v ~= nil then
                            return v, depth
                        end
                    end
                else
                    local curStack = self:Get(depth)
                    if curStack ~= nil then
                        v = curStack[key]
                        if v ~= nil then
                            return v, depth
                        end
                    end
                end
            end,

        OnFindKey = 
            function (self, key)
                local f,v
                for _, finder in ipairs(self.StackData) do
                    --f = Get_OnFindKey(finder)
                    f = rawget(finder, "OnFindKey")
                    if f then
                        v = f(finder, key)
                        if v then
                            return v
                        end
                    end
                end
            end
    }
}
