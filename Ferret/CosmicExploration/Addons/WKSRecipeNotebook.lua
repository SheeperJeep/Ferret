--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic exploration recipe selection addon
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class WKSRecipeNotebook : Addon
local WKSRecipeNotebook = Addon:extend()
function WKSRecipeNotebook:new()
    WKSRecipeNotebook.super.new(self, 'WKSRecipeNotebook')
end

function WKSRecipeNotebook:set_index(index)
    self:wait_until_ready()
    self:callback(true, 0, index)
end

function WKSRecipeNotebook:set_hq()
    self:wait_until_ready()
    self:callback(true, 5)
end

function WKSRecipeNotebook:synthesize()
    self:wait_until_ready()
    repeat
        if self:is_ready() then
            self:callback(true, 6)
        end
        Ferret:wait(0.1)
    until not WKSRecipeNotebook:is_visible()
end

function WKSRecipeNotebook:get_current_recipe_name()
    return self:get_node_text(38)
end

function WKSRecipeNotebook:get_current_craftable_amount()
    return self:get_node_number(24)
end

return WKSRecipeNotebook()
