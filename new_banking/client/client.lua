ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

inMenu = false
local isnearBank = false
local isnearATM = false

local banks = {
	{name="Bank", id = 108, x=150.266, y=-1040.203, z=29.374},
	{name="Bank", id = 108, x=-1212.980, y=-330.841, z=37.787},
	{name="Bank", id = 108, x=-2962.582, y=482.627, z=15.703},
	{name="Bank", id = 108, x=-112.202, y=6469.295, z=31.626},
	{name="Bank", id = 108, x=314.187, y=-278.621, z=54.170},
	{name="Bank", id = 108, x=-351.534, y=-49.529, z=49.042},
	{name="Bank", id = 108, x=1175.06, y=2706.64, z=38.0},
	{name="Bank", id = 106, x=237.25, y=217.87, z=106.29},
}	

Citizen.CreateThread(function()
	while true do
		if (isnearATM or isnearBank) and not inMenu then
			Citizen.Wait(10)
			ESX.ShowHelpNotification("Press ~INPUT_PICKUP~ To Access The Bank ~y~")
		else
			Citizen.Wait(1000)
		end
	end
end)

AddEventHandler("onKeyDown", function(key)
	 if not (isnearATM or isnearBank) then
	 	return
	 end

	 if key == "e" and not inMenu then
	 	if ESX.GetPlayerData()['IsDead'] ~= 1 then
			if exports.esx_fleeca:isRobStarted() then return end
	 		inMenu = true
	 		SetNuiFocus(true, true)
	 		SendNUIMessage({type = 'openGeneral', bank = isnearBank})
	 		TriggerServerEvent('bank:balance')
	 	end
	end
	if key == "escape" and inMenu then
		if ESX.GetPlayerData()['IsDead'] ~= 1 then
			inMenu = false
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(2500)
	  if nearBank() then isnearBank = true else isnearBank = false end
	  if nearATM() then isnearATM = true else isnearATM = false end
	end
end)

Citizen.CreateThread(function()
	for k,v in ipairs(banks) do
		if v.id ~= 0 then
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite(blip, v.id)
			SetBlipScale(blip, 0.6)
			SetBlipAsShortRange(blip, true)
			SetBlipColour(blip, 25)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(tostring(v.name))
			EndTextCommandSetBlipName(blip)
		end
	end
end)

RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance, name)
	SendNUIMessage({type = "balanceHUD", balance = balance, player = name})
end)

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:depJ8cVtCRVosit', tonumber(data.amount))
	TriggerServerEvent('bank:balance')
end)

RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdJ8cVtCRVraw', tonumber(data.amountw))
	TriggerServerEvent('bank:balance')
end)

RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bank:tranJ8cVtCRVsfer', data.to, data.amountt)
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)

RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)

function nearBank()
	local player = PlayerPedId()
	local playerloc = GetEntityCoords(player, 0)	
	for _, search in pairs(banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		if distance <= 3.5 then
			return true
		end
	end
end

local atms  = {  
	GetHashKey("prop_atm_01"),
	GetHashKey("prop_atm_02"),
	GetHashKey("prop_atm_03"),
	GetHashKey("prop_fleeca_atm")
}

function nearATM()
	local coords = GetEntityCoords(PlayerPedId())
	for i,v in ipairs(atms) do
		local atm = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, v, false, false, false)
		if DoesEntityExist(atm) then
			return true
		end
	end
	return false
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local atmss = {  
	"prop_atm_01",
	"prop_atm_02",
	"prop_atm_03",
	"prop_fleeca_atm",
}

local boxZone = {
	vector3(150.266, -1040.203, 29.374),
	vector3(-112.202, 6469.295, 31.626),
}

Citizen.CreateThread(function()
	exports['diamond_target']:AddTargetModel(atmss, {
		options = {
			{
				icon = "fa-solid fa-wallet",
				label = "عابر بانک",
				action = function(entity)
					if ESX.GetPlayerData()['IsDead'] ~= 1 then
						inMenu = true
						SetNuiFocus(true, true)
						SendNUIMessage({type = 'openGeneral', bank = true})
						TriggerServerEvent('bank:balance')
					end
				end,
			},
		},
		distance = 3.5
	})
	--[[exports['diamond_target']:addTargetModelWithoutRay(atmss, {
		options = {
			{
				icon = "fas fa-chair",
				label = "🏧عابر بانک",
				cb = function(entity)
					if ESX.GetPlayerData()['IsDead'] ~= 1 then
						inMenu = true
						SetNuiFocus(true, true)
						SendNUIMessage({type = 'openGeneral', bank = true})
						TriggerServerEvent('bank:balance')
					end
				end,
			},
		},
		job = {"all"},
		distance = 1.5
	})
	for k, v in pairs(boxZone) do
		exports['diamond_target']:AddCircleZone('atm'..k,v,5,{
			name = 'atm'..k,
		}, {
			options = {
				{
					icon = "fas fa-chair",
					label = "🏧عابر بانک",
					cb = function(entity)
						if ESX.GetPlayerData()['IsDead'] ~= 1 then
							inMenu = true
							SetNuiFocus(true, true)
							SendNUIMessage({type = 'openGeneral', bank = true})
							TriggerServerEvent('bank:balance')
						end
					end,
				},
			},
			job = {"all"},
			distance = 5
		})
	end]]
end)