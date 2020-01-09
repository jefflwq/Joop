--region CSize.lua
--Author : jefflwq
--Date   : 2016/04/24
--说明   : Size类
--endregion

using "Joop"

namespace "System.Drawing"
{
    class "CSize"
    {
        -- 此 Size 的 Width 。
        Width = false,
        -- 此 Size 的 Height 。
        Height = false,
        -- 初始化 Size 类的新实例。
        CSize = 
            function(self, width, height)
                self.Width = width or 0
                self.Height = height or 0
            end,
        SetSize = 
            function(self, width, height)
                self.Width = width or 0
                self.Height = height or 0
            end,
        GetSize = 
            function(self)
                return self.Width, self.Height
            end,
        Empty = 
            function(self)
                self.Width = 0
                self.Height = 0
            end,
        -- 获取一个值，该值指示此 Size 是否为空。
        -- 返回结果:
        --     如果 Width 和 Height 均为 0，则为 true；否则为 false。
        IsEmpty = 
            function(self)
                return self.Width == 0 and self.Height == 0
            end,
        -- 指定此 Size 是否与指定 size 相同。
        Equals = 
            function(self, size)
                return self.Width == size.Width and self.Height == size.Height
            end,
        -- 克隆此 Size。
        Clone = 
            function(self)
                return CSize(self.Width, self.Height)
            end,
        -- 将此 Size 加上指定的 Size。
        Add = 
            function(self, size)
                self.Width = self.Width + size.Width
                self.Height = self.Height + size.Height
            end,
        AddWH = 
            function(self, width, height)
                self.Width = self.Width + width
                self.Height = self.Height + height
            end,
        -- 将此 Size 减去指定的 Size。
        Subtract = 
            function(self, size)
                self.Width = self.Width - size.Width
                self.Height = self.Height - size.Height
            end,
        SubtractWH = 
            function(self, width, height)
                self.Width = self.Width - width
                self.Height = self.Height - height
            end,
        -- 将此 Size 转换为可读字符串。
        ToString = 
            function(self)
                return "Width=" .. self.Width .. ", Height=" .. self.Height
            end,
    }
}
