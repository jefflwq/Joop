--region CPairList.lua
--Author : jefflwq
--Date   : 2016/02/28
--说明   : CPairList类
--endregion

using "Joop"

namespace "System.Collections.Generic"
{
    class "CPairList" : CPair
    {
        CPairList = 
            function(self)
                self.super()
            end,

        Size = 
            function(self) 
                return #self.Keys
            end,

        GetKeyIndex = 
            function(self, key)
                for i, k in ipairs(self.Keys) do
                    if k == key then
                        return i
                    end
                end
            end,

        GetByIndex = 
            function(self, index)
                local key = self.Keys[index]
                if key then
                    return key, self.Keys[key]
                end
            end,

        Insert = 
            function(self, key, value)
                if not self.super.Insert(key, value) then
                    return false
                end
                table.insert(self.Keys, key)
                return true
            end,

        Remove = 
            function(self, key)
                if self.Keys[key] == nil then
                    return false
                end
                local index = self:GetKeyIndex(key)
                self.Keys[key] = nil
                table.remove(self.Keys, index)
                return true
            end,

        RemoveByIndex = 
            function(self, index)
                if index <= 0 or index > #self.Keys then
                    return false
                end
                self.Keys[self.Keys[index]] = nil
                table.remove(self.Keys, index)
                return true
            end,
    }
}
