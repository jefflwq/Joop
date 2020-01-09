--region CSourceCleaner.lua
--Author : jefflwq
--Date   : 2016/8/28
--说明   : 去除注释以及无用的空白等
--endregion

using "Joop"

using "System.Collections.Generic"

local commentStart = "-" .. "-"

namespace "System.Text"
{
    class "CSourceCleaner" : CStringSpliter
    {
        CleanComment = false,
        TrimBlank = false,
        CleanBlankLine = false,
        CSourceCleaner = 
            function(self, clearComment, trimBlank, cleanBlankLine)
                self.super()
                self.CleanComment = clearComment or false
                self.TrimBlank = trimBlank or false
                self.CleanBlankLine = cleanBlankLine or false
            end,
        Clean = 
            function(self, strSource)
                if not (self.CleanComment or self.TrimBlank or self.CleanBlankLine) then
                    return strSource
                end
                if strSource == nil or strSource == "" then
                    return ""
                end
                strSource = string.gsub(strSource, "\r\n", "\n")
                if self:Split(strSource) == 0 then
                    return ""
                end
                if self.CleanComment then
                    self:___RemoveComment()
                end
                if self.TrimBlank then
                    self:___Trim()
                end
                if self.CleanBlankLine then
                    self:___CleanBlankLine()
                end
                
                return self:BuildString("\n")
            end,

        ___RemoveComment = 
            function(self)
                local iPos
                local listData = self.ListData
                for i, v in ipairs(listData) do
                    iPos = string.find(v, commentStart, 1, true)
                    if iPos then
                        listData[i] = string.sub(v, 1, iPos - 1)
                    end
                end
            end,
        ___Trim = 
            function(self)
                local trim = string.Trim
                local listData = self.ListData
                for i, v in ipairs(listData) do
                    listData[i] = trim(v)
                end
            end,
        ___CleanBlankLine = 
            function(self)
                local listData = self.ListData
                local len = #listData
                for i = len, 1, -1 do
                    if listData[i] == "" then
                        table.remove(listData, i)
                    end
                end
            end,
    }
}
