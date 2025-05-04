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

ESX          = nil
local PlayerData = nil
local Gang = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(500)
	end
	PlayerData = ESX.GetPlayerData()
	--[[ESX.TriggerServerCallback("KoobseBokhor", function(IsValid)
		if IsValid then
			TheNextTeleport()
			Gang = true
		end
	end)]]
	ESX.RegisterClientCallback("esx:askTargetForBill", function(cb, data)
		local Voted = false
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'carry',
		{
			title 	 = 'Systeme Ghabz',
			align    = 'center',
			question = "Yek Ghabz Be Mablagh "..ESX.Math.GroupDigits(data.bill).."$ Az Taraf "..data.name.."("..data.id..") Baraye Shoma Sabt Shode, Ghabul Mikonid?",
			elements = {
				{label = 'Bale', value = true},
				{label = 'Kheyr', value = false},
			}
		}, function(data, menu)
			Voted = true
			ESX.UI.Menu.CloseAll()
			cb(data.current.value)
		end)
		Citizen.SetTimeout(15000, function()
			if not Voted then
				cb(false)
				ESX.UI.Menu.CloseAll()
			end
		end)
	end)
end)

function ShowBillsMenu()
	ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
		ESX.UI.Menu.CloseAll()
		local elements = {}

		for i=1, #bills, 1 do
			table.insert(elements, {
				label  = ('%s - <span style="color:red;">%s</span>'):format(bills[i].label, _U('invoices_item', ESX.Math.GroupDigits(bills[i].amount))),
				billID = bills[i].id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			title    = _U('invoices'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_billing:payBill', function()
				ShowBillsMenu()
			end, data.current.billID)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

AddEventHandler("openBills", function()
	ShowBillsMenu()
end)

--[[AddEventHandler("onKeyDown", function(key)
	if key == "f7" then
		if ESX.GetPlayerData()['IsDead'] ~= 1 and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'billing') then
			ShowBillsMenu()
		end
	end
end)]]

--[[local Coord, IsNear = false, false

function TheNextTeleport()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(3)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-299.5, -727.95, 33.5), true) < 3.0 then
				DrawMarker(8, -299.5, -727.95, 33.45, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.9, 1.9, 1.0, 102, 0, 204, 170, false, true, 2, false, false, false, false)
				Coord = vector3(-288.42, -722.47, 124.99)
				IsNear = true
			elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-288.42, -722.47, 124.5), true) < 3.0 then
				DrawMarker(8, -288.42, -722.47, 124.52, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.9, 1.9, 1.0, 102, 0, 204, 170, false, true, 2, false, false, false, false)
				Coord = vector3(-299.5, -727.95, 33.99)
				IsNear = true
			else
				Coord, IsNear = false, false
			end
		end
	end)
end

AddEventHandler("onKeyDown", function(key)
	if key == "e" and Gang and IsNear then
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(100)
		end
		RequestCollisionAtCoord(Coord)
		ESX.SetEntityCoords(PlayerPedId(), Coord)
		SetEntityHeading(PlayerPedId(), 250.0)
		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
			ESX.SetEntityCoords(PlayerPedId(), Coord)
			Citizen.Wait(10)
		end
		DoScreenFadeIn(500)
	end
end)]]

RegisterNetEvent("SvRest:AlarmTimeReast")
AddEventHandler("SvRest:AlarmTimeReast",function()
    soundID = GetSoundId()
    PlaySoundFromEntity(soundID, "Crate_Beeps", GetPlayerPed(-1), "MP_CRATE_DROP_SOUNDS", true, 0)
    SetTimeout(5000,function()
        StopSound(soundID) -- stop the crate beeping sound
        ReleaseSoundId(soundID) -- won't need this sound ID any longer
    end)
end)

local function showAdvancedNotification(msg)
    AddTextEntry('VehTaxesNotification', msg)
    BeginTextCommandThefeedPost('VehTaxesNotification')
    EndTextCommandThefeedPostMessagetext('CHAR_BANK_MAZE', 'CHAR_BANK_MAZE', false, 9, "Tax Administration", '')
end

RegisterNetEvent('taxes:notify')
AddEventHandler('taxes:notify', function(msg)
    showAdvancedNotification(msg)
end)




