--------------------------------------------------------------------------------
--   DESCRIPTION: A timer, for tracking how much time has elapsed
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

Timer = Object:extend()
function Timer:new()
    self.startTime = nil
end

function Timer:start()
    self.startTime = os.time()
end

function Timer:seconds()
    if self.startTime == nil then
        return 0
    end

    return os.difftime(os.time(), self.startTime)
end
