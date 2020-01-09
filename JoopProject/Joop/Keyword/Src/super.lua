--region super.lua
--Author : jefflwq
--Date   : 2016/02/24
--说明   : 用于在类中调用基类成员函数
--用例
--        class "clsA"
--        {
--            clsA = 
--                function(self, name)
--                    print("In clsA.")
--                end,
--            PrintName = 
--                function(self)
--                    print("In clsA.PrintName")
--                end,
--        },
--        class "clsB" : clsA --继承自clsA
--        {
--            clsB1 = 
--                function(self, name)
--                    print("In clsB.")
--                    self.super("", name)            --调用基类的构造函数
--                end,
--                PrintName = 
--                    function(self)
--                        print("In clsB.PrintName")
--                        self.super("PrintName")    --调用基类的成员函数
--                    end,
--        },
--endregion

using "Joop"

local CurrentObj = false --调用super的对象
local SuperClass = false
local Func = false

local function InvalidSyntax()
    Error("Invalid syntax for using 'super' keyword", 2)
    return
end

local function CallSuperFunc(self, ...)
    if Func then --调用一个函数
        return Func(CurrentObj, ...)
    end
    --调用ctor
    local f = SuperClass.___ctor
    if f then
        return f(CurrentObj, ...)
    end
end

local function Init(obj, superClass)
    CurrentObj = obj
    SuperClass = superClass
    Func = false
end
                
local function FindSuperFunc(self, key)
    if type(key) == "string" then
        local f = SuperClass[key]
        if f == nil then
            Error(key .. " is not found in this class' super.", 4)
        end
        if type(f) ~= "function" then
            Error(key .. " must be a function of this class' super.", 4)
        end
        Func = f
        return self
    end
end


local _super = 
{
}
setmetatable(_super, {__index = FindSuperFunc, __newindex = InvalidSyntax, __call = CallSuperFunc})

local function CallingSuper(_, obj, isObj)
    --local fenv = getfenv(isObj and 3 or 4)
    local fenv = getfenv(3)
    --if table.IsTypeOf(fenv) then
        local superClass = rawget(fenv, "___super")
        if superClass then
            Init(obj, superClass)
            return _super
        else
            Error(GetJoopTypeName(obj) .. " has no super.", 4)
        end
    --end
    Error("Usage: self.super.Func(...)", 3)
    return nil
end

keyword "super"
{
    ___super = 
        function(self)
            Joop.SetOnNewindex(self, InvalidSyntax)
            Joop.SetOnCall(self, CallingSuper)
        end,
}
