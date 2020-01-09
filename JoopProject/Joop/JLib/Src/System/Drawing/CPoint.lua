--region CPoint.lua
--Author : jefflwq
--Date   : 2016/04/24
--说明   : Point类
--endregion

using "Joop"

namespace "System.Drawing"
{
    class "CPoint"
    {
        -- 此 Point 的 X 坐标。
        X = false,
        -- 此 Point 的 Y 坐标。
        Y = false,
        -- 初始化 Point 类的新实例。
        CPoint = 
            function(self, x, y)
                self.X = x or 0
                self.Y = y or 0
            end,
        Empty = 
            function(self)
                self.X = 0
                self.Y = 0
            end,
        GetPoint = 
            function(self)
                return self.X, self.Y
            end,
        -- 获取一个值，该值指示此 Point 是否为空。
        -- 返回结果:
        --     如果 X 和 Y 均为 0，则为 true；否则为 false。
        IsEmpty = 
            function(self)
                return self.X == 0 and self.Y == 0
            end,
        -- 指定此 Point 是否与指定 point 相同。
        Equals = 
            function(self, point)
                return self.X == point.X and self.Y == point.Y
            end,
        -- 克隆此 Point。
        Clone = 
            function(self)
                return CPoint(self.X, self.Y)
            end,
        -- 将此 Point 平移指定的 Point。
        Offset = 
            function(self, point)
                self.X = self.X + point.X
                self.Y = self.Y + point.Y
            end,
        OffsetXY = 
            function(self, x, y)
                self.X = self.X + x
                self.Y = self.Y + y
            end,
        -- 将此 Point 转换为可读字符串。
        ToString = 
            function(self)
                return "X=" .. self.X .. ", Y=" .. self.Y
            end,
    }
}
