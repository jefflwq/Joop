--region CType.lua
--Author : jefflwq
--Date   : 2015/2/19
--说明   : 取得对象的类型
--endregion

using "Joop"

local type = type
local ___Nil = ___Nil
local GetJoopTypeInfo = GetJoopTypeInfo
namespace "System"
{
    class "CType"
    {
        m_AttachedVar = ___Nil,
        m_LuaType = ___Nil,
        m_JoopType = ___Nil,
        CType = 
            function(self, var)
                self:Attach(var)
            end,
        Attach =
            function(self, var)
                self.m_AttachedVar = var
                self.m_LuaType = ___Nil
                self.m_JoopType = ___Nil
            end,
        GetLuaType = --取得对象的lua基本type
            function(self)
                if self.m_LuaType == ___Nil then
                    self.m_LuaType = type(self.m_AttachedVar)
                end
                return self.m_LuaType
            end,

        GetJoopTypeName = --取得对象的JoopType,如果不是Joop对象,则返回""
            function(self)
                if self.m_JoopType ~= ___Nil then
                    return self.m_JoopType
                end
                self.m_JoopType = ""
                if self:GetLuaType() ~= "table" then --Joop对象一定是table
                    return ""
                end

                local typeInfo = GetJoopTypeInfo(self.m_AttachedVar)
                if not typeInfo then --不是Joop对象
                    return ""
                end

                self.m_JoopType = typeInfo.___name
                return self.m_JoopType

            end,
    }
}

