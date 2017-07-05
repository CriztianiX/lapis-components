-- http://lua-users.org/wiki/MakingLuaLikePhp
local split = function(div,str)
  if (div=='') then 
    return false 
  end
  
  local pos,arr = 0,{}
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1))
    pos = sp + 1
  end

  table.insert(arr,string.sub(str,pos))
  return arr
end


return function(app, name)
  local cem = split(":",  name)
  local cell = "cells." .. cem[1] .. ".cell"
  local method = cem[2] or "display"

  local status, mod = pcall(require, cell)

  if not status then
    error("Cell " .. cell .." not found")
  end

  local res = mod[method]()
  return res
end