IsNUIReady = false
ESX = nil
PlayerData = nil
offHud = false
pedaret = RequestScaleformMovie("minimap")
local Organs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["forces"] = true,
    ["fbi"] = true,
    ["artesh"] = true,
    ["cia"] = true
}
local data = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
    if PlayerData.job.ext then
        if PlayerData.job.ext == "drs" and PlayerData.job.name == "ambulance" then
            PlayerData.job.label = PlayerData.job.label.." | DarooSaz"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "swat" then
            PlayerData.job.label = PlayerData.job.label.." | S.W.A.T"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "riot" then
            PlayerData.job.label = PlayerData.job.label.." | Riot"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "tre" then
            PlayerData.job.label = PlayerData.job.label.." | Traffic Enforcment"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "police" then
            PlayerData.job.label = PlayerData.job.label
        end
    end
end)

RegisterNUICallback('NUIReady', function(data, cb)
	IsNUIReady = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    PlayerData.job = job
    if PlayerData.job.ext then
        if PlayerData.job.ext == "drs" and PlayerData.job.name == "ambulance" then
            PlayerData.job.label = PlayerData.job.label.." | DarooSaz"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "swat" then
            PlayerData.job.label = PlayerData.job.label.." | S.W.A.T"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "riot" then
            PlayerData.job.label = PlayerData.job.label.." | Riot"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "tre" then
            PlayerData.job.label = PlayerData.job.label.." | Traffic Enforcment"
        elseif Organs[PlayerData.job.name] and string.lower(PlayerData.job.ext) == "police" then
            PlayerData.job.label = PlayerData.job.label
        end
    end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    ESX.PlayerData.gang = gang
    PlayerData.gang = gang
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
    ESX.PlayerData.money = money
    PlayerData.money = money
end)

RegisterNetEvent('gcphone:setUiPhone')
AddEventHandler('gcphone:setUiPhone', function(money)
    ESX.PlayerData.bank = money
    PlayerData.bank = money
end)

RegisterNetEvent("nameUpdate")
AddEventHandler("nameUpdate", function(name)
    PlayerData.name = name
end)

RegisterNetEvent('blackmoneyUpdate')
AddEventHandler('blackmoneyUpdate', function(money)
    ESX.PlayerData.black_money = money
    PlayerData.black_money = money
end)

RegisterNetEvent('HR_Coin:UpdateThatFuckinShit')
AddEventHandler('HR_Coin:UpdateThatFuckinShit', function(dCoin)
    ESX.PlayerData.Coin = dCoin
    PlayerData.Coin = dCoin
end)

function TriggerThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2500)
            TriggerInformation()
            SetRadarZoom(1100)
            BeginScaleformMovieMethod(pedaret, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
            if IsPauseMenuActive() or offHud then
                SendNUIMessage({type = 'HideHUD'})
                Citizen.Wait(1000)
            else
                SendNUIMessage({type = 'ShowHUD'})
                Citizen.Wait(1000)
            end
        end
    end)
end
function WeaponHUD()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2000)
            local ped = PlayerPedId()
            local playerId = PlayerId()
            local player = GetPlayerPed(-1)
            if IsPedArmed(player, 7) and not exports["xsound"]:isPlayerInStreamerMode() then
                SendNUIMessage({action = 'Gunshow', type = 'bottom-left-weapon'})
                local weapon = GetSelectedPedWeapon(player)
                local ammoTotal = GetAmmoInPedWeapon(player,weapon)
                local bool,ammoClip = GetAmmoInClip(player,weapon)
                local ammoRemaining = math.floor(ammoTotal - ammoClip)
                local wpnData = ESX.GetWeaponFromHash(weapon)
                if wpnData then
                    SendNUIMessage({action = 'setWeaponImg',data = wpnData.name})
                    SendNUIMessage({action = 'updateGun', type = 'weapon-info', data = ammoClip.."/ "..ammoRemaining})		
                end		  
            else
                Citizen.Wait(1000)
                SendNUIMessage({action = 'Gunhide', type = 'bottom-left-weapon'})
            end
        end
    end)
end 

function TriggerInformation()
	local ped = PlayerPedId()

	local x,y,z = table.unpack(GetEntityCoords(ped))
	data.street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
	data.date = {
		hour = GetClockHours(),
		minute = GetClockMinutes()
	}

	data.armour = GetPedArmour(ped)
	data.menu = IsPauseMenuActive() or offHud
	data.health = tonumber((GetEntityHealth(ped)-100))
  
	data.oxygen = ((GetPlayerUnderwaterTimeRemaining(PlayerId())/10)*100)
	
    SendNUIMessage({
        type = 'updateStatusUP',
		name = PlayerData.name:gsub('_', ' '),
        id = GetPlayerServerId(PlayerId()),
        money = ESX.Math.GroupDigits(PlayerData.money),
        job = PlayerData.job.label..'┃'..PlayerData.job.grade_label,
        gang = PlayerData.gang.name..'┃'..PlayerData.gang.grade_label,
		coin = ESX.Math.GroupDigits(PlayerData.Coin),
    })
end

function FasterData()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            local ped = PlayerPedId()
            data.armour = GetPedArmour(ped)
            data.menu = IsPauseMenuActive() or offHud
            data.health = tonumber((GetEntityHealth(ped)-100))
            data.oxygen = ((GetPlayerUnderwaterTimeRemaining(PlayerId())/10)*100)
            SendNUIMessage({ type = 'info', data = data })
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            data.hunger = hunger.val / 10000
            Citizen.Wait(2500)
        end)
        TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
            data.thirst = thirst.val / 10000
            Citizen.Wait(2500)
        end)
        TriggerEvent('esx_status:getStatus', 'mental', function(mental)
            data.stamina = mental.val / 10000
            Citizen.Wait(2500)
        end)
        SendNUIMessage({ type = 'info', data = data })
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function ()
    while not IsNUIReady or not PlayerData do
        Citizen.Wait(5000)
    end
    TriggerThread()
    WeaponHUD()
    FasterData()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        while not IsNUIReady or not PlayerData do
            Citizen.Wait(5000)
        end
        TriggerThread()
        WeaponHUD()
        FasterData()
    end
end)

AddEventHandler('pma-voice:setTalkingMode', function(mode)
	SendNUIMessage({ type = 'SetVoice', mode = mode })
end)

AddEventHandler("pedaretSekteKard", function(toggle)
    offHud = toggle
end)