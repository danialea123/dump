local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)

	ESX.TriggerServerCallback('esx_blackmarket:requestDBItems', function(ShopItems)
		for k,v in pairs(ShopItems) do
			if Config.Zones[k] ~= nil then
				Config.Zones[k].Items = v
			end
		end
	end)
end)

function OpenShopMenu(zone)
	local elements = {}
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		if item.limit == -1 then
			item.limit = 100
		end

		table.insert(elements, {
			label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
			label_real = item.label,
			item       = item.item,
			price      = item.price,

			-- menu properties
			value      = 1,
			type       = 'slider',
			min        = 1,
			max        = item.limit
		})
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = _U('shop'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title    = _U('shop_confirm', data.current.value, data.current.label_real, ESX.Math.GroupDigits(data.current.price * data.current.value)),
			align    = 'bottom-right',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				TriggerServerEvent('esx_blackmarket:buyItem', data.current.item, data.current.value, zone)
			end

			menu2.close()
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {zone = zone}
	end)
end

AddEventHandler('esx_blackmarket:hasEnteredMarker', function(zone)

	if zone == "blackmarket" then

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {zone = zone}

	elseif zone == "craftdrill" then

		CurrentAction     = 'craft_drill'
		CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~y~Drill~s~ besazid."
		CurrentActionData = {zone = zone}

	elseif zone == "craftblowtorch" then

		CurrentAction     = 'craft_blowtorch'
		CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~y~BlowTorch~s~ besazid."
		CurrentActionData = {zone = zone}

	end

end)

AddEventHandler('esx_blackmarket:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

local NearCoords = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3)
		local sleep = true
		NearCoords = CheckDistance()
		if NearCoords then
			sleep = false
			DrawMarker(0, vector3(-53.94,-1226.15,30.78), 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
		end
		if sleep then Citizen.Wait(765) end
	end
end)

function CheckDistance()
	if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), vector3(-53.94,-1226.15,28.78), false) < 2.0 then
		return true
	else
		return false
	end
end

AddEventHandler("onKeyUP", function(key)
	if key == "e" and NearCoords then
		OpenShopMenu("blackmarket")
	end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(-53.94,-1226.15,28.78)

	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, 484)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 32)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("BlackMarket")
	EndTextCommandSetBlipName(blip)

	RequestModel(GetHashKey("mp_m_weapwork_01"))

	while not HasModelLoaded(GetHashKey("mp_m_weapwork_01")) do
		Wait(0)
	end

	local stripPed = CreatePed(1, GetHashKey("mp_m_weapwork_01"), -53.94,-1226.15,27.78, 36.49, false, false)
	--table.insert(StripPeds, stripPed)
	
	SetEntityInvincible(stripPed, true)
	SetBlockingOfNonTemporaryEvents(stripPed, true)
	
	Wait(500)
	
	FreezeEntityPosition(stripPed, true)
	SetPedFleeAttributes(stripPed, 0, 0)
	SetPedArmour(stripPed, 100)
	SetPedMaxHealth(stripPed, 100)
	SetPedDiesWhenInjured(stripPed, false)
	--TaskPlayAnim(stripPed, v.animation, v.animationName, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	SetModelAsNoLongerNeeded(GetHashKey("mp_m_weapwork_01"))
end)