--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic Exploration module
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class CosmicExploration : Object
---@field job Job
---@field mission_list MissionList
CosmicExploration = Object:extend()
function CosmicExploration:new()
    self.job = GetClassJobId()
    self.mission_list = MasterMissionList:filter_by_job(self.job)
end

---@param job Job
function CosmicExploration:set_job(job)
    self.job = job
    self.mission_list = MasterMissionList:filter_by_job(job)
end
