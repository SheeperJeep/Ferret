--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for Quest list (Not Journal)
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local Synthesis = Addon:extend()
function Synthesis:new()
    Synthesis.super.new(self, 'Synthesis')
end

function Synthesis:quit()
    Ferret:callback(self, true, -1)
end

return Synthesis()
