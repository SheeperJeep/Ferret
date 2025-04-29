--------------------------------------------------------------------------------
--   DESCRIPTION: Abstract action class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Action : Object
---@field name string
Action = Object:extend()

---@param name string
function Action:new(name)
    self.name = name
end

function Action:execute()
    Logger:debug('actions.messages.executing', { action = self.name })
    Ferret:action(self.name)
end
