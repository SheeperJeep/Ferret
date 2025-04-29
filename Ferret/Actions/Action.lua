--------------------------------------------------------------------------------
--   DESCRIPTION: Abstract action class
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

Action = Object:extend()
function Action:new(name)
    self.name = name
end

function Action:execute()
    Logger:debug('actions.messages.executing', { action = self.name })
    Ferret:action(self.name)
end
