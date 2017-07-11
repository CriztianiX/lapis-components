local class = require('middleclass')
local Base = require('lapis.components.auth.base')
local Session = class('Session', Base)

-- The authentication method
local require_login = function(fn, auth)
  return function(lapis)
    if lapis.session.current_user then
      return fn(lapis)
    end
    
    return { 
      redirect_to = lapis:url_for("users_login") 
      }
  end
end

local protected = function(endpoint, auth)
    return require_login(function(lapis)
      return endpoint.application(lapis)
    end, auth)
end

function Session:_autenticate(endpoint)
  return protected(endpoint, self)
end

return Session