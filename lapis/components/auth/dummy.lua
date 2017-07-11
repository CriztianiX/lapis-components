local capture_errors
do
    local application = require("lapis.application")
    capture_errors = application.capture_errors
end

local class = require('middleclass')
local Base = require('lapis.components.auth.base')
local Dummy = class('Dummy', Base)

function Dummy:_autenticate(endpoint)
    return function(lapis)
        return endpoint.application(lapis)
    end
end

return Dummy