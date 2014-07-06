-- http://nyaos.org/d/index.cgi?p=%282013.05.04%29+2300#p1
local lastresult
function nyaos.keyhook.escdot(t)
    if t.key ~= nyaos.key.CTRL_J then
        lastresult = nil
        return
    end
    local count,backspace=1,0
    if lastresult then
        count = lastresult[1]
        if count >= #nyaos.history then
            count = 1
        end
        backspace = lastresult[2]
    end
    local lastone = nyaos.history[#nyaos.history-count]
    if not lastone then
        return
    end
    lastone = string.gsub(lastone,"%s+$","")
    local quote=false
    local start=0
    for i=1,string.len(lastone) do
        local c=string.sub(lastone,i,i)
        if c == '"' then 
            quote = not quote 
        elseif c == ' ' and not quote then
            start = i
        end
    end
    local result=string.sub(lastone,start+1)
    lastresult = { count+1 , nyaos.len(result) }
    local r={}
    for i=1,backspace do
        r[i] = nyaos.key.BACKSPACE
    end
    return r,result
end
