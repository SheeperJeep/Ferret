--------------------------------------------------------------------------------
--   DESCRIPTION: Plugin that extracts materia before a loop
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class ExtractMateria : Plugin
ExtractMateria = Plugin:extend()
function ExtractMateria:new()
    ExtractMateria.super.new(self, 'Extract Materia', 'extract_materia')
end

function ExtractMateria:init()
    Ferret:subscribe(Hooks.PRE_LOOP, function(context)
        Logger:debug('plugins.extract_materia.check')

        if not CanExtractMateria() then
            Logger:debug('plugins.extract_materia.not_needed')
            return
        end

        if not Materialize:is_visible() then
            Materialize:open()
            Materialize:wait_until_ready()
        end

        Logger:debug('plugins.extract_materia.extracting')

        while CanExtractMateria(100) do
            if Materialize:is_visible() then
                Ferret:repeat_until(function()
                    Materialize:click_first_slot()
                end, function()
                    return MaterializeDialog:is_visible()
                end)

                Ferret:repeat_until(function()
                    MaterializeDialog:yes()
                end, function()
                    return not MaterializeDialog:is_visible()
                end)
            end

            Ferret:wait_until(function()
                return not GetCharacterCondition(Conditions.Occupied39)
            end)
        end

        Materialize:close()
        Logger:debug('plugins.extract_materia.done')
    end)
end

Ferret:add_plugin(ExtractMateria())
