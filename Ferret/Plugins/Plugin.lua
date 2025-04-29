Plugin = Object:extend()

function Plugin:new(name, key)
    self.name = name
    self.key = key
end

function Plugin:init()
    Logger:debug('plugin.messages.no_init', { name = self.name })
end
