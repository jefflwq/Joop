--region CUnorderedTreeNode.lua
--Author : jefflwq
--Date   : 2018/12/18
--说明   : 树的节点（无序）
--endregion

using "Joop"

namespace "System.Collections.Generic"
{
    class "CUnorderedTreeNode" 
    {
		Key = false,
		Data = false,
        Tag = false,
        Parent = false,
		Children = false,
        CUnorderedTreeNode = 
            function (self, key, data, parent, noChildren)
				self:SetData(key, data, parent)
				if not noChildren then
					self.Children = {}
				end
            end,
        SetData = 
            function (self, key, data, parent)
				self.Key = key or false
				self.Data = data or false
				self.Parent = parent or false
            end,
        SetChild = 
            function (self, key, data, nodeClass)
				nodeClass = nodeClass or CUnorderedTreeNode
                local node = nodeClass(key, data, self)
				self.Children[key] = node
                return node
            end,
        GetChildCount = 
            function (self)
				if not self.Children then
					return 0
				end
				return #self.Children
            end,
    }
}
