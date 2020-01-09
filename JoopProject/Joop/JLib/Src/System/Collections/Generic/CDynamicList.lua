--region CDynamicList.lua
--Author : jefflwq
--Date   : 2018/04/25
--说明   : 动态大小的List类
--endregion

using "Joop"

namespace "System.Collections.Generic"
{
    class "CDynamicList"
    {
        ListData = false,
        ___Size = 0,
        ___ItemType = false, --table or JoopClass

        Size = 
            function(self) 
                return self.___Size
            end,

        TotalSize = 
            function(self) 
                return #self.ListData
            end,

        CDynamicList = 
            function(self, itemType) 
                self.ListData = {}
                if itemType == table then
                    self.___ItemType = table.New
                elseif class:IsTypeOf(itemType) then
                    self.___ItemType = itemType
                else
                    self.___ItemType = false
                end
            end,

        AddItem = 
            function(self, item)
                self.___Size = self.___Size + 1
                if self.___Size <= #self.ListData then
                    self.ListData[self.___Size] = item
                else
                    table.insert(self.ListData, item)
                end
            end,

        Add = 
            function(self, count)
                count = count or 1
                if self.___Size + count <= #self.ListData then
                    self.___Size = self.___Size + count
                    return self:GetItem(self.___Size)
                end
                self:___Add(self.___Size + count - #self.ListData)
                return self:GetItem(self.___Size - count + 1)
            end,

        ___Add = 
            function(self, count, addNil)
                local item
                for i = 1, count do
                    item = (addNil or not self.___ItemType) and ___Nil or self.___ItemType()
                    table.insert(self.ListData, item)
                end
                self.___Size = #self.ListData
            end,

        GetItem = 
            function(self, pos)
                if not pos or pos <= 0 or pos > self.___Size then
                    return nil
                else
                    if self.ListData[pos] == ___Nil then
                        return nil
                    else
                        return self.ListData[pos]
                    end
                end
            end,

        Resize = 
            function(self, size, freeUnused)
                if not size or size <= 0 then
                    self.___Size = 0
                elseif size <= self.___Size then
                    self.___Size = size
                else
                    self:Add(size - self.___Size)
                end
                if freeUnused then
                    self:FreeUnused()
                end
            end,

        FreeUnused = 
            function(self)
                for i = #self.ListData, self.___Size + 1, -1 do
                    table.remove(self.ListData, i)
                end
            end,

        Insert = 
            function(self, item, pos)
                if not pos then
                    self.___Size = self.___Size + 1
                    table.insert(self.ListData, self.___Size, item == nil and ___Nil or item)
                    return self.___Size
                end
                if pos <= 0 then
                    return nil
                end

                local len = #self.ListData
                if pos <= len then
                    if pos <= self.___Size then
                        self.___Size = self.___Size + 1
                    else
                        self.___Size = pos
                    end
                    table.insert(self.ListData, pos, item == nil and ___Nil or item)
                    return pos
                end
                --pos > len
                self:___Add(pos - len - 1)
                table.insert(self.ListData, item == nil and ___Nil or item)
                self.___Size = pos
                return pos
            end,

        Clear = 
            function(self, freeUnused)
                self.___Size = 0
                if freeUnused then
                    self:FreeUnused()
                end
            end,
        
        Remove = 
            function(self, pos)
                if pos <= 0 or pos > self.___Size then
                    return false
                end
                table.remove(self.ListData, pos)
                self.___Size = self.___Size - 1
                return true
            end,

        RemoveItem = 
            function(self, item)
                local pos = self:Find(item)
                if pos == 0 then
                    return nil
                end
                table.remove(self.ListData, pos)
                self.___Size = self.___Size - 1
                return true
            end,

        Find = 
            function(self, item, iStart)
                for i = iStart or 1, self.___Size do
                    if self:GetItem(i) == item then
                        return i
                    end
                end
                return 0
            end,

        FindByKey = 
            function(self, keyName, keyValue, iStart)
                local item
                for i = iStart or 1, self.___Size do
                    item = self:GetItem(i)
                    if item and item[keyName] == keyValue then
                        return item, i
                    end
                end
            end,
        RemoveByKey = 
            function(self, keyName, keyValue, removeAll, iStart)
                local item
                local count = 0
                for i = iStart or 1, self.___Size do
                    item = self:GetItem(i)
                    if item and item[keyName] == keyValue then
                        count = count + 1
                        table.remove(self.ListData, i)
                        self.___Size = self.___Size - 1
                        if not removeAll then
                            return count
                        end
                        i = i - 1
                    end
                end
                return count
            end,

        Contains = 
            function(self, item, iStart)
                return self:Find(item, iStart) > 0
            end,

        Unpack = 
            function(self, ...)
                return self:UnpackFromIndex(1, ...)
            end,

        UnpackFromIndex = 
            function(self, index, ...) --- ... 必须也为CList
                if index == nil or index < 1 then
                    index =  1
                end
                if index <= self.___Size then
                    return self:GetItem(index), self:UnpackFromIndex(index + 1, ...)
                else
                    if select("#", ...) > 0 then
                        local s = select(1, ...)
                        --if type(s) == "table" and s.class and s.class.name == "CList" then
                        --    return s:GetItem(1), s:Unpack(2, select(2, ...))
                        --else
                            return s, self:UnpackFromIndex(index, select(2, ...))
                        --end
                    end
                end
            end,
    }
}
