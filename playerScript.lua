-------------------------------------------------------------------------------
--	cargo ui/playerScript.lua
--
--	This script is attached to the player entity at log in and registers a
--  callback for when the player changes ship.
--  If the ship is not the drone, attach the /cargo ui/interface.lua script to
--  the ship.
--
-------------------------------------------------------------------------------


-- Include Files
package.path = package.path .. ";data/scripts/mods/?.lua"
require("cargoui/config")

if not disableMod then

-- "Constant" values



-- Avorion default functions
function initialize()
	Player():registerCallback("onShipChanged", "onShipChanged")
end


-- Event handler functions
function onShipChanged(playerIndex, craftIndex)
	if onServer() then
		local player = Player(playerIndex)
		-- Check if the player is in the drone. Drone can't have cargo.
		if Player(playerIndex).craft.type ~= EntityType.Drone then
			local ship = Entity(player.craftIndex)
			ship:addScriptOnce(scriptInterface)
			player:setValue("lastShipIndex", craftIndex)
			--Server():broadcastChatMessage("Cargo UI", 0, "Adding script to ship: %i", craftIndex)
		else
			-- Player has exited a ship into the drone so we want to remove the
			-- interface script from the ship they just exited.
			lastShipIndex = player:getValue("lastShipIndex")
			if lastShipIndex then
				local ship = Entity(lastShipIndex)
				if ship then
					ship:removeScript(scriptInterface)
					--Server():broadcastChatMessage("Cargo UI", 0, "Removing script from ship: %i", lastShipIndex)
				end
			end
			player:setValue("lastShipIndex", nil)
		end
	end		
end

else 
	-- disableMod is true
function initialize() terminate() end
end