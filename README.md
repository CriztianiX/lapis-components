# lapis-components

-- VIEW
<% render("cells.my_cell.display", cell("my_cell:my_method")) %>

-- VIEW CELL
DISPLAY DE CELL
<%= name %> 

-- CELL
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