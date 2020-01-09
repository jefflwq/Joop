--region JoopProjectLoader.lua
--Author : jefflwq
--Date   : 2016/02/28
--说明   : 加载Joop和其他工程
--endregion

------------------------------------------------------------------------------------------------------------------
--加载JAddonLoader
--local loader = JoopProject:NewProject("JAddonLoader")
--local ret = loader:LoadProject()
--if ret == false then
--    return
--end
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
--加载Joop
local joop = JoopProject:NewProject("Joop")
local ret = joop:LoadProject()
if ret == false then
    return
end
------------------------------------------------------------------------------------------------------------------

if ___NoTest then
    return
end
using "Joop"

-----------------------------------------------------------
----加载测试程序
--JoopTester.JoopTestManager:StartTest()
JoopProject:LoadTester()


System.Tester.StartTest()
-----------------------------------------------------------

