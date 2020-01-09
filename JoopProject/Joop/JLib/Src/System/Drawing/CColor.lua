--region CColor.lua
--Author : jefflwq
--Date   : 2016/03/27
--说明   : Color类
--endregion

using "Joop"

namespace "System.Drawing"
{
    class "CColor"
    {
        RGB = "000000",
        R = 0, -- 0~1
        G = 0, -- 0~1
        B = 0, -- 0~1
        Alpha = 1, -- 0~1
        CColor = 
            function(self, rgbOrR, alphaOrG, b, alpha)
                self:SetColor(rgbOrR, alphaOrG, b, alpha)
            end,

        SetColor = 
            function(self, rgbOrR, alphaOrG, b, alpha)
                if type(rgbOrR) == "string" then
                    self:SetRGB(rgbOrR)
                    self.Alpha = alphaOrG or self.Alpha or 1
                else
                    self.R = self:GetColor1(rgbOrR or 0)
                    self.G = self:GetColor1(alphaOrG or 0)
                    self.B = self:GetColor1(b or 0)
                    self:___SetRGB()
                    self.Alpha = alpha or self.Alpha or 1
                end
            end,

        ___SetRGB = 
            function(self)
                self.RGB = string.format("%02x%02x%02x", self:GetColor255(self.R), self:GetColor255(self.G), self:GetColor255(self.B))
            end,

        SetRGB = 
            function(self, rgbString)
                rgbString = rgbString or "000000"
                self.R = (tonumber(string.sub(rgbString, 1, 2), 16) or 0) / 255
                self.G = (tonumber(string.sub(rgbString, 3, 4), 16) or 0) / 255
                self.B = (tonumber(string.sub(rgbString, 5, 6), 16) or 0) / 255
                self:___SetRGB()
            end,

        SetR = 
            function(self, r)
                self.R = self:GetColor1(r or 0)
                self:___SetRGB()
            end,

        SetG = 
            function(self, g)
                self.G = self:GetColor1(g or 0)
                self:___SetRGB()
            end,

        SetB = 
            function(self, b)
                self.B = self:GetColor1(b or 0)
                self:___SetRGB()
            end,

        GetColor1 = -- 0-255 -> 0-1
            function(self, colorValue)
                if colorValue < 1 then
                    return colorValue
                else
                    return colorValue / 255
                end
            end,

        GetColor255 = -- 0-1 -> 0-255
            function(self, colorValue)
                if colorValue < 1 then
                    return math.Round(colorValue * 255)
                else
                    return colorValue
                end
            end,
    }
}
