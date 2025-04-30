--------------------------------------------------------------------------------
--   DESCRIPTION: Mission result, fail, bronze, silver, gold etc.
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@alias MissionResult integer
MissionResult = {
    Fail = 1,
    Silver = 2,
    Gold = 3,
}

function MissionResult.to_string(value)
    local map = {
        [MissionResult.Fail] = 'Fail',
        [MissionResult.Silver] = 'Silver',
        [MissionResult.Gold] = 'Gold',
    }

    return map[value] or 'Unknown'
end
