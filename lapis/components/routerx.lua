local respond_to, capture_errors
do
    local application = require("lapis.application")
    respond_to = application.respond_to
    capture_errors = application.capture_errors
end
local to_json = require("lapis.util").to_json
local from_json = require("lapis.util").from_json
local ngx = ngx

local pass = function(endpoint)
  return capture_errors({
      function(lapis)
          return endpoint.application(lapis)
      end
  })
end

local dict = function()
   return ngx.shared["page_cache"]
end

return function(app, routes, opts)
  local options = opts and next(opts) and opts or {}
  local authentication
  local dict = dict()
  
  if options.authentication then
    authentication = options.authentication
  end

  app:before_filter(function(self)
    if authentication then
      local cached_key =  "routerx_" .. self.route_name
      local cached_route = dict:get(cached_key)

      if(cached_route) then
        local cached_route = from_json(cached_route)
        if not cached_route.public then
          local is_authenticated = authentication:is_authenticated(self)
          
          if not is_authenticated then
            return self:write({redirect_to = self:url_for("users_login")})
          end
        end
      end
    end
  end)

  for _,e in ipairs(routes) do
    if not e.method then
      e.method = { "DELETE", "GET", "HEAD", "POST", "PUT" }
    end

    if type(e.method) == "string" then
      e.method = { e.method }
    end
  
    local dis = {}
    for _,v in ipairs(e.method) do
        dis[v] = pass(e)
    end

    local cache_key = "routerx_" .. e.name
    dict:set(cache_key, to_json({
      match = e.match,
      public = e.public
    }))

    app:match(e.name, e.match, respond_to(dis))
  end

  return app
end