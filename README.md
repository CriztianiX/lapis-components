# lapis-components

-- VIEW
<%- cell("notifications", { arg1 = "value1" }) %>

-- VIEW CELL
-- cells/notifications/display.etlua
DISPLAY DE CELL
<%= name %> 

-- CELL
-- cells/notifications/cell.lua
local  display  = function(app, args)
  return {
    name = "Display method"
  }
end

return {
  display = display,
  my_method = function(app, args)
    return {
      name = "Custom method"
    }
  end
}