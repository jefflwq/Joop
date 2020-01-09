--region CUtf8String.lua
--Author : jefflwq
--Date   : 2015/2/19
--说明   : UTF8字符串
--endregion

using "Joop"

import "System.Collections.Generic.CList"

namespace "System.Text"
{
    class "CUtf8String"
    {
        m_Index = false,
        m_Text = "",
        m_TextLen = 0,
        CUtf8String = 
            function (self, strText)
                self.m_Index = CList()
                self:Set(strText)
            end,

        Set = 
            function(self, strText)
                self.m_Text = strText
                self.m_Index:Clear()
                if not strText or strText == "" then
                    self.m_TextLen = 0
                    return 
                end
                self.m_TextLen = string.len(self.m_Text)
                local iPos = 1
                local iOffset = 0
                local iIndex = 1
                local data
                while iPos <= self.m_TextLen do
                    data = string.byte(self.m_Text , iPos)
                    self.m_Index:Insert(iPos)
                    if data < 128 then  --one byte utf-8 character
                        iPos = iPos + 1
                    elseif data >= 192 and data < 224 then
                        iPos = iPos + 2   -- tow byte
                    elseif data >= 224 and data < 240 then
                        iPos = iPos + 3  -- three byte
                    elseif data >= 240 and data < 248 then
                        iPos = iPos + 4  -- four byte
                    elseif data >= 248 and data < 252 then
                        iPos = iPos + 5  -- five byte 
                    elseif data >= 252 then
                        iPos = iPos + 6  -- six byte
                    end
                end
            end,

        Len = 
            function(self)
                return self.m_Index:Size()
            end,

        At = 
            function(self, iPos)
                if not iPos or iPos < 1 then
                    return nil
                end
                if iPos > self.m_Index:Size() then
                    return nil
                end
                local iEnd
                if iPos == self.m_Index:Size() then
                    iEnd = self.m_TextLen
                else
                    iEnd = self.m_Index:GetItem(iPos + 1) - 1
                end
                return string.sub(self.m_Text, self.m_Index:GetItem(iPos), iEnd)
            end,

        Sub = 
            function(self, iStart, iEnd)
                iStart = iStart or 1
                if iStart < 1 then
                    return nil
                end
                if iStart > self.m_Index:Size() then
                    return nil
                end
                iStart = self.m_Index:GetItem(iStart)
                if not iEnd or iEnd >= self.m_Index:Size() then
                    iEnd = self.m_TextLen
                else
                    iEnd = self.m_Index:GetItem(iEnd + 1) - 1
                end
                return string.sub(self.m_Text, iStart, iEnd)
            end,
    }
}
