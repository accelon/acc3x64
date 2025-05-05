module={}
local ZipConst = {
    fileHeaderSignature = 0x504b0304, -- PK\0x03\0x04
    descriptorSignature = 0x504b0708, -- PK\0x07\0x08
    centralHeaderSignature = 0x504b0102, -- PK\0x01\0x02
    endSignature = 0x504b0506, -- PK\0x05\0x06
    fileHeaderLength = 30,
    centralHeaderLength = 46,
    endLength = 22,
    descriptorLength = 16
}
function getUint32(buf, pos, littleEndian)
    local b1 = string.byte(buf,pos + 1)
    local b2 = string.byte(buf,pos + 2)
    local b3 = string.byte(buf,pos + 3) 
    local b4 = string.byte(buf,pos + 4)
    if littleEndian then
        return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
    else
        return b4 + b3 * 256 + b2 * 65536 + b1 * 16777216
    end
end
function getUint16(buf, pos, littleEndian)
    local b1 = string.byte(buf,pos + 1)
    local b2 = string.byte(buf,pos + 2)
    if littleEndian then
        return b1 + b2 * 256
    else
        return b2 + b1 * 256
    end
end
function module.open(buf)
    obj={}
    obj.buf = buf
    obj.files = {}
    local endRecord = loadEndRecord(buf)
    if endRecord.fileCount > 0 then
        obj.files=loadFiles(buf,endRecord.fileCount, endRecord.centralSize, endRecord.centralOffset)
    end
    return obj
end

function loadFiles(buf, fileCount, centralSize, centralOffset)
    local coffset = #buf - ZipConst.endLength - centralSize
    local p = coffset
    local files={}
    for i = 1, fileCount do
        local signature = getUint32(buf, p)
        if signature ~= ZipConst.centralHeaderSignature then
            break
        end
        local size = getUint32(buf, p + 20, true)
        local namelen = getUint16(buf, p + 28, true)
        local extra = getUint16(buf, p + 30, true)
        local commentlen = getUint16(buf, p + 32, true)
        local offset = getUint32(buf, p + 42, true)
        
        p = p + ZipConst.centralHeaderLength
        local name = string.sub(buf,p+1, p + namelen)
        p = p + namelen + extra + commentlen

        offset = offset + ZipConst.fileHeaderLength + namelen
        local content

        local inbuf = centralOffset - coffset
        if offset - inbuf >= 0 then
            content = string.sub( buf, 1+ offset - inbuf , offset - inbuf + size)
        end
        table.insert(files, { name = name, offset = offset, size = size, content = content })
    end
    return files
end
function module.find(zip,name)
    for i=1, #zip.files do 
        if zip.files[i].name == name then
            return zip.files[i]
        end
    end
end
function loadEndRecord(buf)
    local endRecord = { signature = 0, fileCount = 0, centralSize = 0, centralOffset = 0 }
    local endpos = #buf - ZipConst.endLength 
    endRecord.signature = getUint32(buf, endpos)
    if endRecord.signature ~= ZipConst.endSignature then
        error("Wrong endRecord signature")
    end
    endRecord.fileCount = getUint16(buf, endpos + 8, true)
    endRecord.centralSize = getUint32(buf, endpos + 12, true)
    endRecord.centralOffset = getUint32(buf, endpos + 16, true)
    return endRecord
end
return module