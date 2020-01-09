--region JoopProject.lua
--Author : jefflwq
--Date   : 2016/02/28
--说明   : 创建JoopProject
--endregion


------------------------------------------------------------------------------------------------------------------
if JoopProject ~= nil then
     print("Error : JoopProject is already defined.")-- JoopProject 已经被使用
     return
end

local type = type
local error = error
local ipairs = ipairs
local Print = Print
local select = select
local rawget = rawget
local loadfile = loadfile
local setmetatable = setmetatable
local io_open = io.open
local string_gsub = string.gsub
local table_insert = table.insert

local function GetCurrentProject(proj, ...)  
    local proj = select(1, ...)
    if type(proj) == "table" and type(rawget(proj, "NewProject")) == "function" then
        return proj
    end
    error("Error : Failed while GetCurrentProject.", 2)
end

local function GetCurrentDir()  
    local obj=io.popen("cd") --如果不在交互模式下，前面可以添加local 
    local dir=obj:read("*all"):sub(1,-2) --path存放当前路径
    obj:close() 
    return dir .. "\\"
end

local function PrintLoadingInfo(proj, loadingType, msg)
    if not proj.WantLoadingInfo then
        return
    end
    if not ___NoLoadingInfo then
        print("*** Loading " .. loadingType .. " : ", msg)
    end
end

local function IsFileExist(fullPath)  
    local f = io_open(fullPath, "rb")
    if not f then
        return false
    end
    f:close()
    return true
end

local function LoadLuaFile(proj, file, ignoreNotExist)  
    local path = proj.RootPath .. proj.Path .. string_gsub(file, "%.", "\\") .. ".lua"
    if not IsFileExist(path) then
        if ignoreNotExist then
            return true
        else
            print("*** ERROR : File does not exist => ", path )
            return false
        end
        return ignoreNotExist or false
    end
    PrintLoadingInfo(proj, "File", proj.NodePath .. "." .. file)
    local f, msg = loadfile(path)
    if f then
        return f(proj)
    else
        print("*** ERROR : ", msg)
        return false
    end
end

local function LoadProjectFiles(proj, files)  
    local ret
    local noSrcPath = rawget(files, "___NoSrcPath")
    local srcFiles = proj.SourceFiles
    local noCompile = srcFiles.___NoCompile
    for i, file in ipairs(files) do
        if string.sub(file, 1, 1) == "#" then --不加密
            file = string.sub(file, 2)
            noCompile[file] = true
            files[i] = file
        end
        table_insert(srcFiles, file)
    end
    if files.___PreLoadFiles then
        srcFiles = proj.SourceFiles.___PreLoadFiles
        noCompile = srcFiles.___NoCompile
        for i, file in ipairs(files.___PreLoadFiles) do
            if string.sub(file, 1, 1) == "#" then --不加密
                file = string.sub(file, 2)
                noCompile[file] = true
                files.___PreLoadFiles[i] = file
            end
            table_insert(srcFiles, file)
        end
    end
    if files.___PostLoadFiles then
        srcFiles = proj.SourceFiles.___PostLoadFiles
        noCompile = srcFiles.___NoCompile
        for i, file in ipairs(files.___PostLoadFiles) do
            if string.sub(file, 1, 1) == "#" then --不加密
                file = string.sub(file, 2)
                noCompile[file] = true
                files.___PostLoadFiles[i] = file
            end
            table_insert(srcFiles, file)
        end
    end
    if files.___PreLoadFiles then
        for _, file in ipairs(files.___PreLoadFiles) do
            file = noSrcPath and file or ("Src." .. file)
            ret = LoadLuaFile(proj, file)
            if ret == false then
                return false
            end
        end
    end
    for _, file in ipairs(files) do
        file = noSrcPath and file or ("Src." .. file)
        ret = LoadLuaFile(proj, file)
        if ret == false then
            return false
        end
    end
    if files.___PostLoadFiles then
        for _, file in ipairs(files.___PostLoadFiles) do
            file = noSrcPath and file or ("Src." .. file)
            ret = LoadLuaFile(proj, file)
            if ret == false then
                return false
            end
        end
    end
    return true
end

local function LoadProject(proj)  
    if not IsFileExist(proj.ProjectFile) then
        print("*** ERROR : Project does not exist => ", proj.NodePath )
        return false
    end
    PrintLoadingInfo(proj, "Project", proj.NodePath)
    local ret = loadfile(proj.ProjectFile)(proj)
    if type(ret) == "table" then
        ret = LoadProjectFiles(proj, ret)
    end
    return ret
end

local function LoadTesterFiles(proj)  
    local ret
    local file
    local files = proj.SourceFiles
    for _, file in ipairs(files) do
        file = "Tester." .. file .. "_Tester"
        ret = LoadLuaFile(proj, file, true)
        if ret == false then
            return false
        end
        table.insert(proj.TesterFiles, file)
    end
    return true
end

local function LoadTester(proj)  
    PrintLoadingInfo(proj, "Tester", proj.NodePath)
    local ret = LoadTesterFiles(proj)
    if ret == false then
        return false
    end
    for _, child in ipairs(proj.Children) do
        ret = LoadTester(child)
        if ret == false then
            return false
        end
    end
    return true
end

local function GetAllSourceFiles(proj, all)  
    local ret = {}
    local files = proj.SourceFiles
    local noCompile = files.___NoCompile
    local noSrcPath = rawget(files, "___NoSrcPath")
    for _, file in ipairs(files) do
        if all or not noCompile[file] then
            file = noSrcPath and file or ("Src." .. file)
            file = string_gsub(file, "%.", "\\") .. ".lua"
            table_insert(ret, file)
        end
    end
    if files.___PreLoadFiles then
        ret.___PreLoadFiles = {}
        for _, file in ipairs(files.___PreLoadFiles) do
            if all or not noCompile[file] then
                file = noSrcPath and file or ("Src." .. file)
                file = string_gsub(file, "%.", "\\") .. ".lua"
                table_insert(ret.___PreLoadFiles, file)
            end
        end
    end
    if files.___PostLoadFiles then
        ret.___PostLoadFiles = {}
        for _, file in ipairs(files.___PostLoadFiles) do
            if all or not noCompile[file] then
                file = noSrcPath and file or ("Src." .. file)
                file = string_gsub(file, "%.", "\\") .. ".lua"
                table_insert(ret.___PostLoadFiles, file)
            end
        end
    end



    local child
    local children = proj.Children
    local ct
    local cs
    for _, child in ipairs(children) do
        ct = GetAllSourceFiles(child)
        for _, cs in ipairs(ct) do
            table_insert(ret, child.Name .. "\\" .. cs)
        end
        if ct.___PreLoadFiles then
            ret.___PreLoadFiles = ret.___PreLoadFiles or {}
            for _, cs in ipairs(ct.___PreLoadFiles) do
                table_insert(ret.___PreLoadFiles, child.Name .. "\\" .. cs)
            end
        end
        if ct.___PostLoadFiles then
            ret.___PostLoadFiles = ret.___PostLoadFiles or {}
            for _, cs in ipairs(ct.___PostLoadFiles) do
                table_insert(ret.___PostLoadFiles, child.Name .. "\\" .. cs)
            end
        end
    end
    return ret
end

local function FindChild(proj, name)  
    local child
    local children = proj.Children
    for _, child in ipairs(children) do
        if child.Name == name then
            return child
        end
    end
end

local function NewProject(parentOrPath, name, wantLoadingInfo)
    local proj = 
    {
        Name = name,
        Parent = false,
        ProjectFile = "",
        Path = "",
        RootPath = "",
        NodePath = "",
        SourceFiles = 
        { 
            ___NoCompile = {},
            ___PreLoadFiles = { ___NoCompile = {} },
            ___PostLoadFiles = { ___NoCompile = {} },
        },
        TesterFiles = {},
        Children = {},
        LoadProject = LoadProject,
        LoadTester = LoadTester,
        NewProject = NewProject,
        GetAllSourceFiles = GetAllSourceFiles,
        GetCurrentProject = GetCurrentProject,
        WantLoadingInfo = wantLoadingInfo or (JoopProject and JoopProject.WantLoadingInfo) or true,
    }
    if type(parentOrPath) == "string" then
        proj.RootPath = parentOrPath
        --proj.Path = parentOrPath
        proj.NodePath = name
    elseif type(parentOrPath) == "table" then
        proj.Parent = parentOrPath
        proj.RootPath = parentOrPath.RootPath
        proj.Path = parentOrPath.Path .. proj.Name .. "\\"
        proj.NodePath = parentOrPath.NodePath .. "." .. name
        table.insert(proj.Parent.Children, proj)
    end
    proj.ProjectFile = proj.RootPath .. proj.Path .. "_project\\" .. proj.Name .. ".lua"
    setmetatable(proj, {__index = FindChild})
    return proj
end

--创建JoopProject节点
JoopProject = NewProject(select(1, ...) or GetCurrentDir(), "JoopProject")
--JoopProject.GetCurrentProject = GetCurrentProject
------------------------------------------------------------------------------------------------------------------
