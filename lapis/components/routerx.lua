local respond_to, capture_errors
do
    local application = require("lapis.application")
    respond_to = application.respond_to
    capture_errors = application.capture_errors
end

local pass = function(endpoint)
  return capture_errors({
      function(lapis)
          return endpoint.application(lapis)
      end
  })
end

return function(app, routes, opts)
  local options = opts and next(opts) and opts or {}
  local authentication
  
  if options.authentication then
    authentication = options.authentication
  end

  for _,e in ipairs(routes) do
    if not e.method then
      e.method = { "DELETE", "GET", "HEAD", "POST", "PUT" }
    end

    if type(e.method) == "string" then
      e.method = { e.method }
    end
  
    local dis = {}
    for _,v in ipairs(e.method) do
      if (e.public) or (not authentication) then
        dis[v] = pass(e)
      else
        dis[v] = authentication:autenticate(e)
      end
    end

    app:match(e.name, e.match, respond_to(dis))
  end

  return app
end