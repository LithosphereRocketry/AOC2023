
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

local total = 0
for cmd in cmds do
    local tcmd = cmd:sub(1, #cmd-1)
    total = total + hash(tcmd)
end
print(total)