--region CStringSpliter.lua
--Author : jefflwq
--Date   : 2015/2/19
--说明   : StringSpliter类
--endregion

using "Joop"

using "System.Collections.Generic"
namespace "System.Text"
{
    class "CStringSpliter" : CStringBuilder
    {
        Spliter = "",
        IgnoreEmpty = false,
        Plain = true, --true表示不使用正则表达式搜索
        CStringSpliter = 
            function(self, strSpliter, bIgnoreEmpty, bPlain)
                self.super()
                self.Spliter = strSpliter or "\n"
                self.IgnoreEmpty = bIgnoreEmpty or false
                if bPlain == false then
                    self.Plain = false
                else
                    self.Plain = true
                end
            end,

        Split = function(self, strText)
            --- tabSplited : 最后返回的table表
            --- b : 查找时起始字符位置量,
            self:Clear()
            if strText == nil or strText == "" then
                return 0
            end
            local b = 0
            local iPos
            local temp
            local iSpliterLen = string.len(self.Spliter)
    
            while true do
                --- 从b+1开始查找，(不应从b+1开始，否则会当split同时出现时，会丢失后一个)
                --- 变量 b 保存前一次查找到的split的位置
                iPos = string.find(strText, self.Spliter, b, self.Plain)
                if iPos then
                    --- 将查找到的字符串添加到table表中
                    temp = string.sub(strText, b, iPos - 1)
                    if temp ~= "" or (not self.IgnoreEmpty) then
                        self:Insert(temp)
                    end
                    --- 保存变量 b 状态值，以便下次查找时使用
                    b = iPos  + iSpliterLen
                    --- 如果找不到指定split字符，则退出循环
                else
                    --- 如果剩余字符非空，则添加到table表中
                    temp = string.sub(strText, b, -1)
                    if temp ~= "" or (not self.IgnoreEmpty) then
                        self:Insert(temp)
                    end
                    break
                end
            end
            --- 返回
            return self:Size()
        end,
    }
}
