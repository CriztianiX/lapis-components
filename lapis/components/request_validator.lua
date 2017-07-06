local respond_to, capture_errors
do
    local application = require("lapis.application")
    respond_to = application.respond_to
    capture_errors = application.capture_errors
end

-- The authentication method
local require_login = function(fn)
  return function(self)
    if self.session.current_user then
      return fn(self)
    end
    return { redirect_to = self:url_for("users_login") }
  end
end

local protected = function(endpoint)
  return capture_errors({
    require_login(function(self)
      return endpoint.application(self)
    end)
  })
end

return function(endpoint)
  if endpoint.public then
    return capture_errors(function(self)
      return endpoint.application(self)
    end)
  else
    return protected(endpoint)
  end
end