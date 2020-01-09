--region static_class.lua
--Author : jefflwq
--Date   : 2016/02/28
--说明   : 静态类，不可实例化
--endregion

using "Joop"

local function OnRegisterStaticClass(newClass)
    rawset(newClass, "OnFindKey", nil) --清除OnCreating中的设置
    SetOnCall(newClass, function(newClass, ...) Error("static_class can't be instantiated : " .. GetJoopTypeName(newClass)) end)
    return true
end

keyword "static_class" : class
{
    ___OnSetBody = 
        function(self, body)
            self.___OnSetBody = class.___OnSetBody
            return true
        end,

    ___OnRegister = --响应keyword的___OnRegister事件,把static_class关键字注册到keyword当中
        function(self)
            keyword.___OnRegister(self)
            --替换掉class的___OnRegister函数,在使用class定义新类的时候,将使用OnRegisterClass
            self.___OnRegister = OnRegisterStaticClass 
            return true
        end,
}
