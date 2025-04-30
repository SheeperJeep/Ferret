--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for Quest list (Not Journal)
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class ToDoList : Addon
local ToDoList = Addon:extend()
function ToDoList:new()
    ToDoList.super.new(self, '_ToDoList')
end

function ToDoList:get_count()
    return GetNodeListCount(self.key)
end

---@return MissionResult
function ToDoList:get_stellar_mission_scores()
    local silver_patern = Translatable('Current Score: ([%d,]+)%. Silver Star Requirement: ([%d,]+)')
        :with_de('Aktuell: ([%d%.]+) / Silber: ([%d%.]+)')
        :with_fr('Évaluation : ([%d%s]+) / Rang argent : ([%d%s]+)')
        :with_jp('現在の評価値: ([%d,]+) / シルバーグレード条件: ([%d,]+)')

    local gold_pattern = Translatable('Current Score: ([%d,]+)%. Gold Star Requirement: ([%d,]+)')
        :with_de('Aktuell: ([%d%.]+) / Gold: ([%d%.]+)')
        :with_fr('Évaluation : ([%d%s]+) / Rang or : ([%d%s]+)')
        :with_jp('現在の評価値: ([%d,]+) / ゴールドグレード条件: ([%d,]+)')

    for side = 1, 2 do
        for i = 1, self:get_count() do
            local node_text = self:get_node_text(i, side)
            local current, silver = string.match(node_text, silver_patern:get())
            if current and silver then
                return MissionScore(MissionResult.Fail, current, silver)
            end

            local current, gold = string.match(node_text, gold_pattern:get())
            if current and gold then
                if current < gold then
                    return MissionScore(MissionResult.Silver, current, gold)
                end

                return MissionScore(MissionResult.Gold, current, gold)
            end
        end
    end

    return MissionScore(MissionResult.Fail, '0', '0')
end

function ToDoList:get_time_remaining()
    -- @todo check this works dynamically and across localisations
    local timer = self:get_node_text(6, 2)
    local minutes, seconds = string.match(timer, '(%d+):(%d+)')
    if minutes and seconds then
        return tonumber(minutes) * 60 + tonumber(seconds)
    end

    return math.maxinteger
end

return ToDoList()
