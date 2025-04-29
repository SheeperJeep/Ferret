--------------------------------------------------------------------------------
--   DESCRIPTION: Base Plugin class
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Plugin : Object
Plugin = Object:extend()

---@param name string
---@param key string
function Plugin:new(name, key)
    self.name = name
    self.key = key
end

function Plugin:init()
    Logger:debug('plugin.messages.no_init', { name = self.name })
end
