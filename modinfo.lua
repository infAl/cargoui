-- Cargo UI

package.path = package.path .. ";data/scripts/mods/?.lua"
require("cargoui/config")

local Mod = {}

-- Info for ModLoader
Mod.info = 
{
	name= modName,
	version= modVersion,
	description=modDescription,
	author="infal",
	website="",
	icon=modIcon,
	dependency =
	{
		["Simple Mod Loader"]={ major=1, minor=0, revision=0 }
	},
	playerScript=scriptPlayer,
	onInitialize=nil,
}

return Mod