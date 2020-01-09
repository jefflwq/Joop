--region CList.lua
--Author : jefflwq
--Date   : 2016/02/28
--说明   : List类
--endregion

using "Joop"

namespace "System.Collections.Generic"
{
    class "CList"
    {
        ListData = false,
        CList = 
            function(self, listData)
                self.ListData = listData or {}
            end,
        Insert = 
            function(self, item, pos)
                local len = #self.ListData
                if not pos then
                    table.insert(self.ListData, item == nil and ___Nil or item)
                    return len + 1
                elseif pos <= 0 then
                    return nil
                elseif pos > len then
                    for i = len + 1, pos - 1 do
                        table.insert(self.ListData, ___Nil)
                    end
                    table.insert(self.ListData, item == nil and ___Nil or item)
                    return pos
                else
                    table.insert(self.ListData, pos, item == nil and ___Nil or item)
                    return pos
                end
            end,

        Merge = 
            function(self, list, pos)
                if not pos then
                    for i = 1, list:Size() do
                        table.insert(self.ListData, list.ListData[i])
                    end
                    return #self.ListData
                elseif pos <= 0 then
                    return nil
                elseif pos > #self.ListData then
                    for i = #self.ListData + 1, pos - 1 do
                        table.insert(self.ListData, ___Nil)
                    end
                    for i = 1, list:Size() do
                        table.insert(self.ListData, list.ListData[i])
                    end
                    return #self.ListData
                else
                    for i = 1, list:Size() do
                        table.insert(self.ListData, pos, list.ListData[i])
                        pos = pos + 1
                    end
                    return pos
                end
            end,

        GetItem = 
            function(self, pos)
                if not pos or pos <= 0 or pos > #self.ListData then
                    return nil
                else
                    if self.ListData[pos] == ___Nil then
                        return nil
                    else
                        return self.ListData[pos]
                    end
                end
            end,

        SetItem = 
            function(self, pos, item)
                if not pos or pos <= 0 then
                    return nil
                elseif pos > #self.ListData then
                    return self:Insert(item, pos)
                else
                    self.ListData[pos] = item
                    return pos
                end
            end,

        Size = 
            function(self) 
                return #self.ListData
            end,

        Clear = 
            function(self)
                if #self.ListData == 0 then
                    return
                end
                table.wipe(self.ListData)
                --if wipe then
    --                wipe(self.ListData)
    --            else
    --                self.ListData = {}
    --            end
            end,
        
        Remove = 
            function(self, pos)
                if pos <= 0 or pos > #self.ListData then
                    return false
                end
                table.remove(self.ListData, pos)
                return true
            end,

        RemoveItem = 
            function(self, item)
                local pos = self:Find(item)
                if pos == 0 then
                    return nil
                end
                table.remove(self.ListData, pos)
                return true
            end,

        Find = 
            function(self, item, iStart)
                for i = iStart or 1, #self.ListData do
                    if self:GetItem(i) == item then
                        return i
                    end
                end
                return 0
            end,

        FindByKey = 
            function(self, keyName, keyValue, iStart)
                local item
                for i = iStart or 1, #self.ListData do
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
                for i = iStart or 1, #self.ListData do
                    item = self:GetItem(i)
                    if item and item[keyName] == keyValue then
                        count = count + 1
                        table.remove(self.ListData, i)
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
                if index <= #self.ListData then
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
