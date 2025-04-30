--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for Quest list (Not Journal)
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Synthesis : Addon
local Synthesis = Addon:extend()
function Synthesis:new()
    Synthesis.super.new(self, 'Synthesis')
end

function Synthesis:quit()
    self:callback(true, -1)
end

return Synthesis()
