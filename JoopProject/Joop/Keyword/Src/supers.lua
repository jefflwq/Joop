--region super.lua
--Author : jefflwq
--Date   : 2016/02/27
--说明   : 用于实现多重继承, 与System.CSupers配合使用
--用例
--        class "clsA" : supers(clsB, clsC)
--        {
--            FuncA = 
--                function(self)
--                    self.FuncInclsB()
--                    self.FuncInclsC()
--                end,
--        },
--endregion

using "Joop"

local rawget = rawget
local rawset = rawset
local type = type
local pairs = pairs
local JoopType = Joop.JoopType
local GetJoopTypeName = JoopType.GetJoopTypeName
local GetJoopTypeInfo = JoopType.GetJoopTypeInfo
local SetJoopTypeInfo = JoopType.SetJoopTypeInfo
local SetMetaKey = JoopType.SetMetaKey
local SetOnCall = JoopType.SetOnCall
local SetOnIndex = JoopType.SetOnIndex
local SetOnNewindex = JoopType.SetOnNewindex

local function InvalidSyntax(level)
    Error("Invalid syntax for using 'supers' keyword", level or 3)
    return
end

local function FindSuperKey(self, key)
    local v, spr
    for _, spr in ipairs(self.m_Supers) do
--        if rawequal(spr, key) then
--            return spr
--        end
        v = spr[key]
        if v ~= nil then
            return v
        end
    end
end


--local function FindSuper(self, key)
----    local v = FindObjectKey(self, key)
----    if v ~= nil then
----        return v
----    end
--    return FindSuperKey(self, key)
--end

--local function GetSuper(self, key)
--end

local function OnSetSupers(self, ...)
    --local args = CArgList(...)
    rawset(self, "m_Supers", {})
    local len = select("#", ...)
    if len < 3 then
        InvalidSyntax()
    end
    local i
    local superType 
    local superName 
    for i = 2, len do
        superType = select(i, ...)
--        superName = GetJoopTypeName(superType)
--        if rawget(self.m_Supers, superName) then
--            Error("Redefined : " .. superName, 2)
--        end
        if not GetJoopTypeInfo(superType, "___inheritable") then
            Error("Only inheritable joop type can be a super", 2)
        end
        table.insert(self.m_Supers, superType)
        --rawset(self.m_Supers, superName, superType)
    end
    SetMetaKey(self, "__call", nil)
    SetMetaKey(self, "__index", FindSuperKey)
    return self.m_Class
end

local function NewSupers(_, cls)
    local spr = _supers()
    spr.m_Class = cls
    SetJoopTypeInfo(cls, "___super", spr)
    SetOnCall(spr, OnSetSupers)
    SetOnNewindex(spr, InvalidSyntax)
    return spr
end

keyword "supers"
{
    ___supers = 
        function(self)
            SetOnNewindex(self, InvalidSyntax)
            SetOnIndex(self, InvalidSyntax) -- GetSuper
            SetOnCall(self, NewSupers)
        end,
--    SetSupers =
--        function(self, obj)
--            return System.CSupers(obj)
--        end,
    class "_supers"
    {
        m_Class = false,
        m_Supers = false,
    }
}

