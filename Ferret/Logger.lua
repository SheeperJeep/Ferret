--------------------------------------------------------------------------------
--   DESCRIPTION: A text logger
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local Logger = Object:extend()
function Logger:new()
    self.log_file_directory = nil
    self.show_debug = false

    -- self.file = IO:open('ferret.log', 'a')
    -- self.file:write('Test')
end

function Logger:set_log_file_directory(directory)
    self.log_file_directory = directory
    local path = self.log_file_directory .. '/' .. Ferret.name .. '.log'
    local prev_path = path:gsub('%.log', '.prev.log')

    local file = IO:open(path)

    if file ~= nil then
        file:close()
        file = IO:open(path, 'r')
        IO:open(prev_path, 'w'):write(file:read('*all')):close()
    end

    if file then
        file:close()
    end

    IO:open(path, 'w'):write(''):close()
end

function Logger:log(message)
    if self.log_file_directory ~= nil then
        local path = self.log_file_directory .. '/' .. Ferret.name .. '.log'
        IO:open(path, 'a'):write(message .. '\n'):close()
    end

    yield('/e ' .. message)
end

function Logger:type(subject)
    if not self.show_debug then
        return
    end

    self:log('[' .. Ferret.name .. '][Type]: ' .. type(subject))
end

function Logger:table(subject)
    self:log('[' .. Ferret.name .. '][Table]: ' .. Ferret:table_dump(subject))
end

function Logger:info(contents, args)
    local translated = i18n(contents, args)

    self:log('[' .. Ferret.name .. '][Info]: ' .. (translated or contents))
end

function Logger:debug(contents, args)
    if not self.show_debug then
        return
    end
    local translated = i18n(contents, args)

    self:log('[' .. Ferret.name .. '][Debug]: ' .. (translated or contents))
end

function Logger:warn(contents, args)
    local translated = i18n(contents, args)

    self:log('[' .. Ferret.name .. '][Warn]: ' .. (translated or contents))
end

function Logger:error(contents, args)
    local translated = i18n(contents, args)

    self:log('[' .. Ferret.name .. '][Error]: ' .. (translated or contents))
    self:log('Backtrace: ' .. debug.traceback())
end

return Logger()
