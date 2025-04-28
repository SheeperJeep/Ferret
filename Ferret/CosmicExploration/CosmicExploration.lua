CosmicExploration = Object:extend()
function CosmicExploration:new()
    self.job = GetClassJobId()
    self.mission_list = MasterMissionList:filter_by_job(self.job)
end

function CosmicExploration:set_job(job)
    self.job = job
    self.mission_list = MasterMissionList:filter_by_job(job)
end
