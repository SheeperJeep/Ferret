---@class Object
---@field extend function
---@field implement function
---@field is function
---@field __tostring function
---@field __call function
---@field super Object
---@field new fun(Object, ...)
Object = require('external/classic')
i18n = require('external/i18n/init')
i18n.setLocale(_language or 'en')
i18n.load(require('Ferret/i18n/en'))
i18n.load(require('Ferret/i18n/de'))
i18n.load(require('Ferret/i18n/fr'))
i18n.load(require('Ferret/i18n/jp'))

-- Mixins
require('Ferret/Mixins/Translation')

-- Data enums and objects
require('Ferret/Data/Translatable')
require('Ferret/Data/Conditions')
require('Ferret/Data/Hooks')
require('Ferret/Data/Jobs')
require('Ferret/Data/Name')
require('Ferret/Data/Objects')
require('Ferret/Data/Status')
require('Ferret/Data/Version')
require('Ferret/Data/Node')

-- Other classes
require('Ferret/Targetable')
require('Ferret/Timer')
require('Ferret/Sandtimer')

-- Base plugin
require('Ferret/Plugins/Plugin')

-- Addons
require('Ferret/Addons/Addons')

-- Actions
require('Ferret/Actions/Actions')

-- Static objects
Character = require('Ferret/Character')
Mount = require('Ferret/Mount')
World = require('Ferret/World')
Gathering = require('Ferret/Gathering')
GatherBuddy = require('Ferret/GatherBuddy')
Pathfinding = require('Ferret/Pathfinding')
SpearfishingHelper = require('Ferret/SpearfishingHelper')
IO = require('Ferret/IO')
Logger = require('Ferret/Logger')
Debug = require('Ferret/Debug')
Table = require('Ferret/Table')
String = require('Ferret/String')

-- Modules
require('Ferret/CosmicExploration/Library')
