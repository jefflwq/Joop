--region CComparer.lua
--Author : jefflwq
--Date   : 2015/2/23
--说明   : 比较
--endregion

using "Joop"

namespace "System.Collections.Generic"
{
    static_class "CCompareType"
    {
        ___CCompareType = 
            function (self)
                self[">"] = self.GreaterThan
                self[">="] = self.GreaterEqual
                self["<"] = self.LessThan
                self["<="] = self.LessEqual
            end,
        GreaterThan = 
            function (value1, value2)
                return value1 > value2
            end,
        GreaterEqual = 
            function (value1, value2)
                return value1 >= value2
            end,
        LessThan = 
            function (value1, value2)
                return value1 < value2
            end,
        LessEqual = 
            function (value1, value2)
                return value1 <= value2
            end,
    },

    class "CComparer"
    {
        CompareType = false,
        CComparer = 
            function (self, compareType)
                self.CompareType = CCompareType[compareType]
            end,
        Compare = 
            function (self, value1, value2)
                if not self.CompareType then
                    return nil
                end
                return self.CompareType(value1, value2)
            end,
    }
}