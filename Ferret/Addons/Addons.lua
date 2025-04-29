--------------------------------------------------------------------------------
--   DESCRIPTION: Addons list
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

require('Ferret/Addons/Addon')

Materialize = require('Ferret/Addons/Materialize')
MaterializeDialog = require('Ferret/Addons/MaterializeDialog')
SelectIconString = require('Ferret/Addons/SelectIconString')
SelectString = require('Ferret/Addons/SelectString')
SelectYesno = require('Ferret/Addons/SelectYesno')
Talk = require('Ferret/Addons/Talk')
ToDoList = require('Ferret/Addons/ToDoList')
Synthesis = require('Ferret/Addons/Synthesis')

-- @todo add the above into here
Addons = {
    Gathering = require('Ferret/Addons/GatheringAddon'),
    GatheringMasterpiece = require('Ferret/Addons/GatheringMasterpiece'),
    PurifyAutoDialog = require('Ferret/Addons/PurifyAutoDialog'),
    PurifyItemSelector = require('Ferret/Addons/PurifyItemSelector'),
    PurifyResult = require('Ferret/Addons/PurifyResult'),
    SpearFishing = require('Ferret/Addons/SpearFishing'),
}
