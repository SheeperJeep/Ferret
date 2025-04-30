--------------------------------------------------------------------------------
--   DESCRIPTION: Spearfishing
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Ferret')

---@class Spearfishing : Ferret
---@field node Targetable
---@field agpreset string|nil
---@field fish string|nil
---@field starting_node Node|nil
Spearfishing = Ferret:extend()
function Spearfishing:new()
    Spearfishing.super.new(self, i18n('templates.spearfishing.name'))
    self.template_version = Version(0, 1, 0)

    self.node = Targetable(i18n('nodes.teeming_waters'))
    self.agpreset = nil
    self.fish = nil
    self.starting_node = nil
end

function Spearfishing:setup()
    Logger:info(self.name .. ': ' .. self.template_version:to_string())

    Character:wait_until_available()
    if self.agpreset ~= nil then
        yield('/agpreset ' .. self.agpreset)
    end

    if self.fish ~= nil then
        GatherBuddy:gather_fish(self.fish)
    end

    Mount:mount()

    local first = self.starting_node
    if first == nil then
        first = Pathfinding:next()
        Pathfinding.index = 0
    end

    Pathfinding:fly_to(first)
    Pathfinding:wait_until_at_node(first)

    return true
end

function Spearfishing:loop()
    local node = Pathfinding:next()
    if node == nil then
        Logger:warn_t('templates.spearfishing.no_node')
        self:stop()
        return
    end

    if not Mount:is_mounted() then
        Mount:mount()
    end

    Pathfinding:fly_to(node)

    Character:wait_for_target(self.node)

    Pathfinding:fly_to(Character:get_target_position())

    Addons.SpearFishing:wait_until_ready()
    Ferret:wait(1)
    Addons.SpearFishing:wait_until_not_ready()

    Pathfinding:stop()
    Pathfinding:wait_to_stop_moving()
    Ferret:wait(3)
end

local ferret = Spearfishing()
Ferret = ferret

return ferret
