-------------------------------------------------------------------------
---------------------------- Server Settings ----------------------------
local bindaddr='127.0.0.1'
local port = 2555
-------------------------------------------------------------------------
local pitaka=require('pitaka')

ProgramAddr(bindaddr)
ProgramPort(port)
HidePath('/usr/share/zoneinfo/')
HidePath('/usr/share/ssl/')

local re=require('re')
local ptkpath = re.compile[[([a-z\-]+)/(\d\d\d).js]]
local str=require('str')

-- LaunchBrowser('');
print("Accelon25 started on http://"..bindaddr..":".. port)
print("按住Ctrl键再点网址以打开")
print("Holding Ctrl key and click on the link to open")
local ptkfiles=pitaka.getList()

SetLogLevel(0)


function OnHttpRequest()
    local path = GetPath()
    _,fn,page=ptkpath:search(path)
    if page =="" or page==nil then page = "0"  end
    page = str.padStart(page,3,"0")
    SetHeader('Content-Language', 'utf-8')
    if path=="/listdb" then
        local filelist=pitaka.getList()
        Write(table.concat(filelist, ","));
    else 
        if not _ then
            Route()
        else
            local content=pitaka.getContent(fn,page)
            Write(content)
        end    
    end
end