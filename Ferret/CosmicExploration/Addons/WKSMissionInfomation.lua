--------------------------------------------------------------------------------
--   DESCRIPTION: Cosmic exploration mission report window
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class WKSMissionInfomation : Addon, Translation
local WKSMissionInfomation = Addon:extend()
WKSMissionInfomation:implement(Translation)

function WKSMissionInfomation:new()
    WKSMissionInfomation.super.new(self, 'WKSMissionInfomation')
    self.ready_max = 5
    self.visible_max = 5

    self.translation_path = 'modules.cosmic_exploration.wks_mission_information'
end

function WKSMissionInfomation:report()
    self:log_debug('report')
    Debug:log_previous_call()

    self:callback(true, 11)
end

function WKSMissionInfomation:abandon()
    repeat
        if self:is_ready() then
            self:callback(true, 12)
        end
        Ferret:wait(0.1)
    until Addons.SelectYesno:is_visible()
    repeat
        if Addons.SelectYesno:is_ready() then
            Addons.SelectYesno:yes()
        end
        Ferret:wait(0.1)
    until not WKSMissionInfomation:is_visible()
end

return WKSMissionInfomation()
