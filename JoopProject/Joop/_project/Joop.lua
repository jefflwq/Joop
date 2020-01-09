--region Joop.lua
--Author : jefflwq
--Date   : 2016/02/21
--说明   : 加载Joop
--endregion

------------------------------------------------------------------------------------------------------------------
--加载Joop核心库
local curProj = JoopProject:GetCurrentProject(...)

local core = curProj:NewProject("Core")
local ret = core:LoadProject()
------------------------------------------------------------------------------------------------------------------
local kwd = curProj:NewProject("Keyword")
ret = kwd:LoadProject()

local lib = curProj:NewProject("JLib")
ret = lib:LoadProject()

return ret


