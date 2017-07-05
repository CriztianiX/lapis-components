local cellm = function(name)
  local split = require("lapis.components.common").split
  local cem = split(":", name)
  local path = "cells." .. cem[1]
  local cell = path .. ".cell"
  local method = cem[2] or "display"  
  local template = path .. "." .. (method == "display" and "display" or method)
  return cell, method, template
end

return function(self, name, args)
  if not name then
    error("Missing argument 'name' for cell")
  end

  local cell, method, template = cellm(name)
  local status, mod = pcall(require, cell)


  if not status then
    error("Cell " .. cell .." not found")
  end

  if not mod[method] then
    error("Method '" .. method .. "' not found in cell")
  end

  local status, widget = pcall(require, template)
  
  if not status then
    error("Template '" .. template .. "' not found in cell")
  end

  local res = mod[method](self, args)
  local view = widget(res)

  return view:render_to_string()
end