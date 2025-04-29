--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic exploration mission list
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class WKSMission : Addon
local WKSMission = Addon:extend()
function WKSMission:new()
    WKSMission.super.new(self, 'WKSMission')
end

function WKSMission:start_mission(id)
    self:wait_until_ready()

    repeat
        if self:is_ready() then
            Ferret:callback(self, true, 13, id)
        end
        Ferret:wait(0.1)
    until SelectYesno:is_visible()

    repeat
        if SelectYesno:is_ready() then
            SelectYesno:yes()
        end
        Ferret:wait(0.1)
    until not self:is_ready()
end

function WKSMission:open()
    Logger:debug('Opening mission ui')
    WKSHud:open_mission_menu()
    self:wait_until_ready()
    Ferret:wait(1)
end

function WKSMission:open_basic_missions()
    self:open()
    Logger:debug('modules.cosmic_exploration.wks_mission.open_basic')
    Ferret:callback(self, true, 15, 0)
end

function WKSMission:open_critical_missions()
    self:open()
    Logger:debug('modules.cosmic_exploration.wks_mission.open_critical')
    Ferret:callback(self, true, 15, 1)
end

function WKSMission:open_provisional_missions()
    self:open()
    Logger:debug('modules.cosmic_exploration.wks_mission.open_provisional')
    Ferret:callback(self, true, 15, 2)
end

function WKSMission:get_mission_name_by_index(index)
    return self:get_node_text(89, index, 8)
end

function WKSMission:get_available_missions()
    Logger:debug('modules.cosmic_exploration.wks_mission.getting_missions')

    local missions = MissionList()
    local names = {}

    for tab = 0, 2 do
        Ferret:callback(self, true, 15, tab)
        Ferret:wait(0.5)

        for index = 2, 24 do
            local mission_name = self:get_mission_name_by_index(index):gsub(' ', '')
            if mission_name == '' or Table:contains(names, mission_name) then
                break
            end

            Logger:debug('modules.cosmic_exploration.wks_mission.mission_found', { mission = mission_name })
            table.insert(names, mission_name)

            local mission = Ferret.cosmic_exploration.mission_list:find_by_name(mission_name)
            if mission ~= nil then
                missions:add(mission)
            end
        end
    end

    return missions
end

function WKSMission:get_best_available_mission(blacklist)
    -- Function to select the best mission based on urgency-weighted progress
    local function select_best_mission(progress, rewards)
        local urgencies = {}

        -- Step 1: Calculate urgency for each bar
        for i, bar in ipairs(progress) do
            local current, max = bar.current, bar.required
            if max and max > 0 then
                urgencies[i] = 1 - (current / max)
            else
                urgencies[i] = 0
            end
        end

        -- Step 2: Score each mission
        local best_score = -math.huge
        local best_index = -1

        for i, mission in pairs(rewards) do
            local score = 0
            for bar_index, progress in pairs(mission) do
                if urgencies[bar_index] then
                    score = score + urgencies[bar_index] * progress
                end
            end

            if score > best_score then
                best_score = score
                best_index = i
            end
        end

        return best_index
    end

    WKSHud:close_cosmic_research()
    Ferret:wait(1)

    WKSHud:open_cosmic_research()
    WKSHud:open_mission_menu()
    Ferret:wait(1)

    local progress = {
        WKSToolCustomize:get_exp_1(),
        WKSToolCustomize:get_exp_2(),
        WKSToolCustomize:get_exp_3(),
        WKSToolCustomize:get_exp_4(),
    }

    local rewards = {}
    local missions = self:get_available_missions()
    for index, mission in pairs(missions.missions) do
        if not blacklist:has_id(mission.id) then
            Logger:info('modules.cosmic_exploration.wks_mission.not_blacklisted', { mission = mission.name:get() })
            local r = {}
            for _, reward in pairs(mission.exp_reward) do
                r[reward.tier] = reward.amount
            end

            rewards[index] = r
        else
            Logger:info('modules.cosmic_exploration.wks_mission.blacklisted', { mission = mission.name:get() })
        end
    end

    return missions.missions[select_best_mission(progress, rewards)]
end

return WKSMission()
