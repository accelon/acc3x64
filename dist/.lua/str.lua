module ={}
module.abc='xyz'

function module.padStart(s, length, char)
    char = char or " " -- Default padding character is a space
    str = tostring(str) -- Ensure the input is a string
    local padLength = length - #s
    if padLength > 0 then
        return string.rep(char, padLength) .. s
    else
        return s
    end
end
function module.endsWith(s, ending)
    return string.sub(s, -#ending) == ending
end

return module