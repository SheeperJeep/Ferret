--------------------------------------------------------------------------------
--   DESCRIPTION: Action for opening the Materia Extraction interface
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

local MateriaExtraction = Action:extend()
function MateriaExtraction:new()
    MateriaExtraction.super.new(self, i18n('actions.materia_extaction'))
end

return MateriaExtraction()
