--region CDateTime.lua
--Author : jefflwq
--Date   : 2016/08/27
--说明   : 日期类
--endregion

using "Joop"
import "System.Text.CStringSpliter"

namespace "System.DateTime"
{
    class "CDateTime"
    {
        year = 0,
        month = 0,
        day = 0,
        hour = 0,
        min = 0,
        sec = 0,
        millisec = 0,
        isdst = false,
        Seconds = 0,
        SecondsWithMilli = 0,
        CDateTime =
            function (self, timeString)
                if timeString then
                    self:SetString(timeString)
                end
            end,
        Clear =
            function (self, timeString)
                self.year = 0
                self.month = 0
                self.day = 0
                self.hour = 0
                self.min = 0
                self.sec = 0
                self.millisec = 0
            end,
        Compare =
            function (self, time)
                return self:GetSeconds(true) - time:GetSeconds(true)
            end,

        GetSeconds =
            function (self, includeMilliSec)
                local seconds = os.time(self) or 0
                if includeMilliSec then
                    seconds = seconds + (self.millisec / 1000)
                end
                return seconds
            end,

        ToString =
            function (self, format) --"yyyy/mm/dd hh:mi:ss.ms"
                format = format or "yyyy/mm/dd hh:mi:ss.ms"
                format = string.gsub(format, "yyyy", string.PadLeft(self.year, "0", 4))
                format = string.gsub(format, "mm", string.PadLeft(self.month, "0", 2))
                format = string.gsub(format, "dd", string.PadLeft(self.day, "0", 2))
                format = string.gsub(format, "hh", string.PadLeft(self.hour, "0", 2))
                format = string.gsub(format, "mi", string.PadLeft(self.min, "0", 2))
                format = string.gsub(format, "ss", string.PadLeft(self.sec, "0", 2))
                format = string.gsub(format, "ms", string.PadLeft(self.millisec, "0", 3))
                return format
            end, 

        SetString =
            function (self, timeString) --"year/month/day hour:minute:second.milliSecond"
                self:Clear()
                timeString = string.gsub(timeString, "/", " ")
                timeString = string.gsub(timeString, "-", " ")
                timeString = string.gsub(timeString, ":", " ")
                timeString = string.gsub(timeString, "%.", " ")

                local sp = CStringSpliter(" ")
                local len = sp:Split(timeString)
                if len < 3 or len > 7 then
                    return
                end
                if len >= 3 then
                    self.year = tonumber(sp:GetItem(1))
                    self.month = tonumber(sp:GetItem(2))
                    self.day = tonumber(sp:GetItem(3))
                end
                if len >= 6 then
                    self.hour = tonumber(sp:GetItem(4))
                    self.min = tonumber(sp:GetItem(5))
                    self.sec = tonumber(sp:GetItem(6))
                end
                if len == 7 then
                    self.millisec = tonumber(sp:GetItem(7))
                end
                return true
            end,

    }
}
