-------------------------------------------------------------------------------
--	cargoui/interface.lua
--
--	This script is attached to the player ship and provides a UI for seeing
--	the ship's full cargo.
--
-------------------------------------------------------------------------------

-- Include Files
package.path = package.path .. ";data/scripts/mods/?.lua"
local Config = require("cargoui/config")

if not Config.disableMod then

package.path = package.path .. ";data/scripts/lib/?.lua"
require ("utility")
require ("goods")

-- Local variables
local cargoUI = nil
local cargoList = nil
local infoPanel = {}
local cargoItemHeading = nil
local cargoListLastSelectedIndex = 0

function getIcon(seed, rarity)
    return Config.modIcon
end

function interactionPossible(player)
    return true, ""
end

function initUI()

    local res = getResolution()
    local size = vec2(1000, 650)

    local menu = ScriptUI()
    cargoUI = menu:createWindow(Rect(res * 0.5 - size * 0.5, res * 0.5 + size * 0.5))

    cargoUI.caption = Config.modName
    cargoUI.showCloseButton = 1
    cargoUI.moveable = 1
    menu:registerWindow(cargoUI, Config.modName);
	
	local pos = Rect(10, 10, 270, size.y-10)
	cargoList = cargoUI:createListBox(pos)
	cargoList.fontSize = 14
	
	infoPanel.container = cargoUI:createContainer(Rect(300, 10, 750, 640))
	
	infoPanel.heading = infoPanel.container:createLabel(vec2(0, 20), "", 24)
	
	infoPanel.icon = infoPanel.container:createPicture(Rect(520, 20, 680, 160), "")
	infoPanel.icon.flipped = true
	infoPanel.icon.isIcon = true
	
	infoPanel.description = infoPanel.container:createLabel(vec2(0, 100), "", 20)
	
	infoPanel.size = infoPanel.container:createLabel(vec2(0, 150), "", 16)
	infoPanel.stolen = infoPanel.container:createLabel(vec2(300, 150), "", 16)
	
	infoPanel.value = infoPanel.container:createLabel(vec2(0, 180), "", 16)
	infoPanel.illegal = infoPanel.container:createLabel(vec2(300, 180), "", 16)
	
	infoPanel.quantity = infoPanel.container:createLabel(vec2(0, 210), "", 16)
	infoPanel.dangerous = infoPanel.container:createLabel(vec2(300, 210), "", 16)
	
	infoPanel.totalSize = infoPanel.container:createLabel(vec2(0, 240), "", 16)
	infoPanel.suspicious = infoPanel.container:createLabel(vec2(300, 240), "", 16)
	
	infoPanel.dumpAll = infoPanel.container:createButton(Rect(0, 300, 180, 340), Config.dumpAll, "onDumpAllButtonPressed")
	
	infoPanel.dumpQty = infoPanel.container:createButton(Rect(0, 350, 180, 390), Config.dumpQty, "onDumpQtyButtonPressed")
	
	infoPanel.dumpQtyValue = infoPanel.container:createTextBox(Rect(190, 350, 230, 390), "onDumpQtyValueChanged")
	
	infoPanel.container:hide()
	
	local vers = Config.modName .. string.format(" v%i.%i.%i", Config.modVersion.major, Config.modVersion.minor, Config.modVersion.revision)
	cargoUI:createLabel(vec2(size.x-150, size.y-20), vers, 12)
end

function onShowWindow()
    --Refresh the data
	local ship = Entity()
	local sortedList = {}
	
	cargoList:clear()
	cargoListLastSelectedIndex = 0
	infoPanel.dumpQtyValue.text = "0"

	-- sanity check. make sure the ship object is valid
	if ship then
	
		--check the ship has a cargo hold
		if ship:hasComponent(ComponentType.CargoBay) then
		
			--get a list of cargo in the ship's hold and sort the list alphabetically
			for good, amount in pairs(ship:getCargos()) do
				table.insert(sortedList, good)
			end
			local sort_func = function(a, b)
				return a.name < b.name
			end
			table.sort(sortedList, sort_func)
		
			--loop through the sorted cargo list
			for _, good in pairs(sortedList) do
			
				--add item to the list
				cargoList:addEntry(good.name)
				
				if good.dangerous then
					cargoList:setEntry(cargoList.size-1, string.format("%s %s", Config.dangerous, good.name), false, false, Config.colorDangerous)
				end
				if good.suspicious then 
					cargoList:setEntry(cargoList.size-1, string.format("%s %s", Config.suspicious, good.name), false, false, Config.colorSuspicious)
				end
				if good.illegal then
					cargoList:setEntry(cargoList.size-1, string.format("%s %s", Config.illegal, good.name), false, false, Config.colorIllegal)
				end
				if good.stolen then
					cargoList:setEntry(cargoList.size-1, string.format("%s %s", Config.stolen, good.name), false, false, Config.colorStolen)
				end
			end
			cargoListLastSelectedIndex = cargoList.selected
		end	
	end
	infoPanel.container:hide()
end

function dumpCargo(good, amount)
    if onClient() then
        invokeServerFunction("dumpCargo", good, amount)
        return
    end

    local ship = Entity()

	Sector():dropCargo(ship.translationf, Faction(callingPlayer), Faction(ship.factionIndex), good, ship.factionIndex, amount)
	ship:removeCargo(good, amount)
	invokeClientFunction(Player(callingPlayer), "onShowWindow")
	invokeClientFunction(Player(callingPlayer), "updateUI")
end

function onDumpAllButtonPressed()

	local selectedGood, selectedGoodAmount = findGoodInCargo(cargoList:getEntry(cargoList.selected), Entity())
	if selectedGood == nil then return end

    dumpCargo(selectedGood, selectedGoodAmount)
end

function onDumpQtyButtonPressed()
	local quantity = tonumber(infoPanel.dumpQtyValue.text) or 0
	if quantity < 1 then return end
	
	local selectedGood, selectedGoodAmount = findGoodInCargo(cargoList:getEntry(cargoList.selected), Entity())
	if selectedGood == nil then return end

    dumpCargo(selectedGood, math.min(selectedGoodAmount, quantity))
	infoPanel.dumpQtyValue.text = "0"
end

function onDumpQtyValueChanged()
end

function updateUI()
	if cargoListLastSelectedIndex == cargoList.selected then return end
	
	if cargoList.selected < 0 then
		infoPanel.container:hide()
		cargoListLastSelectedIndex = -1
		return
	end
	
	--If the selected index has changed we need to update the info panel	
	local selectedGood, selectedGoodAmount = findGoodInCargo(cargoList:getEntry(cargoList.selected), Entity())
	if selectedGood == nil then return end
	
	infoPanel.heading.caption = selectedGood.name
	
	infoPanel.icon.picture = selectedGood.icon
	infoPanel.icon.color = ColorARGB(0.5, 1, 1, 1)
	
	infoPanel.description.caption = selectedGood.description
	infoPanel.size.caption = string.format(Config.sizeEa, selectedGood.size)
	infoPanel.value.caption = string.format(Config.baseValue, selectedGood.price)
	infoPanel.quantity.caption = string.format(Config.quantity, selectedGoodAmount)
	infoPanel.totalSize.caption = string.format(Config.totalSize, selectedGood.size * selectedGoodAmount)
	
	if selectedGood.stolen then
		infoPanel.stolen.caption = Config.stolen .. ": " .. Config.yes
	else
		infoPanel.stolen.caption = Config.stolen .. ": " .. Config.no
	end
		
	if selectedGood.illegal then
		infoPanel.illegal.caption = Config.illegal .. ": " .. Config.yes
	else
		infoPanel.illegal.caption = Config.illegal .. ": " .. Config.no
	end
		
	if selectedGood.dangerous then
		infoPanel.dangerous.caption = Config.dangerous .. ": " .. Config.yes
	else
		infoPanel.dangerous.caption = Config.dangerous .. ": " .. Config.no
	end
		
	if selectedGood.suspicious then
		infoPanel.suspicious.caption = Config.suspicious .. ": " .. Config.yes
	else
		infoPanel.suspicious.caption = Config.suspicious .. ": " .. Config.no
	end
	
	infoPanel.container:show()

	--now set the variable so we're not updating unnecessarily
	cargoListLastSelectedIndex = cargoList.selected

end

function findGoodInCargo(name, ship)

	local isStolen = false
	local isIllegal = false
	local isDangerous = false
	local isSuspicious = false
	
	local tmpName = name
	
	if string.match(name, stolen) then
		tmpName = string.sub(tmpName, 8)
		isStolen = true
	end
	if string.match(name, illegal) then
		tmpName = string.sub(tmpName, 9)
		isIllegal = true
	end
	if string.match(name, suspicious) then
		tmpName = string.sub(tmpName, 12)
		isSuspicious = true
	end
	if string.match(name, dangerous) then
		tmpName = string.sub(tmpName, 11)
		isDangerous = true
	end
	for good, amount in pairs( ship:findCargos(tmpName)) do
		if isIllegal == good.illegal and
			isSuspicious == good.suspicious and
			isDangerous == good.dangerous then
			
			return good, amount
		end
		
		-- Handle stolen seperately because goods
		-- can be stolen and dangerous etc
		if isStolen == good.stolen then
			return good, amount
		end
	end
	return nil, 0
end

else 
	-- disableMod is true
function initialize() terminate() end
end















