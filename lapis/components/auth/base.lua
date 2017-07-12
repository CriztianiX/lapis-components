local capture_errors
do
    local application = require("lapis.application")
    capture_errors = application.capture_errors
end

local class = require 'middleclass'
local Base = class('Base')

function Base:initialize(config)
  self.config = config
end

function Base:autenticate(endpoint)
    return capture_errors({
        self:_autenticate(endpoint)
    })
end

return Base