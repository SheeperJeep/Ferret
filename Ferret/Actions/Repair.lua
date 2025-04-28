--------------------------------------------------------------------------------
--   DESCRIPTION: Action for opening the repair interface
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local Repair = Action:extend()
function Repair:new()
    Repair.super.new(self, i18n('actions.repair'))
end

return Repair()
