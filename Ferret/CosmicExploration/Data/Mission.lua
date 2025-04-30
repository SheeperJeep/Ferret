--------------------------------------------------------------------------------
--   DESCRIPTION: CosmicExploration Mission
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Mission : Object
---@field id integer
---@field name Translatable
---@field job integer
---@field class string
---@field time_limit number
---@field silver_threshold number
---@field gold_threshold number
---@field has_secondary_job boolean
---@field secondary_job integer|nil
---@field cosmocredit number
---@field lunarcredit number
---@field exp_reward table
---@field has_multiple_recipes boolean
---@field multi_craft_config table
Mission = Object:extend()
Mission.wait_timers = {
    pre_synthesize = 0,
    post_synthesize = 0,
}

Mission.last_crafting_action_threshold = 15

---@param id integer
---@param name Translatable
---@param job Job
---@param class string
function Mission:new(id, name, job, class)
    self.id = id
    self.name = name
    self.job = job
    self.class = class

    self.time_limit = 0
    self.silver_threshold = 0
    self.gold_threshold = 0
    self.has_secondary_job = false
    self.secondary_job = nil
    self.cosmocredit = 0
    self.lunarcredit = 0
    self.exp_reward = {}
    self.has_multiple_recipes = false
    self.multi_craft_config = {}
end

---@param name string
---@return Mission
function Mission:with_de_name(name)
    self.name = self.name:with_de(name)
    return self
end

---@param name string
---@return Mission
function Mission:with_fr_name(name)
    self.name = self.name:with_fr(name)
    return self
end

---@param name string
---@return Mission
function Mission:with_jp_name(name)
    self.name = self.name:with_jp(name)
    return self
end

---@param time_limit integer
---@return Mission
function Mission:with_time_limit(time_limit)
    self.time_limit = time_limit
    return self
end

---@param silver_threshold integer
---@return Mission
function Mission:with_silver_threshold(silver_threshold)
    self.silver_threshold = silver_threshold
    return self
end

---@param gold_threshold integer
---@return Mission
function Mission:with_gold_threshold(gold_threshold)
    self.gold_threshold = gold_threshold
    return self
end

---@return Mission
function Mission:with_has_secondary_job()
    self.has_secondary_job = true
    return self
end

---@param job Job
---@return Mission
function Mission:with_secondary_job(job)
    self.secondary_job = job
    return self:with_has_secondary_job()
end

---@param cosmocredit integer
---@return Mission
function Mission:with_cosmocredit(cosmocredit)
    self.cosmocredit = cosmocredit
    return self
end

---@param lunarcredit integer
---@return Mission
function Mission:with_lunarcredit(lunarcredit)
    self.lunarcredit = lunarcredit
    return self
end

---@param reward table
---@return Mission
function Mission:with_exp_reward(reward)
    table.insert(self.exp_reward, reward)
    return self
end

---@return Mission
function Mission:with_multiple_recipes()
    self.has_multiple_recipes = true
    return self
end

---@param config table
---@return Mission
function Mission:with_multi_craft_config(config)
    self.multi_craft_config = config
    return self
end

function Mission:start()
    WKSMission:wait_until_ready()
    WKSMission:start_mission(self.id)
end

---@return boolean
function Mission:is_complete()
    local current_score, gold_star_requirement = ToDoList:get_stellar_mission_scores()
    if current_score and gold_star_requirement then
        return current_score >= gold_star_requirement
    end

    return false
end

function Mission:wait_for_crafting_ui_or_mission_complete()
    Logger:debug('modules.cosmic_exploration.mission.waiting_for_crafting_ui_or_mission_complete')
    Ferret:wait_until(function()
        return WKSRecipeNotebook:is_ready() or self:is_complete()
    end)
    Ferret:wait(1)
    Logger:debug('modules.cosmic_exploration.mission.crafting_ui_or_mission_complete')
end

---@return boolean, string
function Mission:single_recipe()
    Logger:debug('modules.cosmic_exploration.mission.recipe_count', { count = 1 })
    local timer = Timer()
    timer:start()

    repeat
        if WKSRecipeNotebook:is_ready() then
            if GetItemCount(48233) <= 0 then
                return self:is_complete(), 'Ran out of materials'
            end

            Ferret:wait(Mission.wait_timers.pre_synthesize)
            WKSRecipeNotebook:synthesize()
            Ferret:wait(Mission.wait_timers.post_synthesize)
        end

        if GetCharacterCondition(Conditions.Crafting40) then
            timer:start()
        end

        if timer:seconds() >= Mission.last_crafting_action_threshold then
            return self:is_complete(), 'Too much time passed since last detected crafting action'
        end

        if ToDoList:get_time_remaining() <= 0 then
            return self:is_complete(), 'Ran out of time'
        end

        Ferret:wait(0.5)
    until self:is_complete()

    return self:is_complete(), 'Success'
end

---@return boolean, string
function Mission:multi_recipe()
    Logger:debug('modules.cosmic_exploration.mission.recipe_count', { count = Table:count(self.multi_craft_config) })
    local timer = Timer()
    timer:start()

    repeat
        if GetItemCount(48233) <= 0 then
            return self:is_complete(), 'Ran out of materials'
        end

        for index, count in pairs(self.multi_craft_config) do
            repeat
                if GetCharacterCondition(Conditions.Crafting40) then
                    timer:start()
                end

                if timer:seconds() >= Mission.last_crafting_action_threshold then
                    return self:is_complete(), 'Too much time passed since last detected crafting action'
                end

                if ToDoList:get_time_remaining() <= 0 then
                    return self:is_complete(), 'Ran out of time'
                end

                Ferret:wait(0.5)
            until WKSRecipeNotebook:is_ready() or self:is_complete()

            self:wait_for_crafting_ui_or_mission_complete()
            if not self:is_complete() then
                WKSRecipeNotebook:wait_until_ready()
                Ferret:wait(0.5)
                Logger:debug('modules.cosmic_exploration.mission.recipe_index', { index = index })
                WKSRecipeNotebook:set_index(index)
                for i = 1, count do
                    repeat
                        if GetCharacterCondition(Conditions.Crafting40) then
                            timer:start()
                        end

                        if timer:seconds() >= Mission.last_crafting_action_threshold then
                            return self:is_complete(), 'Too much time passed since last detected crafting action'
                        end

                        if ToDoList:get_time_remaining() <= 0 then
                            return self:is_complete(), 'Ran out of time'
                        end

                        Ferret:wait(0.5)
                    until WKSRecipeNotebook:is_ready() or self:is_complete()

                    self:wait_for_crafting_ui_or_mission_complete()
                    if not self:is_complete() then
                        WKSRecipeNotebook:wait_until_ready()
                        Logger:debug('modules.cosmic_exploration.mission.crafting', { index = i, count = count })
                        WKSRecipeNotebook:set_hq()
                        Ferret:wait(Mission.wait_timers.pre_synthesize)
                        WKSRecipeNotebook:synthesize()
                        Ferret:wait(Mission.wait_timers.post_synthesize)
                    end
                end
            end
        end
    until self:is_complete()

    return self:is_complete(), 'Success'
end

---@return boolean, string
function Mission:handle()
    Logger:debug('modules.cosmic_exploration.mission.starting_mission', { mission = self.name:get() })

    if not self.has_multiple_recipes then
        return self:single_recipe()
    else
        return self:multi_recipe()
    end
end

function Mission:report()
    WKSHud:open_mission_menu()
    WKSMissionInfomation:report()
end

function Mission:abandon()
    WKSHud:open_mission_menu()
    WKSMissionInfomation:abandon()
end

---@return string
function Mission:to_string()
    return string.format(
        '[\n    ID: %s,\n    Name: %s,\n    Job: %s,\n    Class: %s\n]',
        self.id,
        self.name:get(),
        self.job,
        self.class
    )
end
