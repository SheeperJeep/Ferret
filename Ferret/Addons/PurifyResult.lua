--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Aetherial Reduction Result screen
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class PurifyResult : Addon
local PurifyResult = Addon:extend()

function PurifyResult:new()
    PurifyResult.super.new(self, 'PurifyResult')
end

function PurifyResult:auto()
    Ferret:callback(self, true, 0)
end

return PurifyResult()
