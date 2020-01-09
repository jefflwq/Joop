--region class_Tester.lua
--Author : jefflwq
--Date   : 2016/03/02
--说明   : class 的测试程序
--endregion

if true then    --false:启用测试,  true:禁用测试(测试无问题后请设为true)
    return
end

using "Joop"

namespace "Testers.Keyword.Class"
{
    class "clsA"
    {
        public.const.const_name("const_name"),
        static.static_name("static_name"),
        normal_name = false, --定义成员变量时初始化好像不好用,需要在构造函数内初始化
        static.const.staticconst_name("static.const.name"), --或者这样
        clsA = 
            function(self, name)
                --local metat=getmetatable(self)
                self.normal_name =  name
                Print("In clsA.")
            end,
        PrintName = 
            function(self)
                --local metat=getmetatable(self)
                Print("In clsA.PrintName")
                Print(GetJoopTypeName(self), self.normal_name, self.const_name, self.static_name, self.public_name)
            end,

        class "clsAA" --class内也可以定义class
        {
            clsAA_name = "clsAA_name",
            clsAA_name2 = "clsAA_name2",
            clsAA = 
                function(self, name)
                    self.clsAA_name = name
                end,
            PrintName = 
                function(self)
                    --local metat=getmetatable(self)
                    Print(self.___name, self.clsAA_name, self.clsAA_name2)
                end,
            --name = "clsAname"
        },
    },
    class "clsB" : clsA --继承自clsA
    {
        clsB1 = 
            function(self, name)
                Print("In clsB.")
                self.super(name)
                --super.PrintName(self)
                --clsA.clsA(self, name)
                --Print(super.aaa)
                --clsA.clsA(self, name)
            end,
            PrintName = 
                function(self)
                    --local metat=getmetatable(self)
                    Print("In clsB.PrintName")
                     self.super.PrintName()
                end,
    },
    class "clsC" : clsB
    {
        clsC = 
            function(self, name)
                Print("In clsC.")
                self.super(name)
                --clsB.clsB(self, name)
                --debug.getinfo
                --self.___super(self,name)
            end,
            PrintName = 
                function(self)
                    --local metat=getmetatable(self)
                    Print("In clsC.PrintName")
                    self.super.PrintName()
                end,
    },
}

using "Testers.Keyword.Class"

using "System.Tester"

namespace "Testers.Keyword"
{
    static_class "class_Tester" : CJoopTester
    {
        IsEnabled = true,
        OnTest = 
            function(self, ...)
                self:TestClass()
            end,
        --你可以定义这个函数以指定传递给OnTest的参数
        --GetSpecifiedParams = 
            --function(self, ...)    
                --return "SpecifiedParam1", "SpecifiedParam2"
            --end,
        TestClass = 
            function(self, ...)
                --write your test code here
                --local obj = class()
                local ca1 = clsA("ca1")
                local ca2 = clsA("ca2")
                local cb1 = clsB("cb1")
                local cb2 = clsB("cb2")
                local cc1 = clsC("cc1")
                local cc2 = clsC("cc2")
                local caa1 = clsA.clsAA("caa1")
                local caa2 = clsA.clsAA("caa2")
                ca1:PrintName()
                ca2:PrintName()
                cb1:PrintName()
                cb2:PrintName()
                cc1:PrintName()
                cc2:PrintName()
                caa1:PrintName()
                caa2:PrintName()

                ca1.static_name = "static_name_changed_by_ca1"
                clsA:PrintName()
                ca2.static_name = "static_name_changed_by_ca2"
                clsA:PrintName()
                cb1.static_name = "static_name_changed_by_cb1"
                clsA:PrintName()
                cb2.static_name = "static_name_changed_by_cb2"
                clsA:PrintName()
                cc1.static_name = "static_name_changed_by_cc1"
                clsA:PrintName()
                cc2.static_name = "static_name_changed_by_cc2"
                clsA:PrintName()
                ca1:PrintName()
                ca2:PrintName()
                --clsA.const_name = "1"
                ca1:PrintName()
                --ca1.staticconst_name = 1

                local ccc = ca1:Clone()
                ccc:PrintName()
            end,
    },
}
