---@diagnostic disable: missing-parameter, need-check-nil
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

ESX = nil
local AllPeds = {}
local PlayerData              = nil
local BlipList                = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
CurrentActionP           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
Configjafari = {}
AllLocations = {}
Configjafari.Locale = 'en'

Configjafari.MarkerType   = 1
Configjafari.DrawDistance = 100.0
Configjafari.MarkerSize   = {x = 2.0, y = 2.0, z = 1.0}
Configjafari.MarkerColor  = {r = 102, g = 102, b = 204}

Configjafari.BlipHospital = {
	Sprite = 403,
	Color = 2,
	Display = 2,
	Scale = 1.0
}

Configjafari.Price = 10000 -- Edit this to your liking.

Configjafari.EnableUnemployedOnly = false -- If true it will only show Blips to Unemployed Players | false shows it to Everyone.
Configjafari.EnableBlips = false -- If true then it will show blips | false does the Opposite.
Configjafari.EnablePeds = true -- If true then it will add Peds on Markers | false does the Opposite.

Configjafari.Locations = {
	{ x = 487.51, y = -986.11, z = 29.69, heading = 81.02, access = "police" },  -- pd
	{ x = -687.74, y = 333.43, z = 77.12, heading = 267.58, access = "all" }, -- medic 
	{ x = 1846.83, y = 3689.67, z = 33.33, heading = 37.22, access = "sheriff" },  -- sheriff 
	{ x = -453.52, y = 5997.63, z = 36.0, heading = 321.05, access = "sheriff" },  -- sheriff Paleto 
	{ x = 1768.13, y = 3641.62, z = 33.85, heading = 157.71, access = "all" },  -- medic biron shahr 
	{ x = 619.15, y = -10.97, z = 86.05, heading = 339.71, access = "forces" }, -- special 
	{ x = 126.73, y = -729.1, z = 241.15, heading = 79.34, access = "fbi" }, -- fbi  
	{ x = -3199.77, y = 782.84, z = 7.93, heading = 126.71, access = "DARK" }, --  malibu 
	{ x = 1408.22, y = 1144.02, z = 113.34, heading = 4.27, access = "PERSIAN" }, -- horsehouse
	{ x = -1808.91, y = 430.14, z = 127.51, heading = 85.13, access = "Silver" }, -- qasr
	{ x = -657.17, y = 951.49, z = 242.95, heading = 171.0, access = "Valton" }, -- khone chobi
	{ x = -91.11, y = 1001.65, z = 233.4, heading = 294.88, access = "Liquid" }, -- 021 khone 
	{ x = -809.34, y = 190.81, z = 71.48, heading = 151.19, access = "Godal" }, --khone michael
	{ x = 737.54, y = -1084.57, z = 21.17, heading = 91.29, access = "FANTOM" }, --Mechanic Pain PD
	{ x = -7.66, y = 513.59, z = 173.64, heading = 335.29, access = "Brotherhood" }, --franklin 
	{ x = 602.01, y = 599.15, z = 129.05, heading = 342.13, access = "Akatsuki" }, -- shahrak vasat
	{ x = 707.72, y = 668.8, z = 128.85, heading = 67.77, access = "SNO" }, -- shahrak goshe RIOTERS
	{ x = -625.95, y = -1622.91, z = 32.01, heading = 262.5, access = "KING" }, -- Map BlackMarket Ghadim
	{ x = -1511.4, y = 112.82, z = 54.64, heading = 221.41, access = "Sopranos" }, -- PlayBoy
	{ x = -565.67, y = -198.02, z = 37.22, heading = 303.5, access = "justice" }, --  DOJ
	{ x = 991.22, y = -116.94, z = 73.32, heading = 36.23, access = "TheLost" }, -- the lostmc 
	{ x = 1021.93, y = -2509.35, z = 27.3, heading = 176.27, access = "Vision" }, -- Vision
	{ x = -1068.53, y = -815.01, z = 14.64, heading = 39.4, access = "police" }, -- pd central
	{ x = -118.78, y = 1259.32, z = 312.07, heading = 303.06, access = "KBM" }, -- sefidkbm
	{ x = 1448.56, y = -2624.03, z = 47.99, heading = 341.11, access = "HellsAngels" }, -- mape kenare Fanos
	{ x = -901.28, y = 43.94, z = 48.88, heading = 56.28, access = "PeakyBlinders" }, -- PeakyBlinders
	{ x = 1955.19, y = 3824.45, z = 31.16, heading = 27.02, access = "Samurai" }, -- MC map dakheli poshte sheriff
	{ x = -1010.73, y = 153.16, z = 57.51, heading = 23.04, access = "VAMPIRES" }, -- VAMPIRES  ta 21.2.2025 nemone
	{ x = -1589.79, y = -62.14, z = 55.48, heading = 5.35, access = "vipers" }, -- vipers
}
Configjafari.Zones = {}

for i=1, #Configjafari.Locations, 1 do
	Configjafari.Zones['Shop_' .. i] = {
		Pos   = Configjafari.Locations[i],
		Size  = Configjafari.MarkerSize,
		Color = Configjafari.MarkerColor,
		Type  = Configjafari.MarkerType,
	}
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(1000)
	end

	PlayerData = ESX.GetPlayerData()
	CreateP()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	PlayerData.job = job
	for k,v in pairs(AllPeds) do
		DeleteEntity(k)
	end
	CreateP()
end)

RegisterNetEvent('medic:refreshGangs')
AddEventHandler('medic:refreshGangs', function(data)
	AllLocations = {}
	for k, v in pairs(data) do
		table.insert(AllLocations, v)
	end
	for k, v in pairs(Configjafari.Locations) do
		table.insert(AllLocations, v)
	end
	for k,v in pairs(AllPeds) do
		DeleteEntity(k)
	end
	Configjafari.Zones = {}
	for i=1, #AllLocations, 1 do
		Configjafari.Zones['Shop_' .. i] = {
			Pos   = AllLocations[i],
			Size  = Configjafari.MarkerSize,
			Color = Configjafari.MarkerColor,
			Type  = Configjafari.MarkerType,
		}
	end
	CreateP()
end)

-- Open Hospital Menu
function OpenHospitalMenu(_)
	ESX.UI.Menu.CloseAll()
	carryAsking = true
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'revive_quest',
	{
		title 	 = 'Darkhast Heal Ya Revive',
		align    = 'center',
		question = "Mablagh 10k Az Shoma Daryaft Mishavad, Ghabool Mikonid?",
		elements = {
			{label = 'Kheyr', value = 'no'},
			{label = 'Bale', value = 'yes'},
		}
	}, function(data, menu)
		menu.close()
		carryAsking = false
		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_hospital:checkMoney', function(hasEnoughMoney)
				if hasEnoughMoney then
					if InJure then
						TriggerEvent("mythic_progbar:client:progress", {
							name = "process_it",
							duration = 60000,
							label ="Reviving...",
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
						},})
						SetTimeout(60000,function()
							local coord = GetEntityCoords(PlayerPedId())
							local coord2 = GetEntityCoords(_)
							if #(coord - coord2) >= 5.0 then return ESX.Alert("Shoma Az Bot Medic Door Shodid", "info") end
							ESX.TriggerServerCallback('esx_ambulancejob:NPCRevive', function()
								TriggerEvent('esx_ambulancejob:revive', GetEntityMaxHealth(PlayerPedId())/2)
							end)
						end)
						return
					end
					ESX.SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(PlayerPedId())/2)
					medicResetADR()
					afterCrawlRevive = false
				else
					ESX.ShowNotification("Shoma Pool Kafi Nadarid")
				end
			end)
		elseif data.current.value == 'no' then
			menu.close()
		end
	end, function (data, menu)
		carryAsking = false
		menu.close()
	end)
end

AddEventHandler('esx_hospital:hasEnteredMarker', function(zone)
	CurrentActionP     = 'hospital_menu'
	CurrentActionMsg  = _U('press_access')
	CurrentActionData = {}
end)

AddEventHandler('esx_hospital:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentActionP = nil
end)

-- Activate Menu when in Markers
Citizen.CreateThread(function()
	while not PlayerData do Citizen.Wait(1000) end
	while true do
		Citizen.Wait(100)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Configjafari.Zones) do
			local item = v.Pos
			if (item.access == "all" or PlayerData.job.name == item.access or PlayerData.gang.name == item.access) and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_hospital:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_hospital:hasExitedMarker', LastZone)
		end
		
		if not isInMarker then
			Citizen.Wait(500)
		end
	end
end)


--[[local hasy = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20000)
		if GlobalState.ambulance >= 15 then
			if not hasy then
				hasy = true
				for k,v in pairs(AllPeds) do
					if ESX.Math.Round(v.y, 2) == 3641.62 or ESX.Math.Round(v.y, 2) == -1028.26 then
						DeleteEntity(k)
					end
				end
			end
		else
			if hasy then
				hasy = false
				CreateP()
			end
		end
	end
end)]]

-- Key controls
--[[RegisterKey("E", false, function()
	if CurrentActionP == 'hospital_menu' then
		if ESX.GetPlayerData().IsDead == -1 then return ESX.Alert("Shoma Newlife Shodid, Bot Nemitavanad Shoma Ra Revive Konad", "error") end
		if InJure then
			TriggerEvent('esx_ambulancejob:revive', GetEntityMaxHealth(PlayerPedId())/2)
		end
		OpenHospitalMenu()
	end
end)]]

-- Blips
function deleteBlips()
	if BlipList[1] ~= nil then
		for i=1, #BlipList, 1 do
			RemoveBlip(BlipList[i])
			BlipList[i] = nil
		end
	end
end

function refreshBlips()
	if Configjafari.EnableBlips then
		if Configjafari.EnableUnemployedOnly then
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unemployed' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'gang' then
				for k,v in pairs(Configjafari.Locations) do
					local blip = AddBlipForCoord(v.x, v.y)

					SetBlipSprite (blip, Configjafari.BlipHospital.Sprite)
					SetBlipDisplay(blip, Configjafari.BlipHospital.Display)
					SetBlipScale  (blip, Configjafari.BlipHospital.Scale)
					SetBlipColour (blip, Configjafari.BlipHospital.Color)
					SetBlipAsShortRange(blip, true)

					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('blip_hospital'))
					EndTextCommandSetBlipName(blip)
					table.insert(BlipList, blip)
				end
			end
		else
			for k,v in pairs(Configjafari.Locations) do
				local blip = AddBlipForCoord(v.x, v.y)

				SetBlipSprite (blip, Configjafari.BlipHospital.Sprite)
				SetBlipDisplay(blip, Configjafari.BlipHospital.Display)
				SetBlipScale  (blip, Configjafari.BlipHospital.Scale)
				SetBlipColour (blip, Configjafari.BlipHospital.Color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('blip_hospital'))
				EndTextCommandSetBlipName(blip)
				table.insert(BlipList, blip)
			end
		end
	end
end

function CreateP()
	Citizen.CreateThread(function()
		RequestModel(GetHashKey("s_m_m_doctor_01"))
		
		while not HasModelLoaded(GetHashKey("s_m_m_doctor_01")) do
			Wait(1)
		end
		for k,v in pairs(AllPeds) do
			DeleteEntity(k)
		end
		AllPeds = {}
		if Configjafari.EnablePeds then
			for _, item in pairs(AllLocations) do
				if item.access == "all" or PlayerData.job.name == item.access or PlayerData.gang.name == item.access then
					local npc = CreatePed(4, 0xd47303ac, item.x, item.y, item.z, item.heading, false, true)
					AllPeds[npc] = vector3(item.x, item.y, item.z)
					SetEntityHeading(npc, item.heading)
					FreezeEntityPosition(npc, true)
					SetEntityInvincible(npc, true)
					SetBlockingOfNonTemporaryEvents(npc, true)
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
    local peds = {
        "s_m_m_doctor_01",
    }
    exports['diamond_target']:AddTargetModel(peds, {
        options = {
            {
                icon = "fa-solid fa-user-doctor",
                label = "درخواست درمان",
                action = function(_)
					if CurrentActionP == 'hospital_menu' then
						if ESX.GetPlayerData().IsDead == -1 then return ESX.Alert("Shoma Newlife Shodid, Bot Nemitavanad Shoma Ra Revive Konad", "error") end
						OpenHospitalMenu(_)
					end
                end,
            },
        },
        distance = 2.5
    })
end)

function Eligible()
	local is = false
	local counter = 0
	local coord = GetEntityCoords(PlayerPedId())
	for k, v in pairs(GetActivePlayers()) do
		local serverID = GetPlayerServerId(v)
		local ped = GetPlayerPed(v)
		local pedCoords = GetEntityCoords(ped)
		local data = Player(serverID).state["job"]
		if #(coord - pedCoords) <= 80 and data and data == "ambulance" then
			counter = counter + 1
		end
	end
	if counter >= 15 then
		is = true
	end
	return is
end