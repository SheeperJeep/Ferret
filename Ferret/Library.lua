Object = require('external/classic')
i18n = require('external/i18n/init')
i18n.load(require('Ferret/i18n/en'))
i18n.load(require('Ferret/i18n/de'))
i18n.load(require('Ferret/i18n/fr'))
i18n.load(require('Ferret/i18n/jp'))

-- Data enums and objects
require('Ferret/Data/Translatable')
require('Ferret/Data/Conditions')
require('Ferret/Data/Hooks')
require('Ferret/Data/Jobs')
require('Ferret/Data/Name')
require('Ferret/Data/Objects')
require('Ferret/Data/Status')
require('Ferret/Data/Version')

-- Other classes
require('Ferret/NPC')
require('Ferret/Timer')

-- Base plugin
require('Ferret/Plugins/Plugin')

-- Addons
require('Ferret/Addons/Addons')

-- Actions
require('Ferret/Actions/Actions')

-- Static objects
Character = require('Ferret/Character')
IO = require('Ferret/IO')
Logger = require('Ferret/Logger')

-- Modules
require('Ferret/CosmicExploration/Library')
