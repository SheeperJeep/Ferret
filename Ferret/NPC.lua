--------------------------------------------------------------------------------
--   DESCRIPTION: Object representing an ingame NPC, that can be interacted with
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class NPC : Object
---@field name string
NPC = Object:extend()
function NPC:new(name)
    self.name = name
end

---Target the NPC if they are in range
function NPC:target()
    yield('/target "' .. self.name .. '"')
end

---Tries to target the NPC and interact with them
function NPC:interact()
    self:target()
    Ferret:wait(0.2)
    yield('/interact')
end
