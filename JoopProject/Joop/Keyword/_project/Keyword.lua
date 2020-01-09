--region Keyword.lua
--Author : jefflwq
--Date   : 2016/02/23
--说明   : 加载Keyword
--endregion

local files = 
{
    "keyword",             --keyword关键字, 用于定义一个新的关键字
    "namespace",         --namespace关键字, 用于定义一个namespace
    "using",             --using关键字, 用于引用一个namespace
    "super",             --super关键字, 用于在类中调用基类成员函数
    "modifier",             --定义modifier关键字,可以用这个关键字定义用于类成员的修饰符
    "public",             --public修饰符, 声明该类成员是公共成员
    "const",             --const修饰符, 声明该类成员是常量, 同时也是静态成员
    "static",             --static修饰符, 声明该类成员是静态成员
    "class",             --class关键字, 用于定义一个类
    "static_class",         --static_class关键字, 用于定义一个静态类
    "enum",                 --enum关键字, 用于定义一个枚举
    "supers",             --supers关键字, 用于实现多重继承
    "import",             --import关键字, 用于导入类
}
return files
