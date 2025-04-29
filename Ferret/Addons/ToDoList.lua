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

function ToDoList:get_stellar_mission_scores()
    local pattern = Translatable('Current Score: ([%d,]+)%. Gold Star Requirement: ([%d,]+)')
        :with_de('Aktuell: ([%d%.]+) / Gold: ([%d%.]+)')
        :with_fr('Évaluation : ([%d%s]+) / Rang or : ([%d%s]+)')
        :with_jp('現在の評価値: ([%d,]+) / ゴールドグレード条件: ([%d,]+)')

    for side = 1, 2 do
        for i = 1, self:get_count() do
            local node_text = GetNodeText(self.key, i, side)
            local current_score, gold_star_requirement = string.match(node_text, pattern:get())

            if current_score and gold_star_requirement then
                return String:parse_number(current_score), String:parse_number(gold_star_requirement)
            end
        end
    end

    return nil, nil
end

function ToDoList:get_time_remaining()
    -- @todo check this works dynamically and across localisations
    local a = GetNodeText('_ToDoList', 6, 2)
    local minutes, seconds = string.match(a, '(%d+):(%d+)')
    if minutes and seconds then
        return tonumber(minutes) * 60 + tonumber(seconds)
    end

    return math.maxinteger
end

return ToDoList()
