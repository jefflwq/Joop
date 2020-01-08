# Joop
  这是一个支持面向对象的lua扩展库，模仿了C#的语法。
  可以简洁快速的创建class，object等。
  >支持class,namespace,using,import,enum,const,static,super等关键字，
  >以及event,action,delegate,重载,多重继承等。
  
#####  下面这个例子是一个典型的带继承的class。
	using "Joop"

	namespace "System.Collections.Generic"
	{
		class "CArgList" : CList
		{
			CArgList = 
				function(self, ...)
					self.super({...})
					--self:SetArgs(...)
				end,

			SetArgs = 
				function(self, ...)
					self:Clear()
					self:AddArgs(...)
				end,

			AddArgs = 
				function(self, ...)
					local n = select("#", ...)
					local s
					for i = 1, n do
						s = select(i, ...)
						self:Insert(s)
					end
				end,
		}
	}
#####   下面是使用这个class的方式
	using "System.Collections.Generic"           --通过namespace引用，同时可以使用该namespace下的所有class
	--或者
	import System.Collections.Generic.CArgList   --仅引用这一个class
	
	local argList = CArgList()
	argList:SetArgs(1,2,3)
	argList:AddArgs(4)