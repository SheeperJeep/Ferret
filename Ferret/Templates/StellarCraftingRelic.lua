--------------------------------------------------------------------------------
--   DESCRIPTION: Stellar Crafting Relic automator
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Ferret')
require('Ferret/CosmicExploration/CosmicExploration')

StellarCraftingRelic = Ferret:extend()
function StellarCraftingRelic:new()
    StellarCraftingRelic.super.new(self, i18n('templates.stellar_crafting_relic.name'))
    self.template_version = Version(0, 6, 0)

    self.job_order = {
        Jobs.Carpenter,
        Jobs.Blacksmith,
        Jobs.Armorer,
        Jobs.Goldsmith,
        Jobs.Leatherworker,
        Jobs.Weaver,
        Jobs.Alchemist,
        Jobs.Culinarian,
    }

    self.relic_ranks = {
        [Jobs.Carpenter] = 1,
        [Jobs.Blacksmith] = 1,
        [Jobs.Armorer] = 1,
        [Jobs.Goldsmith] = 1,
        [Jobs.Leatherworker] = 1,
        [Jobs.Weaver] = 1,
        [Jobs.Alchemist] = 1,
        [Jobs.Culinarian] = 1,
    }

    self.cosmic_exploration = CosmicExploration()

    self.wait_timers = {
        pre_open_mission_list = 0,
        post_open_mission_list = 0,
        post_mission_start = 0,
        post_mission_abandon = 0,
    }

    self.blacklist = MissionList()

    self.researchingway = Targetable(i18n('npcs.researchingway'))
end

function StellarCraftingRelic:slow_mode()
    self.wait_timers = {
        pre_open_mission_list = 1,
        post_open_mission_list = 1,
        post_mission_start = 1,
        post_mission_abandon = 1,
    }

    Mission.wait_timers.pre_synthesize = 1
    Mission.wait_timers.post_synthesize = 1
    Mission.last_crafting_action_threshold = 10
end

function StellarCraftingRelic:setup()
    Logger:info(self.name .. ': ' .. self.template_version:to_string())

    PauseYesAlready()

    return true
end

function StellarCraftingRelic:loop()
    WKSHud:wait_until_ready()

    WKSHud:open_cosmic_research()
    WKSToolCustomize:wait_until_ready()
    Ferret:wait(1)

    Logger:info('templates.stellar_crafting_relic.checking_relic_ranks')
    local maxed = true
    self.relic_ranks = WKSToolCustomize:get_relic_ranks()
    for _, job in ipairs(self.job_order) do
        local rank = self.relic_ranks[job]
        if rank < 9 then
            maxed = false
            if job ~= GetClassJobId() then
                yield('/gearset change ' .. Jobs.get_name(job))
                self.cosmic_exploration:set_job(job)
                self.blacklist = MissionList()
                Ferret:wait(1)
            end

            break
        end
    end

    Ferret:wait(self.wait_timers.pre_open_mission_list)
    WKSMission:open_basic_missions()
    Ferret:wait(self.wait_timers.post_open_mission_list)
    if maxed then
        Logger:info('templates.stellar_crafting_relic.maxed')
        self:stop()
        return
    end

    Logger:info('templates.stellar_crafting_relic.checking_relic_exp')
    -- Close and open to refresh exp bars
    WKSHud:close_cosmic_research()
    Ferret:wait(1)
    WKSHud:open_cosmic_research()
    WKSToolCustomize:wait_until_ready()
    Ferret:wait(1)

    local is_ready_to_upgrade = true
    local progress = {
        WKSToolCustomize:get_exp_1(),
        WKSToolCustomize:get_exp_2(),
        WKSToolCustomize:get_exp_3(),
        WKSToolCustomize:get_exp_4(),
    }

    for i, exp in ipairs(progress) do
        if Table:count(exp) > 0 then
            if exp.current < exp.required then
                is_ready_to_upgrade = false
            end
        end
    end

    if is_ready_to_upgrade then
        Ferret:wait(2)
        self.researchingway:interact()
        Ferret:wait(1)
        Talk:progress_until_done()
        Ferret:wait(1)
        SelectString:select_index(0)
        Ferret:wait(1)
        SelectIconString:select_index(self.cosmic_exploration.job - 8)
        Ferret:wait(1)
        SelectYesno:yes()
        Talk:wait_until_ready()
        Ferret:wait(1)
        Talk:progress_until_done()
        Ferret:wait(2)

        return
    end

    local mission = WKSMission:get_best_available_mission(self.blacklist)
    if mission == nil then
        Logger:error('templates.stellar_crafting_relic.failed_to_get_mission')
        self:stop()
        return
    end

    Logger:info('templates.stellar_crafting_relic.mission', { mission = mission:to_string() })

    mission:start()

    Ferret:wait(self.wait_timers.post_mission_start)
    WKSRecipeNotebook:wait_until_ready()
    self:emit(Hooks.PRE_CRAFT)

    WKSHud:open_mission_menu()

    if not mission:handle() then
        Logger:error('templates.stellar_crafting_relic.mission_failed', { mission = mission:to_string() })
        Logger:error('templates.stellar_crafting_relic.mission_blacklisting', { mission = mission.name:get() })

        self.blacklist:add(mission)

        if Synthesis:is_visible() then
            Synthesis:quit()
            Ferret:wait(3)
            mission:abandon()
        else
            Ferret:wait(3)
            mission:report()
        end

        return
    end

    Logger:debug('templates.stellar_crafting_relic.mission_complete')

    self:repeat_until(function()
        mission:report()
    end, function()
        return not mission:is_complete()
    end)
end

local ferret = StellarCraftingRelic()
Ferret = ferret

return ferret
