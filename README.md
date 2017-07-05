# lapis-components
    
# Cells
Cells are small mini-controllers that can invoke view logic and render out templates. The idea of cells is borrowed from cells in Ruby, where they fulfill a similar role and purpose.

```lua
app:before_filter(function(self)
  --
  -- This initializes the cell component
  self.cell = function(self, name, args)
    local cell = require("lapis.components.cell")
    return cell(self, name, args)
  end
end)
```
### Creating a Cell
To create a cell, define a module and a template in cells/[NAME] directory. In this example, we’ll be making a cell to display the number of messages in a user’s notification inbox. First, create the module file. Its contents should look like:

```lua
--
-- cells/notifications/cell.lua
return {
  display = function(self, app, args)
    --
    -- do some stuff
    return {
        count = 1,
        notifications = {
            { id = 1, title = "My notification" }
        }
    }
  end
}
```

Next, our template looks like
``` lua
-- cells/notifications/display.etlua
<% for _,n in ipairs(notifications): do %>
  <b> n.notification </b>
<% end %>
```

Cells can be loaded from views using the cell()
``` lua
<%- cell("notifications", { arg1 = "value1" }) %>
``` 
The above will load the named cell and execute the display() method. 
You can execute other methods using the following:
``` lua
<%- cell("notifications:my_messages_count", { arg1 = "value1" }) %>
``` 
