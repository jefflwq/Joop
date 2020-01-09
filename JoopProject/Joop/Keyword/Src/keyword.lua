--region keyword.lua
--Author : jefflwq
--Date   : 2016/02/23
--说明   : 定义keyword关键字,稍后可用来定义新的关键字，支持继承
--语法   : keyword "Name" : super {body}
--endregion

using "Joop"

JPrototype "keyword"
{
    RegisteredKeywords = {},
    
    ___keyword = -- 
        function(self)
            Joop:RegisterJoopKeyFinder(self)                --注册自己到___JoopKeyFinder
            --Joop.JCoreTypes:Register("keyword", self)        --注册到JCoreTypes
        end,

    ___OnRegister =
        function(self)
            local name = GetJoopTypeName(self)
            if self.RegisteredKeywords[name] then
                Error("Redefined : " .. name, 3)
                return
            end
            self.RegisteredKeywords[name] = self
            return true
            --Debug(self, "___OnRegister", kwd.___name, " is Registered")
        end,

    OnFindKey = 
        function(self, key)
            return rawget(self.RegisteredKeywords, key)
        end,
}
