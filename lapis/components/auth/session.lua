local class = require('middleclass')
local Base = require('lapis.components.auth.base')
local Session = class('Session', Base)

function Session:is_authenticated(lapis)
  if lapis.session.current_user then
    return true
  end
  
  return false
end

return Session