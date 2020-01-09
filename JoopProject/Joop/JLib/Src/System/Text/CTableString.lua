--region CTableString.lua
--Author : jefflwq
--Date   : 2016/9/23
--说明   : CTableString类
--endregion

using "Joop"

using "System.Collections.Generic"
namespace "System.Text"
{
    class "CTableString" : CStringBuilder
    {
        const.___LockingString("___printingInCTableString"),
        ChildLevel = false,
        IndentLevel = false,
        IndentSize = false,
        CTableString = 
            function(self, childLevel, indentSize, indentLevel)
                self.super()
                self.ChildLevel = childLevel or 0
                self.IndentSize = indentSize or 2
                self.IndentLevel = indentLevel or 0
            end,
        GetTableString = 
            function(self, t)
                self:Clear()
                self:___InsertTableString(t, self.IndentLevel)
                return self:BuildString()
            end,

        ___GetIndent = 
            function(self, indentLevel)
                indentLevel = indentLevel or self.IndentLevel or 0
                if indentLevel == 0 then
                    return ""
                end
                return string.rep(' ', indentLevel * self.IndentSize) or ""
            end,
        ___TryLock = 
            function(self, t)
                if rawget(t, self.___LockingString) == nil then
                    rawset(t, self.___LockingString, true)
                    return true
                else
                    return false
                end
            end,

        ___Unlock = 
            function(self, t)
                rawset(t, self.___LockingString, nil)
            end,

        ___InsertValueString = 
            function(self, value, iIndent)
                local valueType = type(value)
                if valueType == "string" then
                    self:Insert("\"" .. value .. "\"")
                elseif valueType == "table" then
                    self:___InsertTableString(value, iIndent, true)
                else
                    self:Insert(tostring(value))
                end
            end,

        ___InsertTableString = 
            function(self, t, iIndent)
                if t.OnGetTableString then
                    t:OnGetTableString(self, iIndent)
                end
                self:Insert(tostring(t))
                self:Insert("\n" .. self:___GetIndent(iIndent) .."{\n")
                if self:___TryLock(t) then
                    for k, v in pairs(t) do
                        if k ~= self.___LockingString then
                            self:Insert(self:___GetIndent((iIndent or 0) + 1))
                            self:Insert(tostring(k))
                            self:Insert(" = ")
                            self:___InsertValueString(v, (iIndent or 0) + 1)
                            self:Insert("\n")
                        end
                    end
                    self:___Unlock(t)
                else
                    self:Insert(self:___GetIndent((iIndent or 0) + 1) .. "...\n")
                end
                self:Insert(self:___GetIndent(iIndent, iIndentSize) .. "}")
            end,
    }
}
