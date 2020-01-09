--region public.lua
--Author : jefflwq
--Date   : 2016/02/27
--说明   : 定义public关键字,暂时没有用
--用例   : public.static.const.A("111")
--endregion

using "Joop"

modifier "public" --默认都是public的, 什么都不用写
{
    ___Priority = 1,

--    ___OnCheckModifier = --public 什么都不用做
--        function(self, obj, key, value)
--            return true
--        end,
}
