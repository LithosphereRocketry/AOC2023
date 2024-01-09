
local file = io.open("input.txt", "r")
local content = (file:read "*a") .. ","
local cmds = string.gmatch(content, "[^,]+,")

function hash(str)
    local val = 0
    for i = 1, #str do
        val = ((val + str:byte(i))*17)%256
    end
    return val 
end

function indexOf(table, val)
    for k, v in ipairs(table) do
        if v == val then
            return k
        end
    end
    return nil
end

boxes = {}
focuslens = {}
for cmd in cmds do
    local tcmd = cmd:sub(1, #cmd-1)
    if tcmd:sub(#tcmd) == "-" then
        local lbl = tcmd:sub(1, #cmd-2)
        local ind = hash(lbl)+1
        if boxes[ind] == nil then
            boxes[ind] = {}
            focuslens[ind] = {}
        end
        local key = indexOf(boxes[ind], lbl)
        if key ~= nil then
            table.remove(boxes[ind], key)
            table.remove(focuslens[ind], key)
        end
    else
        local eqind = tcmd:find("=")
        local lbl = tcmd:sub(1, eqind-1)
        local ind = hash(lbl)+1
        if boxes[ind] == nil then
            boxes[ind] = {}
            focuslens[ind] = {}
        end
        local flen = tonumber(tcmd:sub(eqind+1, #tcmd))

        local key = indexOf(boxes[ind], lbl)
        if key == nil then
            table.insert(boxes[ind], lbl)
            table.insert(focuslens[ind], flen)
        else
            focuslens[ind][key] = flen
        end
    end
end


local total = 0
for i, box in pairs(focuslens) do
    for j, fl in ipairs(box) do
        total = total + (i * j * fl)
    end
end

print(total)