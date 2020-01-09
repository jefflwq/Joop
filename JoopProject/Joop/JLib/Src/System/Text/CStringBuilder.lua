--region CStringBuilder.lua
--Author : jefflwq
--Date   : 2015/2/19
--说明   : StringBuilder类
--endregion

using "Joop"

using "System.Collections.Generic"
namespace "System.Text"
{
    class "CStringBuilder" : CList
    {
        BuildString = 
            function(self, separator, i, j)
                return table.concat(self.ListData, separator or nil, i, j)
            end,
    }
}
