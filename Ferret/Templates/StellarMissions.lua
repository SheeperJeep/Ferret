--------------------------------------------------------------------------------
--   DESCRIPTION: Stellar Crafting Mission automator
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Ferret')
require('Ferret/CosmicExploration/CosmicExploration')

MissionOrder = {
    TopPriority = 1, -- Execute missions in the order they are listed
    Random = 2, -- Execute missions in random order
}

StellarMissions = Ferret:extend()
function StellarMissions:new()
    StellarMissions.super.new(self, i18n('templates.stellar_missions.name'))
    self.template_version = Version(2, 6, 0)

    self.mission_list = MissionList()
    self.mission_order = MissionOrder.TopPriority

    self.minimum_acceptable_result = MissionResult.Gold
    self.per_mission_acceptable_result = {}

    self.stop_on_failure = false

    self.cosmic_exploration = CosmicExploration()

    self.wait_timers = {
        pre_open_mission_list = 0,
        post_open_mission_list = 0,
        post_mission_start = 0,
        post_mission_abandon = 0,
    }
end

function StellarMissions:slow_mode()
    self.wait_timers = {
        pre_open_mission_list = 1,
        post_open_mission_list = 1,
        post_mission_start = 1,
        post_mission_abandon = 1,
    }

    Mission.wait_timers.pre_synthesize = 1
    Mission.wait_timers.post_synthesize = 1
    Mission.last_crafting_action_threshold = 20
end

function StellarMissions:create_job_list(callback)
    return self.cosmic_exploration.mission_list:filter(callback)
end

function StellarMissions:create_job_list_by_names(names)
    return self.cosmic_exploration.mission_list:filter_by_names(names)
end

function StellarMissions:create_job_list_by_ids(ids)
    return self.cosmic_exploration.mission_list:filter_by_ids(ids)
end

function StellarMissions:create_job_list_by_name_and_job(names, job)
    return self.cosmic_exploration.mission_list:filter(function(mission)
        return Table:contains(names, mission.name:get()) and mission.job == job
    end)
end


function StellarMissions:get_acceptable_result(mission)
    if self.per_mission_acceptable_result[mission.id] then
        return self.per_mission_acceptable_result[mission.id]
    end

    return self.minimum_acceptable_result
end

function StellarMissions:setup()
    Logger:info(self.name .. ': ' .. self.template_version:to_string())

    PauseYesAlready()

    return true
end

function StellarMissions:loop()
    Addons.WKSHud:wait_until_ready()

    repeat
        Addons.WKSMission:open()
        Ferret:wait(0.2)
    until Addons.WKSMission:is_ready()

    local available_missions = Addons.WKSMission:get_available_missions()
    local overlap = self.mission_list:get_overlap(available_missions)

    if overlap:is_empty() then
        Logger:debug('Selecting mission to abandon')
        local class = Table:random(self.mission_list:get_classes())
        Logger:debug('Abandoning mission of class: ' .. class)

        local mission = available_missions:filter_by_class(class):random()
        if mission == nil then
            Logger:debug('No mission found with class: ' .. class)
            mission = available_missions:random()
        end

        if mission == nil then
            Logger:warn('Could not determine a mission to abandon.')
            Logger:info('Configured missions: ' .. self.mission_list:count())
            Logger:info('Available missions: ' .. available_missions:count())
            self:stop()
            return
        end

        mission:start()
        Addons.WKSRecipeNotebook:wait_until_ready()
        mission:abandon()
        return
    else
        Logger:debug('Selecting mission to run')
        local mission = nil
        if self.mission_order == MissionOrder.TopPriority then
            mission = overlap:first()
        elseif self.mission_order == MissionOrder.Random then
            mission = overlap:random()
        end

        if mission == nil then
            Logger:error('Error getting a mission.')
            self:stop()
            return
        end

        Logger:debug('mission: ' .. mission:to_string())

        mission:start()
        Ferret:wait(self.wait_timers.post_mission_start)
        Addons.WKSRecipeNotebook:wait_until_ready()
        self:emit(Hooks.PRE_CRAFT)

        Addons.WKSHud:open_mission_menu()

        local result, reason = mission:handle()
        if result.tier < self:get_acceptable_result(mission) then
            Logger:warn('Mission failed: ' .. mission:to_string())
            Logger:warn('Reason: ' .. reason)

            if self.stop_on_failure then
                Logger:info('Quiting Ferret ' .. self.version:to_string())
                self:stop()
            end
            return
        end

        Addons.WKSHud:open_mission_menu()
        Character:wait_until_done_crafting()
        Addons.WKSMissionInfomation:wait_until_ready()
        self:repeat_until(function()
            mission:report()
        end, function()
            return not Addons.WKSMissionInfomation:is_visible()
        end)
    end
end

local stellar_missions = StellarMissions()
Ferret = stellar_missions

return stellar_missions
