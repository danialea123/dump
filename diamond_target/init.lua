---@diagnostic disable: inject-field, cast-local-type
ESX = nil
PlayerData = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while not ESX.GetPlayerData().job do Citizen.Wait(10000) end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

local Allowed = {
	["police"] = true,
	["sheriff"] = true,
	["forces"] = true,
	["fbi"] = true,
	["justice"] = true,
}

Citizen.CreateThread(function()
    local peds = {
        "mp_f_freemode_01",
        "mp_m_freemode_01",
		"a_f_m_eastsa_02",
		"a_f_y_indian_01",
		"a_m_m_business_01",
		"a_m_m_fatlatin_01",
		"a_m_m_genfat_01",
		"a_m_m_hasjew_01",
		"a_m_m_mlcrisis_01",
		"a_m_y_hasjew_01",
		"a_m_y_juggalo_01",
		"a_m_y_skater_01",
		"a_m_y_skater_02",
		"a_m_y_smartcaspat_01",
		"cs_hunter",
		"cs_lazlow",
		"cs_lazlow_2",
		"cs_lestercrest",
		"cs_michelle",
		"cs_milton",
		"cs_molly",
		"cs_movpremmale",
		"cs_mrs_thornhill",
		"cs_nervousron",
		"cs_nigel",
		"cs_siemonyetarian",
		"cs_stretch",
		"cs_terry",
		"csb_agatha",
		"csb_avery",
		"csb_g",
		"csb_paige",
		"csb_talcc",
		"csb_talmm",
		"g_m_m_armboss_01",
		"g_m_m_armgoon_01",
		"g_m_m_cartelgoons_01",
		"g_m_m_casrn_01",
		"g_m_m_maragrande_01",
		"g_m_y_azteca_01",
		"g_m_y_famca_01",
		"hc_hacker",
		"ig_ahronward",
		"ig_callgirl_01",
		"ig_djblamryans",
		"ig_djsolfotios",
		"ig_djsolmanager",
		"ig_djsolmike",
		"ig_djtalaurelia",
		"ig_groom",
		"ig_jamalamir",
		"ig_jaywalker",
		"ig_lacey_jones_02",
		"ig_magenta",
		"ig_natalia",
		"ig_ortega",
		"ig_paper",
		"ig_ramp_mex",
		"ig_roostermccraw",
		"ig_sol",
		"ig_solomon",
		"ig_vincent",
		"ig_yusufamir",
		"lara",
		"marshmello",
		"mp_f_boatstaff_01",
		"mp_f_execpa_02",
		"mp_m_execpa_01",
		"mp_m_g_vagfun_01",
		"player_one",
		"player_two",
		"player_zero",
		"tinyroco",
		"s_f_y_clubbar_01",
		"s_m_y_mime",
		"s_m_y_shop_mask",
		"tinyarmboss",
		"tinybabyd",
		"tinybeachman",
		"tinybev2",
		"tinyboss1",
		"tinybusker",
		"tinycrop",
		"tinydance",
		"tinydeans",
		"tinydebbie",
		"tinyeps",
		"tinyfarm",
		"tinygangster",
		"tinygenho",
		"tinygens",
		"tinygolfer",
		"tinyjew1",
		"minijon",
		"minilar",
		"tinylawman",
		"tinylost1",
		"tinymanuel",
		"tinymaxgoon",
		"tinynigel",
		"tinyoneil",
		"tinypopmich",
		"tinypro",
		"tinypunk1",
		"tinypunk2",
		"tinysalva",
		"tinysol",
		"tinytom",
		"tinytourist",
		"tinyushi",
		"tinyvag",
		"tinyvagos",
		"tinyafriamer",
		"Tiny Shopmid",
		"pedhoxtor2",
		"pedhoxtor1",
		"wick",
		"edward",
		"badbunny",
		"penguinman",
		"trump",
		"sophia",
		"gabriela",
		"liana",
		"Batman_AC",
		"Geralt_Shirt",
		"IronManMvsC",
		"John_Wick_Chapter4",
		"Joker_2019_MT",
		"KratosFortnite",
		"Naruto",
		"Otis",
		"Spider-ManComicsv2",
		"Sukuna_JJKLCC_Kiml",
		"SoldierSquidGame",
    }
    while not ESX do Citizen.Wait(10000) end
	while not PlayerData do Citizen.Wait(10000) end
	exports['diamond_target']:AddTargetModel(peds, {
		options = {
			{
				icon = "fa-solid fa-id-card",
				label = "نشان دادن کارت شناسایی",
				action = function(_)
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
					local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_))
					ExecuteCommand('idcard '..targetID)
				end,
			},
			{
				icon = "fa-solid fa-id-card",
				label = "نشان دادن کارت شناسایی فیک",
				canInteract = function(_)
					return PlayerData.job.name == "fbi"
				end,
				action = function(_)
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
					local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_))
					ExecuteCommand('idcard '..targetID.." true")
				end,
			},
			{
				icon = "fa-solid fa-user",
				label = "بلند کردن",
				action = function(_)
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
					local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_))
					ExecuteCommand("bhnjs "..targetID)
				end,
			},
			{
				icon = "fa-regular fa-hand",
				label = "سلام کردن",
				action = function(_)
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
					ExecuteCommand('e wave8')
					Citizen.Wait(3000)
					TriggerEvent("onKeyDown", "x")
				end,
			},
			{
				icon = "fa-solid fa-right-left",
				label = "درخواست ترید",
				action = function(_)
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
					local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_))
					ExecuteCommand("trade "..targetID)
				end,
			},
			{
				icon = "fa-solid fa-scissors",
				label = "سنگ کاغذ قیچی",
				action = function(_)
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
					local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_))
					TriggerServerEvent("vrs-rps:server:ServerRequest", tonumber(targetID))
				end,
			},
			{
				icon = "fa-solid fa-dice",
				label = "تاس انداختن",
				action = function(_)
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
					ExecuteCommand("dice")
				end,
			},
			{
				icon = "fa fa-user-md",
				label = "ریوایو کردن",
				canInteract = function(_)
					local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_))
					return ESX.GetPlayerState(targetID, "Crawling") == true
				end,
				action = function(_)
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
					local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_))
					if ESX.GetPlayerState(targetID, "Crawling") == true then
						TriggerServerEvent("esx_ambulancejob:reviveWhileCrawling", targetID)
					else
						ESX.Alert("Shoma Nemitavanid In Player Ra Revive Konid", "info")
					end
				end,
			},
			{
				icon = "fa fa-user-secret",
				label = "دزدی کردن",
				canInteract = function(_)
					if PlayerData.gang.name == "nogang" and not Allowed[PlayerData.job.name] then return false end
					local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_))
					return ESX.GetPlayerState(targetID, "Crawling") == true
				end,
				action = function(_)
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
					local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(_))
					if ESX.GetPlayerState(targetID, "Crawling") == true then
						TriggerEvent("esx_ambulancejob:OpenSearchMenu", targetID)
					else
						ESX.Alert("Shoma Nemitvanid In Player Ra Dar In Sharayet Rob Konid", "info")
					end
				end,
			},
		},
		distance = 2.5,
	})
end)

function Load(name)
	local resourceName = GetCurrentResourceName()
	local chunk = LoadResourceFile(resourceName, ('data/%s.lua'):format(name))
	if chunk then
		local err
		chunk, err = load(chunk, ('@@%s/data/%s.lua'):format(resourceName, name), 't')
		if err then
			error(('\n^1 %s'):format(err), 0)
		end
		return chunk()
	end
end

-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------

Config = {}

-- It's possible to interact with entities through walls so this should be low
Config.MaxDistance = 5.0

-- Enable debug options
Config.Debug = false

-- Supported values: true, false
Config.Standalone = true

-- Enable outlines around the entity you're looking at
Config.EnableOutline = false

-- Whether to have the target as a toggle or not
Config.Toggle = false

-- Draw a Sprite on the center of a PolyZone to hint where it's located
Config.DrawSprite = false

-- The default distance to draw the Sprite
Config.DrawDistance = 10.0

-- The color of the sprite in rgb, the first value is red, the second value is green, the third value is blue and the last value is alpha (opacity). Here is a link to a color picker to get these values: https://htmlcolorcodes.com/color-picker/
Config.DrawColor = {255, 255, 255, 255}

-- The color of the sprite in rgb when the PolyZone is targeted, the first value is red, the second value is green, the third value is blue and the last value is alpha (opacity). Here is a link to a color picker to get these values: https://htmlcolorcodes.com/color-picker/
Config.SuccessDrawColor = {30, 144, 255, 255}

-- The color of the outline in rgb, the first value is red, the second value is green, the third value is blue and the last value is alpha (opacity). Here is a link to a color picker to get these values: https://htmlcolorcodes.com/color-picker/
Config.OutlineColor = {255, 255, 255, 255}

-- Enable default options (Toggling vehicle doors)
Config.EnableDefaultOptions = false

-- Disable the target eye whilst being in a vehicle
Config.DisableInVehicle = true

-- Key to open the target eye, here you can find all the names: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.OpenKey = 'LMENU' -- Left Alt

-- Control for key press detection on the context menu, it's the Right Mouse Button by default, controls are found here https://docs.fivem.net/docs/game-references/controls/
Config.MenuControlKey = 238

-------------------------------------------------------------------------------
-- Target Configs
-------------------------------------------------------------------------------

-- These are all empty for you to fill in, refer to the .md files for help in filling these in

Config.CircleZones = {

}

Config.BoxZones = {

}

Config.PolyZones = {

}

Config.TargetBones = {

}

Config.TargetModels = {

}

Config.GlobalPedOptions = {

}

Config.GlobalVehicleOptions = {
	options = {
		{
			icon = "fa-solid fa-car",
			label = "باز کردن صندوق عقب",
			action = function(_)
				exports['esx_inventoryhud']:openTrunk(_)
			end,
		},
		{
			icon = "fa-solid fa-car",
			label = "هل دادن ماشین",
			action = function(_)
				if ESX.GetPlayerData().isSentenced then return end
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
				local vehicle = _
				local trunkpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
				local bonnetpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "bonnet"))
				local playerpos = GetEntityCoords(PlayerPedId())
				local distanceToTrunk = GetDistanceBetweenCoords(trunkpos, playerpos, true)
				local distanceToBonnet = GetDistanceBetweenCoords(bonnetpos, playerpos, true)
				if distanceToTrunk <= 2.2 or distanceToBonnet <= 2.2 then
					TriggerEvent("esx:PushVehicle", _)
				else
					ESX.Alert("Shoma Bayad Be Sandogh Ya Kapoot Mashin Nazdik Tar Shavid", "info")
				end
			end,
		},
		{
			icon = "fa-solid fa-car",
			label = "وارد شدن به صندوق عقب",
			action = function(_)
				--if ESX.GetPlayerData().isSentenced then return end
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
				TriggerEvent("esx:GetInTrunk", _)
			end,
		},
		{
			icon = "fa-solid fa-car",
			label = "خارج شدن از صندوق عقب",
			action = function(_)
				--if ESX.GetPlayerData().isSentenced then return end
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
				TriggerEvent("esx:LeaveTrunk", _)
			end,
		},
		{
			icon = "fa-solid fa-car",
			label = "بیرون انداختن راننده",
			action = function(_)
				if ESX.GetPlayerData().isSentenced then return end
					if ESX.isDead() or ESX.GetPlayerState(ESX.src, "Crawling") == true then return end
				local plate = ESX.GetPlate(_)
				if plate then
					ESX.TriggerServerCallback('esx_advancedgarage:DoesHaveKey', function(newaccess)
						if newaccess then
							local driver = GetPedInVehicleSeat(_,-1)
							if driver ~= 0 then
								ExecuteCommand("me Dar mashin ro baz mikone va fard ro az mashin biroun mindaze")
								local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(driver))
								TriggerServerEvent('esx:GetOutFromVehicle', VehToNet(_), targetID)
							else
								ESX.Alert('Kasi savar mashin nist','error')
							end
						else
							ESX.Alert("Shoma Saheb In Mashin Nistid", "error")
						end
					end, plate)
				end
			end,
		},
	}
}

Config.GlobalObjectOptions = {

}

Config.GlobalPlayerOptions = {

}

Config.Peds = {

}

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------
local function JobCheck() return true end
local function GangCheck() return true end
local function JobTypeCheck() return true end
local function ItemCheck() return true end
local function CitizenCheck() return true end

CreateThread(function()
	local state = GetResourceState('qb-core')
	if state ~= 'missing' then
		local timeout = 0
		while state ~= 'started' and timeout <= 100 do
			timeout += 1
			state = GetResourceState('qb-core')
			Wait(0)
		end
		Config.Standalone = false
	end
	if Config.Standalone then
		local firstSpawn = false
		local event = AddEventHandler('playerSpawned', function()
			SpawnPeds()
			firstSpawn = true
		end)
		-- Remove event after it has been triggered
		while true do
			if firstSpawn then
				RemoveEventHandler(event)
				break
			end
			Wait(1000)
		end
	else
		local QBCore = exports['qb-core']:GetCoreObject()
		local PlayerData = QBCore.Functions.GetPlayerData()

		ItemCheck = QBCore.Functions.HasItem

		JobCheck = function(job)
			if type(job) == 'table' then
				job = job[PlayerData.job.name]
				if job and PlayerData.job.grade.level >= job then
					return true
				end
			elseif job == 'all' or job == PlayerData.job.name then
				return true
			end
			return false
		end

		JobTypeCheck = function(jobType)
			if type(jobType) == 'table' then
				jobType = jobType[PlayerData.job.type]
				if jobType then
					return true
				end
			elseif jobType == 'all' or jobType == PlayerData.job.type then
				return true
			end
			return false
		end

		GangCheck = function(gang)
			if type(gang) == 'table' then
				gang = gang[PlayerData.gang.name]
				if gang and PlayerData.gang.grade.level >= gang then
					return true
				end
			elseif gang == 'all' or gang == PlayerData.gang.name then
				return true
			end
			return false
		end

		CitizenCheck = function(citizenid)
			return citizenid == PlayerData.citizenid or citizenid[PlayerData.citizenid]
		end

		RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
			PlayerData = QBCore.Functions.GetPlayerData()
			SpawnPeds()
		end)

		RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
			PlayerData = {}
			DeletePeds()
		end)

		RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
			PlayerData.job = JobInfo
		end)

		RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
			PlayerData.gang = GangInfo
		end)

		RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
			PlayerData = val
		end)
	end
end)

function CheckOptions(data, entity, distance)
	if distance and data.distance and distance > data.distance then return false end
	if data.job and not JobCheck(data.job) then return false end
	if data.excludejob and JobCheck(data.excludejob) then return false end
	if data.jobType and not JobTypeCheck(data.jobType) then return false end
	if data.excludejobType and JobTypeCheck(data.excludejobType) then return false end
	if data.gang and not GangCheck(data.gang) then return false end
	if data.excludegang and GangCheck(data.excludegang) then return false end
	if data.item and not ItemCheck(data.item) then return false end
	if data.citizenid and not CitizenCheck(data.citizenid) then return false end
	if data.canInteract and not data.canInteract(entity, distance, data) then return false end
	return true
end
