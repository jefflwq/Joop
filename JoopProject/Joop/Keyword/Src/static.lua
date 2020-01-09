--region static.lua
--Author : jefflwq
--Date   : 2016/02/27
--说明   : 将类中的成员声明为静态变量,使用类名进行访问(设置值的时候应该是有bug, 应该找到定义这个成员的class)
--endregion

using "Joop"

local rawset = rawset
local rawget = rawget
local GetJoopTypeInfo = Joop.GetJoopTypeInfo

local function SetStaticKey(obj, key, value)
    local body
    local typeinfo = GetJoopTypeInfo(obj)
    while typeinfo do
        body = rawget(typeinfo, "___body")
        if rawget(body, key) ~= nil then
            rawset(body, key, value)
            return
        end
        typeinfo = GetJoopTypeInfo(rawget(typeinfo, "___super"))
    end
    Error("static key not found : <" .. key .. ">", 2)
    return nil
end

modifier "static" --静态成员
{
    ___Priority = 3,

    ___OnCheckModifier = --返回值：true(检查通过,继续下一个) false(检查未通过，终止) nil(检查通过，并终止其他的)
        function(self, obj, key, value)
            SetStaticKey(obj, key, value)
            return nil
        end,
}
