leaf = {}

--- prints everything in a pretty way. First argument is framed separatedly.
--- note that tables are printed in a python-like style.
--- @param tag any anything that has __tostring or is valid to tostring
--- @param ... any same of tag.
function leaf.log(tag, ...)
    local arg = {...}
    if type(tag) == 'table' then
        -- check if object has tostring --
        if getmetatable(tag) then tag = tostring(tag)
        else
            local tmp = ''
            for i, v in pairs(tag) do
                if tmp ~= '' then
                    if type(i) ~= 'number' then

                        tmp = tmp .. ', ' .. (i) .. ': '

                    else tmp = tmp .. ', ' end
                else
                    if type(i) ~= 'number' then

                        tmp = (i) .. ': '
                    end
                end
                tmp = tmp .. tostring(v)
            end
            tag = tmp
        end
    end
    -- make all arguments strings --
    for i, a in ipairs(arg) do
        arg[i] = tostring(a)
    end

    -- Concat arguments --
    local cnc = table.concat(arg, ', ')

    local out = "[" .. tostring(tag) .. "]"

    if cnc ~= "" then out = out ..  "[" .. cnc .. "]" end
    print(out)
end

--- returns the sign of `number` or 0 for 0
--- @param number number
--- @return number
function math.sign(number)
    assert(type(number) == "number",
    'cannot check sign of a non numeric value')

    if number > 0 then return 1
    elseif number < 0 then return 1
    else return 0 end
end

--- rounds only `places` places of `number`
--- @usage math.floor_by(0.00456, 2) returns 0.004
--- @return number | nil
function math.floor_by(number, places)
    assert(type(number) == "number",
    'cannot floor a non numeric value')

    local n = tostring(number)
    local c = n:find('%.')
    if not c then return number
    else
        return
        tonumber(n:sub(1, math.max(#n - places, c - 1))) or nil
    end
end

--- returns the first key and value of `lst`
--- @param lst table
--- @return any i, any v
function leaf.table_first(lst)
    for i, v in pairs(lst) do return i, v end
end

--- returns the last key and value of `lst`
--- @param lst table
--- @return any i, any v
function leaf.table_last(lst)
    local idx, val
    for i, v in pairs(lst) do idx, val = i, v end
    return idx, val
end

--- searches `lst` for `val` and returns the index/
--- key of it once found, otherwise returns nil
--- @param lst table
--- @param val any
--- @return any idx
function leaf.table_find(lst, val)
    for idx, itm in pairs(lst) do
        if itm == val then return idx end
    end
end

--- compares the two tables and check if all keys in `lst`
--- are in `otr` and those keys' values are equal
--- @param lst table
--- @param otr table
--- @return boolean
function leaf.table_eq(lst, otr)
    for i in pairs(lst) do
        if lst[i] ~= otr[i] or not otr[i] then
            return false
        end
    end
    return true
end

--- returns a copy of `lst`
--- @param lst table
--- @return table other
function leaf.table_copy(lst)
    local other = {}
    for idx, val in pairs(lst) do
        other[idx] = val
    end
    return other
end

--- sets all fields of `lst` to the same values of the fields of `otr`
--- @param lst table table to reset
--- @param otr table default table
function leaf.table_reset(lst, otr)
    for i, v in pairs(otr) do
        lst[i] = v
    end
end

--- splits the given string in `pat`. if `pat`
--- is not found, an empty table is returned
--- @param self string string itself
--- @param pat  string pattern to match
--- @return table
function string.split(self, pat)
    -- do nothing if are equals --
    if self == pat then return {self} end
    if not self:find(pat) then return {} end

    -- table to store substrings --
    local subs = {}
    -- for every word --
    while true do
        -- get index of substring (div) --
        local findx, lindx = self:find(pat)

        -- store last substring --
        if not findx then
            subs[#subs + 1] = self
            break
        end
        -- store the substring before (div) --
        subs[#subs + 1], self = self:sub(1, findx - 1), self:sub(lindx + 1)
    end
    return subs
end

--- checks if the string starts with `sub`
--- @param self string string itself
--- @param sub  string substring to search by
--- @return boolean
function string.startswith(self, sub)
    return self:sub(1, #sub) == sub
end

--- checks if the string ends with `sub`
--- @param self string string itself
--- @param sub  string substring to search by
--- @return boolean
function string.endswith(self, sub)
    return self:sub(-#sub) == sub
end

--- strips out leading spaces at the beginning and at the end
--- of `self`
--- @param self string string itself
--- @return string
function string.strip(self)
    return self:match('[ \t\v]*(.*)[ \t\v]*')
end

--- converts "true" "True" or any combinations of lower and upper cases,
--- any number differend than 0 and anything not nil to true, anything else to false
--- @param value any
--- @return boolean
function tobool(value)
    if type(value) == 'string' then
    if value:lower() == 'true' then return true
    end

    elseif type(value) == 'number' then return value ~= 0
    else return value ~= nil end
    -- formallity --
    return false
end

return leaf