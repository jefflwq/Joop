--region CPair.lua
--Author : jefflwq
--Date   : 2016/10/01
--说明   : CPair类
--endregion

using "Joop"

namespace "System.Collections.Generic"
{
    class "CPair"
    {
        Keys = false,
        CPair = 
            function(self)
                self:___Init()
            end,
        ___Init = 
            function(self)
                self.Keys = {}
            end,

        Clear = 
            function(self)
                table.wipe(self.Keys)
                --if wipe then
                --    wipe(self.Keys)
                --else
                --    self.Keys = {}
                --end
            end,

        GetValue = 
            function(self, key)
                return self.Keys[key]
            end,

        GetKey = 
            function(self, value)
                for k, v in pairs(self.Keys) do
                    if v == value then
                        return k
                    end
                end
            end,

        SetValue = 
            function(self, key, value)
                self.Keys[key] = value
            end,

        Insert = 
            function(self, key, value)
                if self.Keys[key] ~= nil then
                    return false
                end
                self.Keys[key] = (value == nil and key or value)
                return true
            end,

        Remove = 
            function(self, key)
                self.Keys[key] = nil
            end,

        Contains = 
            function(self, key)
                return self.Keys[key] ~= nil
            end,
    }
}
