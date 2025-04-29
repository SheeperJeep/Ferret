--------------------------------------------------------------------------------
--   DESCRIPTION: A text logger
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class Logger : Object
---@field log_file_directory string A directory path where files should be stored. If this is defined then logs will also be logged in files.
---@field file_only boolean Prevents echoing logs when false
---@field show_debug boolean Allows debug logs to be logged
local Logger = Object:extend()
function Logger:new()
    self.log_file_directory = nil
    self.file_only = false
    self.show_debug = false
end

---Sets log_file_directory, copies the current log to [name].prev.log and prepares [name].log
---@param directory string The path
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

---Logs whatever message is given to its
---@param message string The message to log
function Logger:log(message)
    if self.log_file_directory ~= nil then
        local path = self.log_file_directory .. '/' .. Ferret.name .. '.log'
        IO:open(path, 'a'):write(message .. '\n'):close()
    end

    if not self.file_only then
        yield('/e ' .. message)
    end
end

---Logs the type of the given variable
---@param subject any
function Logger:type(subject)
    if not self.show_debug then
        return
    end

    self:log('[' .. Ferret.name .. '][Type]: ' .. type(subject))
end

---Logs the given table
---@param subject table
function Logger:table(subject)
    self:log('[' .. Ferret.name .. '][Table]: ' .. Table:dump(subject))
end

---Logs under the info level. Checks if given contents is a translation string
---@param contents string Data to log or translation string
---@param args table Arguments for the translation string
function Logger:info(contents, args)
    local translated = nil
    if self:should_translate(contents) then
        translated = i18n(tostring(contents), args)
    end

    self:log('[' .. Ferret.name .. '][Info]: ' .. (translated or contents))
end

---Logs under the debug level. Checks if given contents is a translation string. Logs are only logged when show_debug is true
---@param contents string Data to log or translation string
---@param args? table Arguments for the translation string
function Logger:debug(contents, args)
    if not self.show_debug then
        return
    end

    local translated = nil
    if self:should_translate(contents) then
        translated = i18n(tostring(contents), args)
    end

    self:log('[' .. Ferret.name .. '][Debug]: ' .. (translated or contents))
end

---Logs under the warn level. Checks if given contents is a translation string
---@param contents string Data to log or translation string
---@param args? table Arguments for the translation string
function Logger:warn(contents, args)
    local translated = nil
    if self:should_translate(contents) then
        translated = i18n(tostring(contents), args)
    end

    self:log('[' .. Ferret.name .. '][Warn]: ' .. (translated or contents))
end

---Logs under the error level. Checks if given contents is a translation string
---@param contents string Data to log or translation string
---@param args? table Arguments for the translation string
---@param show_backtrace? boolean Prints the current backtrace if not supplied or true, pass false to prevent this
function Logger:error(contents, args, show_backtrace)
    local translated = nil
    if self:should_translate(contents) then
        translated = i18n(tostring(contents), args)
    end

    self:log('[' .. Ferret.name .. '][Error]: ' .. (translated or contents))

    if show_backtrace or show_backtrace == nil then
        self:log('Backtrace: ' .. debug.traceback())
    end
end

---Checks the given string for escape characters that wouldn't appear in a translation string
---@param key string
---@return boolean
function Logger:should_translate(key)
    return string.find(key, '%', 0, true) == nil
end

return Logger()
