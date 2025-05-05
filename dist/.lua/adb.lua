module={}

function module.getContent(fn,page)
    local sqlite3 = require("lsqlite3")
    local db = sqlite3.open_memory()
    local stmt =
	db:prepare(
		-- "SELECT name, mode, mtime, sz FROM zipfile(:zipfile) WHERE (mode = 0 or mode & 04 = 04) ORDER BY name"
        "SELECT data FROM zipfile(:zipfile) WHERE (name = :name)"
	)
    stmt:bind_names{ zipfile = fn..".ptk" , name = fn.."/"..page..".js" }  
    data =''
    for row in stmt:nrows() do
        data=row.data;
        break
    end
    stmt:finalize()
    return data
end

local unix=require('unix') 
function module.getList()
    list = {}   
    for f in assert(unix.opendir(".")) do
        if string.sub(f, -4) == ".adb" and path.isfile(f) then 
            table.insert(list,string.sub(f, 1, #f - 4)) 
        end
    end
    return list
end
return module