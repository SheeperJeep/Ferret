local IO = Object:extend()

function IO:open(path, mode)
    return io.open(path, mode)
end

function IO:exists(path)
    local file = io.open(path, 'r')
    return file ~= nil and self:close(file)
end

return IO()
