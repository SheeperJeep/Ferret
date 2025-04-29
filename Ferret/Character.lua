--------------------------------------------------------------------------------
--   DESCRIPTION: Character object
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Character : Object
local Character = Object:extend()

--- Wait in 0.1 second intervals until the character is not crafting and not
--- preparing to craft
function Character:wait_until_done_crafting()
    Ferret:wait_until(function()
        return not GetCharacterCondition(Conditions.Crafting40)
            and not GetCharacterCondition(Conditions.PreparingToCraft)
    end, 0.1)
end

return Character()
