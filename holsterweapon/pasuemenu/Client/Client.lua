---@diagnostic disable: missing-parameter
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(1000)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().gang == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('HR_Coin:UpdateThatFuckinShit')
AddEventHandler('HR_Coin:UpdateThatFuckinShit', function(dCoin)
    ESX.PlayerData.Coin = dCoin
    PlayerData.Coin = dCoin
end)

RegisterNetEvent("nameUpdate")
AddEventHandler("nameUpdate", function(name)
    ESX.SetPlayerData("name", name)
    PlayerData.name = name
end)

RegisterNetEvent('blackmoneyUpdate')
AddEventHandler('blackmoneyUpdate', function(money)
    PlayerData.black_money = money
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
    PlayerData.money = money
end)

RegisterNetEvent('gcphone:setUiPhone')
AddEventHandler('gcphone:setUiPhone', function(money)
    PlayerData.bank = money
end)

local open = false
RegisterCommand('openSettinggmenu', function()
    if IsNuiFocused() then return end
    if not open and not IsPauseMenuActive() then

        open = true
        SetNuiFocus(true,true)
        SendNUIMessage({
            action = 'show',
        })
    end
end)

RegisterKeyMapping("openSettinggmenu","Open Setting","keyboard","Escape")

RegisterCommand("Map",function()
	ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"),0,-1)
end)

RegisterKeyMapping("Map","Open Map","keyboard","P")

Citizen.CreateThread(function()
    while true do 
        SetPauseMenuActive(false) 
        Citizen.Wait(3)
    end
end)

RegisterNUICallback('exit', function(data, cb)
	SetNuiFocus(false, false)
	open = false
end)

RegisterNUICallback('SendAction', function(data, cb)
    if data.action == "redeem" then
        SetNuiFocus(false, false)
        ExecuteCommand("redeem")
    elseif data.action == 'settings' then 
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'),0,-1) 
        SetNuiFocus(false, false)
    elseif data.action == 'map' then 
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'),0,-1) 
        SetNuiFocus(false, false)
    elseif data.action == "battlepass" then
        ExecuteCommand("tmp")
	elseif data.action == 'exit' then
        SetNuiFocus(false, false)
		open = false
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'close_confirm', {
            title    = 'آیا واقعا میخواهید از سرور خارج شوید؟',
            align    = 'center',
            elements = {
                {label = 'خیر',  value = false},
                {label = 'بله', value = true},
            }
        }, function(data, menu)
            menu.close()
            if data.current.value then
                RestartGame()
            end
        end, function(data, menu)
            menu.close()
        end)
    end
end)

RegisterNUICallback("requestInfos",function(data,cb)
	if PlayerData and ESX then
		cb({
            name = PlayerData.name,
            user_id = GetPlayerServerId(PlayerId()),
            players = exports.diamond_utils:GetActivePlayers(),
            time = "23:40",
            cellphone = PlayerData.phone,
            bank = ESX.Math.GroupDigits(PlayerData.bank),
            group = PlayerData.group
        })
	end
end)

local ragdolled = false
local vdmCount = 0
local timeout
local timeoutVDM = {}

AddEventHandler('gameEventTriggered', function(name, data)
	if name == 'CEventNetworkEntityDamage' then
		local hash = data[7]
		local victim = data[1]
		local attacker = data[2]
		if hash == -1553120962 then
            if attacker == PlayerPedId() and GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 and IsPedAPlayer(attacker) and IsPedAPlayer(victim) then
                local vehicle = GetVehiclePedIsIn(attacker)
				local plate = GetVehicleNumberPlateText(vehicle)
                local victimid = NetworkGetPlayerIndexFromPed(victim)
                local svID = GetPlayerServerId(victimid)
				if plate and GetPedInVehicleSeat(vehicle,-1) == PlayerPedId() and not timeoutVDM[svID] and (GetEntitySpeed(vehicle)*3.6) > 10.0 then
                    timeoutVDM[svID] = true
                    ESX.SetTimeout(3000, function()
                        timeoutVDM[svID] = nil
                    end)
                    if vdmCount == 0 then
                        timeout = ESX.SetTimeout(30000, function()
                            vdmCount = 0
                            timeout = nil
                        end)
                    end
                    vdmCount = vdmCount + 1
                    ESX.Alert("VDM Warning: "..vdmCount.."/3 (Timeout 30 Seconds)", "error")
                    if vdmCount == 3 then
                        ESX.Game.DeleteVehicle(vehicle)
                        ESX.Alert("Mashin Shoma Be Dalil VDM Kardan Bish Az Had Paak Shod, Lotfan Report Dar In Mored Ersal Nakonid", "error")
                        vdmCount = 0
                        ESX.ClearTimeout(timeout)
                        timeout = nil
                    end
                end
			end
		end
    end
end)