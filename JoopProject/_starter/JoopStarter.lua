--region JoopStarter.lua
--Author : jefflwq
--Date   : 2016/02/20
--说明   : 主启动程序, 需在环境变量中设置 LUA_PATH=?.lua
--参数   : BabeLua NoLoadingInfo NoTest PerformanceTest Release
--       : Absolutely(已废弃)
--endregion
print("luaver:", _VERSION)
local function GetCurrentDir()  
    local obj = io.popen("cd") --如果不在交互模式下，前面可以添加local 
    local dir = obj:read("*all"):sub(1,-2) --dir存放当前路径
    obj:close() 
    return dir .. "\\"
end
___CurrentDir = GetCurrentDir()

local supportedParams = 
{
    BabeLua = true,
    NoLoadingInfo = true,
    NoTest = true,
    PerformanceTest = true,
    Release = true,
    Absolutely = false, --(已废弃)
}

local function GetParams(...)  
    local n = select("#", ...)
    local s
    for i = 1, n do
        s = select(i, ...)
        if supportedParams[s] then
            _G["___" .. s] = true
        else
            local f, errmsg = loadstring("return {" .. s .. "}")
            if errmsg then
                print(errmsg)
                print("Invalid param format for ExtraFiles: ", s)
                os.exit()
            end
            _G["___ExtraFiles"] = f()
        end
    end
end
GetParams(...) 

local function LoadFile(dir, f)
    local func, errmsg = loadfile(dir .. f)
    if errmsg then
        print(errmsg)
        return
    end
    func(dir)
end

local function LoadJoopTester()
    if ___NoTest then
        return
    end
    LoadFile(___CurrentDir, [[\_starter\JoopTester.lua]])
end
LoadJoopTester()

local debug = debug
local getinfo = debug.getinfo
local clock = os.clock
local calls, total, this = {}, {}, {}

local function StartPerformanceTest(progFunc)
    debug.sethook(function(event)
        local i = getinfo(2, "Sln")
        if i.what ~= 'Lua' then
            return
        end
        local func = (i.source..':'..i.linedefined)
        if event == 'call' then
            this[func] = clock()
        else
            local time = clock() - (this[func] or 0)
            total[func] = (total[func] or 0) + time
            calls[func] = (calls[func] or 0) + 1
        end
    end, "cr")

    progFunc()

    -- the code to debug ends here; reset the hook
    debug.sethook()
    -- print the results
    for f,time in pairs(total) do
        print(("%.3f\t%d\t%s"):format(time, calls[f], f))
    end
end

local function GetProjectFiles()  
    local files
    files = 
    {
        [[\_project\JoopProject.lua]],
        [[\_project\JoopProjectLoader.lua]],
    }
    print("___ExtraFiles", ___ExtraFiles)
    if ___ExtraFiles then
        for i, f in ipairs(___ExtraFiles) do 
            print("___ExtraFiles",i, f)
            table.insert(files, f)
        end
    end
    return files  
end
local function LoadJoopProjects()
    print("************************************************************")
    print("Program started at : ", os.date("%Y/%m/%d %X"))
    print("************************************************************")

    local startTime = clock()
    local files = GetProjectFiles()
    for i, f in ipairs(files) do 
        LoadFile(___CurrentDir, f)
    end

    print("************************************************************")
    print("Program ended at :", os.date("%Y/%m/%d %X"))
    print("Totle used time:", clock() - startTime)
    print("************************************************************")
end

if ___PerformanceTest then
    StartPerformanceTest(LoadJoopProjects)
else
    LoadJoopProjects()
end

--os.execute("pause")


