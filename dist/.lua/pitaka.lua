module={}
ptks={}

local unix=require('unix') 
local path=require('path')

function getList()
    list = {}
    for f in assert(unix.opendir(".")) do
        if f and string.sub(f, -4) == ".ptk" and path.isfile(f) then 
            table.insert(list,string.sub(f, 1, #f - 4)) 
        end
    end
    return list
end

local Zip=require('zip')
function loadZips()
    local ptkfiles=getList()
    for i=1, #ptkfiles do 
        local f=assert(io.open(ptkfiles[i]..".ptk","rb"))
        buf=f:read("*all")
        local zip=Zip.open(buf)
        ptks[ptkfiles[i]]=zip
        print("loaded",ptkfiles[i],#zip.files)
    end
end
loadZips()

function module.getContent(fn,page)
    local zip=ptks[fn]
    local pagename=fn.."/".. page ..".js"
    local f = Zip.find(zip, pagename)
    if f then 
        return f.content 
    else
        return ""
    end
end

module.getList=getList;
return module