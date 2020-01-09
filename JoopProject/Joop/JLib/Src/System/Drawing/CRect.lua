--region CRect.lua
--Author : jefflwq
--Date   : 2016/04/24
--说明   : Rect类
--endregion

using "Joop"

namespace "System.Drawing"
{
    class "CRect"
    {
        -- 此 Rect 的 Location 。
        Location = false,
        -- 此 Rect 的 Size 。
        Size = false,
        -- 初始化 Rect 类的新实例。
        CRect = 
            function(self, left, top, right, bottom)
                self.Location = CPoint()
                self.Size = CSize()
                self:SetLTRB(left, top, right, bottom)
            end,
        SetLTRB = 
            function(self, left, top, right, bottom)
                self.Location.X = left or 0
                self.Location.Y = top or 0
                self.Size.Width = right and (right - (left or 0)) or 0
                self.Size.Height = bottom and (bottom - (top or 0)) or 0
            end,
        Empty = 
            function(self)
                self.Location:Empty()
                self.Size:Empty()
            end,
        GetLTRB = 
            function(self)
                return self:GetLeft(), self:GetTop(), self:GetRight(), self:GetBottom()
            end,
        -- 获取一个值，该值指示此 Rect 是否为空。
        -- 返回结果:
        --     如果 Location 和 Size 均为 Empty，则为 true；否则为 false。
        IsEmpty = 
            function(self)
                return self.Location:IsEmpty() and self.Size:IsEmpty()
            end,
        -- 指定此 Rect 是否与指定 rect 相同。
        Equals = 
            function(self, rect)
                return self.Location:Equals(rect.Location) and self.Size:Equals(rect.Size)
            end,
        -- 克隆此 Rect。
        Clone = 
            function(self)
                return CRect(self.Location:Clone(), self.Size:Clone())
            end,
        GetTop = 
            function(self)
                return math.min(self.Location.Y, self.Location.Y + self.Size.Height)
            end,
        GetBottom = 
            function(self)
                return math.max(self.Location.Y, self.Location.Y + self.Size.Height)
            end,
        GetLeft = 
            function(self)
                return math.min(self.Location.X, self.Location.X + self.Size.Width)
            end,
        GetRight = 
            function(self)
                return math.max(self.Location.X, self.Location.X + self.Size.Width)
            end,
        -- 将此 Rect 加上指定的 Rect。
        Union = 
            function(self, rect)
                local left = math.min(self:GetLeft(), rect:GetLeft())
                local right = math.max(self:GetRight(), rect:GetRight())
                local top = math.min(self:GetTop(), rect:GetTop())
                local bottom = math.max(self:GetBottom(), rect:GetBottom())
                self:SetLTRB(left, top, right, bottom)
            end,
        UnionPoint = 
            function(self, point)
                local left = math.min(self:GetLeft(), point.X)
                local right = math.max(self:GetRight(), point.X)
                local top = math.min(self:GetTop(), point.Y)
                local bottom = math.max(self:GetBottom(), point.Y)
                self:SetLTRB(left, top, right, bottom)
            end,
        UnionXY = 
            function(self, x, y)
                local left = math.min(self:GetLeft(), x)
                local right = math.max(self:GetRight(), x)
                local top = math.min(self:GetTop(), y)
                local bottom = math.max(self:GetBottom(), y)
                self:SetLTRB(left, top, right, bottom)
            end,
        -- 将此 Rect 与指定的 Rect 取交集。
        Intersect = 
            function(self, rect)
                local left = math.max(self:GetLeft(), rect:GetLeft())
                local right = math.min(self:GetRight(), rect:GetRight())
                local top = math.max(self:GetTop(), rect:GetTop())
                local bottom = math.min(self:GetBottom(), rect:GetBottom())
                if left <= right and top <= bottom then
                    self:SetLTRB(left, top, right, bottom)
                    return true
                else
                    self:Empty()
                end
            end,
        -- 判断2个Rect是否相交
        IntersectsWith = 
            function(self, rect)
                local left = math.max(self:GetLeft(), rect:GetLeft())
                local right = math.min(self:GetRight(), rect:GetRight())
                local top = math.max(self:GetTop(), rect:GetTop())
                local bottom = math.min(self:GetBottom(), rect:GetBottom())
                return left <= right and top <= bottom
            end,
        Contains = 
            function(self, rect)
                return self:GetLeft() <= rect:GetLeft()
                   and self:GetRight() >= rect:GetRight()
                   and self:GetTop() <= rect:GetTop()
                   and self:GetBottom() >= rect:GetBottom()
            end,
        ContainsPoint = 
            function(self, point)
                return self:GetLeft() <= point.x
                   and self:GetRight() >= point.x
                   and self:GetTop() <= point.y
                   and self:GetBottom() >= point.y
            end,
        ContainsXY = 
            function(self, x, y)
                return self:GetLeft() <= x
                   and self:GetRight() >= x
                   and self:GetTop() <= y
                   and self:GetBottom() >= y
            end,
        -- 将此 Rect 转换为可读字符串。
        ToString = 
            function(self)
                return self.Location:ToString() .. ", " .. self.Size:ToString()
            end,
    }
}
