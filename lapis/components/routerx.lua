local respond_to, capture_errors
do
    local application = require("lapis.application")
    respond_to = application.respond_to
    capture_errors = application.capture_errors
end

return function(app, routes, request_validator)
  --Not using request validator, all pass
  if not request_validator then
    request_validator = function(endpoint)
      return capture_errors(function(self)
        return endpoint.application(self)
      end)
    end
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
      dis[v] = request_validator(e)
    end
    
    app:match(e.name, e.match, respond_to(dis))
  end

  return app
end