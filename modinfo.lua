-- Cargo UI

package.path = package.path .. ";data/scripts/mods/?.lua"
local Config = require("cargoui/config")

local Mod = {}

-- Info for ModLoader
Mod.info = 
{
	name = Config.modName,
	version = Config.modVersion,
	description = Config.modDescription,
	author = "infal",
	website = "",
	icon = modIcon,
	dependency =
	{
		["Simple Mod Loader"]={ major=1, minor=2, revision=0 }
	},
	playerScript=nil,
	onInitialize=nil,
}

Mod.onInitialize = function()
	-- This is all the code needed to have a script attach to the player ship
	-- any time they enter a ship.
	-- The function is in modloader/lib/registerPlayerShipScript.lua and has
	-- info on what the parameters are
	registerPlayerShipScript(Config.scriptInterface, true, false, false)
end

return Mod