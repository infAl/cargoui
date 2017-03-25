-------------------------------------------------------------------------------
--	This file contains all of the strings and configurable values for the mod
--	and could be edited for language localisation
--
-------------------------------------------------------------------------------

local t = {}

-- Use disableMod if you want to uninstall.
-- At the moment, if the game engine can't find a script that is attached to an
-- object it doesn't work well.
-- Entities like ships seem to be deleted, players seem to be respawned as a different
-- faction and not 'own' any of their existing ships and stations.
-- Set disableMod to true and leave all the files in place. They will simply
-- load and then terminate
t.disableMod = false -- [true/false]


-- Script Files
t.scriptInterface = "mods/cargoui/interface.lua"


-- Basic mod info stuff
t.modIcon = "data/textures/icons/wooden-crate.png"
t.modName = "Cargo UI"
t.modVersion = {major=1, minor=3, revision=2}
t.modDescription="Allows the player to see the full list of items in their ship's cargo hold and highlights any illicit items."


-- Labels and UI elements
t.dumpAll = "Dump All"
t.dumpQty = "Dump Quantity"
t.sizeEa = "Size ea: %s"
t.baseValue = "Base Value ea: %i"
t.quantity = "Quantity: %i"
t.totalSize = "Total Size: %i"
t.stolen = "Stolen"
t.illegal = "Illegal"
t.dangerous = "Dangerous"
t.suspicious = "Suspicious"
t.yes = "Yes"
t.no = "No"


-- Colors for the various item status
t.colorStolen = ColorRGB(1, 0, 0)
t.colorIllegal = ColorRGB(1, 0, 0)
t.colorSuspicious = ColorRGB(0.5, 0.5, 0)
t.colorDangerous = ColorRGB(1, 1, 0)

return t