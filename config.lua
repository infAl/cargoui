-------------------------------------------------------------------------------
--	This file contains all of the strings and configurable values for the mod
--	and could be edited for language localisation
--
-------------------------------------------------------------------------------

-- Use disableMod if you want to uninstall.
-- At the moment, if the game engine can't find a script that is attached to an
-- object it doesn't work well.
-- Entities like ships seem to be deleted, players seem to be respawned as a different
-- faction and not 'own' any of their existing ships and stations.
-- Set disableMod to true and leave all the files in place. They will simply
-- load and then terminate
disableMod = false -- [true/false]


-- Script Files
scriptPlayer = "mods/cargoui/playerScript.lua"
scriptInterface = "mods/cargoui/interface.lua"


-- Basic mod info stuff
modIcon = "data/textures/icons/wooden-crate.png"
modName = "Cargo UI"
modVersion = {major=1, minor=3, revision=1}
modDescription="Allows the player to see the full list of items in their ship's cargo hold and highlights any illicit items."


-- Labels and UI elements
dumpAll = "Dump All"
dumpQty = "Dump Quantity"
sizeEa = "Size ea: %s"
baseValue = "Base Value ea: %i"
quantity = "Quantity: %i"
totalSize = "Total Size: %i"
stolen = "Stolen"
illegal = "Illegal"
dangerous = "Dangerous"
suspicious = "Suspicious"
yes = "Yes"
no = "No"


-- Colors for the various item status
colorStolen = ColorRGB(1, 0, 0)
colorIllegal = ColorRGB(1, 0, 0)
colorSuspicious = ColorRGB(0.5, 0.5, 0)
colorDangerous = ColorRGB(1, 1, 0)