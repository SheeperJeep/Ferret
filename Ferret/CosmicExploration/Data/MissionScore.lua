--------------------------------------------------------------------------------
--   DESCRIPTION: Represetnts mission score current/silver/gold
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class MissionScore : Object
---@field tier MissionResult
---@field current integer
---@field next integer
MissionScore = Object:extend()
---@param tier MissionResult
---@param current string
---@param next string
function MissionScore:new(tier, current, next)
    self.tier = tier
    self.current = String:parse_number(current)
    self.next = String:parse_number(next)
end

function MissionScore:to_string()
    return string.format('Tier: %s, Current: %d, Next: %d', MissionResult.to_string(self.tier), self.current, self.next)
end
