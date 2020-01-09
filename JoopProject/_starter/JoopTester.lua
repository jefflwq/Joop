
--function getFile(file_name) 
--    local f = assert(io.open(file_name, 'r'))
--    local string = f:read("*all")
--    f:close()
--    return string
--end 

--function writeFile(file_name,string)
-- local f = assert(io.open(file_name, 'w'))
-- f:write(string)
-- f:close()
--end 
----从命令行获取参数， 如果有参数则遍历指定目录，没有参数遍历当前目录 
-- cmd = [[dir /s P:\SVN\MyProject\Lua\JoopSolution\JoopProject\WowAddon\JWowAddon\JAutoAction\Tester]]
-- print("cmd", cmd)
----io.popen 返回的是一个FILE，跟c里面的popen一样 
--local s = io.popen(cmd)
--local fileLists = s:read("*all")
--print(fileLists)
--while true do --从文件列表里一行一行的获取文件名
--_,end_pos, line = string.find(fileLists, "([^\n\r]+.lua)", start_pos)
--        if not end_pos then break end --    
--        print ("wld", line) 
--        local str = getFile(line)
--    --把每一行的末尾 1, 替换为 0, 
--    local new =string.gsub(str, "1,\n", "0,\n");
--    --替换后的字符串写入到文件。以前的内容会清空     
--    writeFile(line, new)
--    start_pos = end_pos + 1 
--end
local function TestOperator(v, ret)
    print(v)
    return ret
end



local function Test()
    --local v = TestOperator(1, false) or TestOperator(2, true) and TestOperator(3, true)
    --v = (TestOperator(1, true) or TestOperator(2, true)) and TestOperator(3, false)
    --print(v)
    --print(string.sub("aasdfadf", 2))
    --print(tonumber(os.date("%Y%m%d"), 10))
    --local t = {}
    --print(os.date("%w"))
    --print(string.sub(tostring(t), 8))
    --print(string.sub(tostring(t), 2))
    --local itemString = select(3, string.find("|cFFFFFFFF|Hitem:12345:0:0:0|h[Item Name]|h|r", "|H(.+)|h"))
    --local itemId = select(3, string.find("|cFFFFFFFF|Hitem:12345:0:0:0|h[Item Name]|h|r", "item:(%d+)"))
    --print(itemId, itemString)
end


Test()





local function TestCompareModifyTime()
    local str = os.date("%Y%m%d")


    package.cpath  = [[P:\SVN\MyProject\Lua\JoopSolution\JoopProject\?.dll]]
    require "luanet"
    ----require "LuaInterface"
    ----加载CLR的类型、实例化CLR对象
    --luanet.load_assembly("System")
    luanet.load_assembly("System.IO")
    ___DotNetFile = luanet.import_type("System.IO.File")
    --FileInfo = luanet.import_type("System.IO.FileInfo")
    --DateTime = luanet.import_type("System.DateTime")
    --fi = FileInfo([[P:\SVN\MyProject\Lua\JoopSolution\JoopProject\1.txt]])
    ----fi:CopyTo([[P:\SVN\MyProject\Lua\JoopSolution\JoopProject\3.txt]])
    --a = File.Exists([[P:\SVN\MyProject\Lua\JoopSolution\JoopProject\3.txt]]);
    ----print(fi)
    --fi1 = File.GetLastWriteTime([[P:\SVN\MyProject\Lua\JoopSolution\JoopProject\1.txt]]);
    --fi2 = File.GetLastWriteTime([[P:\SVN\MyProject\Lua\JoopSolution\JoopProject\2.txt]]);
    --print(fi1)
    --print(fi2)
    --fi1:ToString()
    --ret = fi1:CompareTo(fi2)
    --    print(ret)
    --print(fi1:ToString())
    

    local aaaa =    CompareModifyTime([[P:\SVN\MyProject\Lua\JoopSolution\JoopProject\1.txt]],[[P:\SVN\MyProject\Lua\JoopSolution\JoopProject\2.txt]])
    print(aaaa)
end

CompareModifyTime =
    function( path1, path2) 
        if not ___DotNetFile.Exists(path1) then
            if not ___DotNetFile.Exists(path2) then
                return false
            else
                return -2
            end
        elseif not ___DotNetFile.Exists(path2) then
            return 2
        end
        return ___DotNetFile.GetLastWriteTime(path1):CompareTo(___DotNetFile.GetLastWriteTime(path2))
    end
