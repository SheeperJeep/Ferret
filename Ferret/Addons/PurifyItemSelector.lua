--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the Aetherial Reduction screen
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class PurifyItemSelector : Addon
local PurifyItemSelector = Addon:extend()

function PurifyItemSelector:new()
    PurifyItemSelector.super.new(self, 'PurifyItemSelector')
end

function PurifyItemSelector:click_first()
    Ferret:callback(self, true, 12, 0)
end

function PurifyItemSelector:exit()
    Ferret:callback(self, true, -1)
end

return PurifyItemSelector()
