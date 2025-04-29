--------------------------------------------------------------------------------
--   DESCRIPTION: Abstract addon class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Addon : Object
---@field key string
Addon = Object:extend()

---@param key string
function Addon:new(key)
    self.key = key
end

---@return boolean
function Addon:is_ready()
    return IsAddonReady(self.key)
end

function Addon:wait_until_not_ready()
    -- Logger:debug('addons.messages.wait_until_ready', { addon = self.key })
    Ferret:wait_until(function()
        return not self:is_ready()
    end)
    -- Logger:debug('addons.messages.ready', { addon = self.key })
end

function Addon:wait_until_ready()
    Logger:debug('addons.messages.wait_until_ready', { addon = self.key })
    Ferret:wait_until(function()
        return self:is_ready()
    end)
    Logger:debug('addons.messages.ready', { addon = self.key })
end

---@return boolean
function Addon:is_visible()
    return IsAddonVisible(self.key)
end

function Addon:wait_until_visible()
    Logger:debug('addons.messages.wait_until_visible', { addon = self.key })
    Ferret:wait_until(function()
        return self:is_visible()
    end)
    Logger:debug('addons.messages.visible', { addon = self.key })
end

---@param ... integer
---@return string
function Addon:get_node_text(...)
    Ferret:wait(0.0167)
    return GetNodeText(self.key, ...)
end

---@param ... integer
---@return integer
function Addon:get_node_number(...)
    return String:parse_number(self:get_node_text(...))
end

---@param ... integer
---@return boolean
function Addon:is_node_visible(...)
    Ferret:wait(0.0167)
    return IsNodeVisible(self.key, ...)
end
