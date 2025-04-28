--------------------------------------------------------------------------------
--   DESCRIPTION: Job names to ids
--        AUTHOR: Faye (OhKannaDuh)
-- CONSTRIBUTORS:
--------------------------------------------------------------------------------

Jobs = {
    Unknown = -1,
    Carpenter = 8,
    Blacksmith = 9,
    Armorer = 10,
    Goldsmith = 11,
    Leatherworker = 12,
    Weaver = 13,
    Alchemist = 14,
    Culinarian = 15,
    Miner = 16,
    Botanist = 17,
    Fisher = 18,
}

-- @todo Translate these
Jobs.gearset_name_map = {
    [Jobs.Unknown] = 'Unknown',
    [Jobs.Carpenter] = 'Carpenter',
    [Jobs.Blacksmith] = 'Blacksmith',
    [Jobs.Armorer] = 'Armorer',
    [Jobs.Goldsmith] = 'Goldsmith',
    [Jobs.Leatherworker] = 'Leatherworker',
    [Jobs.Weaver] = 'Weaver',
    [Jobs.Alchemist] = 'Alchemist',
    [Jobs.Culinarian] = 'Culinarian',
    [Jobs.Miner] = 'Miner',
    [Jobs.Botanist] = 'Botanist',
    [Jobs.Fisher] = 'Fisher',
}

function Jobs.get_name(job)
    return Jobs.gearset_name_map[job]
end
