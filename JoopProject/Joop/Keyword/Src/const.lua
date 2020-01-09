--region const.lua
--Author : jefflwq
--Date   : 2016/02/27
--说明   : 定义const关键字,声明该类成员是常量, 将不能修改, 同时也是静态成员, 貌似直接用类名调用还是可以修改
--用例   : class "CBase"
--           {
--               const.baseMember("init_value") --必须这样初始化
--               CBase = 
--                   function(self, ...)
--                       self.baseMember = 0 -- Error
--                   end,
--           },
--endregion

using "Joop"

local JoopType = Joop.JoopType
modifier "const"
{
    ___Priority = 2,

    ___OnCheckModifier = --返回值：true(检查通过,继续下一个) false(检查未通过，终止) nil(检查通过，并终止其他的)
        function(self, obj, key, value)
            Error("const member can't be modified" .. " : <" .. key .. ">", 4)
            return false
        end,
}
