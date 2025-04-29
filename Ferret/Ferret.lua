--------------------------------------------------------------------------------
--   DESCRIPTION: Main library class
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

require('Ferret/Library')

Ferret = Object:extend()
function Ferret:new(name)
    self.name = name
    self.run = true
    self.language = 'en'
    self.plugins = {}
    self.hook_subscriptions = {}
    self.timer = Timer()
end

function Ferret:init()
    self.version = Version(0, 5, 8)
end

function Ferret:add_plugin(plugin)
    Logger:debug('Adding plugin: ' .. plugin.name)
    plugin:init(self)
    self.plugins[plugin.key] = plugin
end

function Ferret:wait(interval)
    yield('/wait ' .. interval)
end

function Ferret:repeat_until(action, condition, delay, max)
    local delay = delay or 0.5
    local elapsed = 0

    local last_return = nil

    repeat
        last_return = action()
        self:wait(delay)
        elapsed = elapsed + delay
    until condition() or (max ~= nil and max > 0 and elapsed >= max)

    return last_return
end

function Ferret:wait_until(condition, delay, max)
    local delay = delay or 0.5
    local elapsed = 0

    if condition() then
        return
    end

    repeat
        self:wait(delay)
        elapsed = elapsed + delay
    until condition() or (max ~= nil and max > 0 and elapsed >= max)
end

function Ferret:stop()
    Logger:debug('ferret.stopping')
    self.run = false
end

function Ferret:setup()
    Logger:warn('ferret.no_setup')
end

function Ferret:loop()
    Logger:warn('ferret.no_loop')
    self:stop()
end

function Ferret:start()
    self.timer:start()
    Logger:info('Ferret version: ' .. self.version:to_string())
    Logger:debug('ferret.running_setup')
    if not self:setup() then
        Logger:error('ferret.setup_error')
        return
    end

    Logger:debug('ferret.starting_loop')
    while self.run do
        self:emit(Hooks.PRE_LOOP)
        self:loop()
        self:emit(Hooks.POST_LOOP)
    end
    Logger:debug('Done')
end

function Ferret:subscribe(hook, callback)
    Logger:debug('ferret.hook_subscription', { hook = hook })
    if not self.hook_subscriptions[hook] then
        self.hook_subscriptions[hook] = {}
    end

    table.insert(self.hook_subscriptions[hook], callback)
end

function Ferret:emit(event, context)
    Logger:debug('ferret.emit_event', { event = event })
    if not self.hook_subscriptions[event] then
        return
    end

    for _, callback in pairs(self.hook_subscriptions[event]) do
        callback(self, context)
    end
end

function Ferret:action(name)
    yield('/ac "' .. name .. '"')
end

function Ferret:callback(addon, update_visiblity, ...)
    local command = '/callback ' .. addon.key
    if update_visiblity then
        command = command .. ' true'
    else
        command = command .. ' false'
    end
    for k, v in ipairs({ ... }) do
        command = command .. ' ' .. v
    end

    Logger:debug('ferret.callback', { command = command })
    yield(command)
end

-- Helpers
function Ferret:get_table_length(subject)
    local count = 0

    for _ in pairs(subject) do
        count = count + 1
    end

    return count
end

function Ferret:table_contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function Ferret:table_random(subject)
    local keys = {}
    for key, _ in pairs(subject) do
        table.insert(keys, key)
    end

    local key = keys[math.random(1, #keys)]
    return subject[key]
end

function Ferret:table_first(subject)
    for _, value in pairs(subject) do
        return value
    end

    return nil
end

function Ferret:table_dump(subject)
    if type(subject) == 'table' then
        local s = '{ '
        for k, v in pairs(subject) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. self:table_dump(v) .. ','
        end
        return s .. '} '
    end

    return tostring(subject)
end

function Ferret:string_starts_with(subject, prefix)
    return string.sub(subject, 1, string.len(prefix)) == prefix
end

function Ferret:parse_number(str)
    return tonumber((str:gsub(',', ''):gsub('%.', ''):gsub(' ', '')))
end
