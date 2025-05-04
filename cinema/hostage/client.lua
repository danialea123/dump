---@diagnostic disable: undefined-field, lowercase-global, param-type-mismatch, missing-parameter, undefined-global
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	
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

RegisterNetEvent("esx_hostage:OpenSelection")
AddEventHandler("esx_hostage:OpenSelection", function()
    TriggerEvent("esx_inventoryhud:closeInventory")
    local aPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
    SelectPlayer(function(cP)
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'hostage',
        {
            title 	 = 'Gerogan Giri',
            align    = 'center',
            question = "Aya Motmaenid Ke Mikhahid Ba Player: "..GetPlayerName(cP).."("..GetPlayerServerId(cP)..") Gerogan Giri Anjam Dahid?",
            elements = {
                {label = 'Kheyr', value = 'no'},
                {label = 'Bale', value = 'yes'},
            }
        }, function(data, menu)
            if data.current.value == "yes" then
                TriggerServerEvent("esx_hostage:SetBag", GetPlayerServerId(cP))
            end
            ESX.UI.Menu.CloseAll()
        end)
    end, aPlayers, data)
end)

RegisterNetEvent("esx_hostage:Timer")
AddEventHandler("esx_hostage:Timer", function()
    TriggerEvent('InteractSound_CL:PlayOnOne', 'plastik', 1.0)
    CreateB()
    ESX.Alert("Gerogan Giri Aghaz Shod, Ta 15 Daghighe Az Mahal Gerogan Giri Fasele Nagirid", "check")
    Cancel = false
    TimeThread()
    local GlobalCoord = GetEntityCoords(PlayerPedId())
    Citizen.CreateThread(function()
        while not Cancel do
            Citizen.Wait(1000)
            local coord = GetEntityCoords(PlayerPedId())
            if ESX.GetDistance(coord, GlobalCoord) > 30.0 then
                TriggerServerEvent("esx_hostage:Cancelled")
            end
        end
        if GlobalBlip then
            RemoveBlip(GlobalBlip)
        end
    end)
end)

RegisterNetEvent("esx_hostage:Cancelled")
AddEventHandler("esx_hostage:Cancelled", function()
    Cancel = true
    ESX.Alert("Shoma Az Mahal Start Gerogan Giri Fasele Gereftid", "info")
    if Worek then
        ESX.Game.DeleteObject(Worek)
    end
end)

local Jobs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["justice"] = true,
    ["fbi"] = true,
    ["forces"] = true,
}

local Blips = {}

RegisterNetEvent("esx_hostage:AlertHostage")
AddEventHandler("esx_hostage:AlertHostage", function(id, position)
    local id = id
    if Jobs[PlayerData.job.name] then
        ESX.Alert("Gerogan Giri Dar Jaryan Ast", "lspd")
        Blips[id] = AddBlipForCoord(position.x, position.y, position.z)
        SetBlipSprite(Blips[id] , 161)
        SetBlipScale(Blips[id] , 2.0)
        SetBlipColour(Blips[id], 46)
        PulseBlip(Blips[id])
        SetTimeout(10*60*1000, function()
            RemoveBlip(Blips[id])
        end)
    end
end)

RegisterNetEvent("esx_hostage:HostageReleased")
AddEventHandler("esx_hostage:HostageReleased", function(id)
    local id = id
    if Jobs[PlayerData.job.name] and Blips[id] then
        ESX.Alert("Gerogan Giri Cancel Shod", "lspd")
        RemoveBlip(Blips[id])
        Blips[id] = nil
    end
end)

function CreateB()
    local Blip = GetEntityCoords(PlayerPedId())
    GlobalBlip = AddBlipForRadius(Blip.x, Blip.y, Blip.z, 45.0)
    SetBlipHighDetail(GlobalBlip, true)
    SetBlipColour(GlobalBlip, 2)
    SetBlipAlpha(GlobalBlip, 100)
    SetBlipAsShortRange(GlobalBlip, true)
    SetTimeout(15*60*1000, function()
        RemoveBlip(GlobalBlip)
    end)
end

RegisterNetEvent("esx_hostage:SetBagOverHead")
AddEventHandler("esx_hostage:SetBagOverHead", function(source)
    if not ESX then return end
    if not ESX.Game.DoesPlayerExistInArea(source) then return end
    if not IsEntityPlayingAnim(PlayerPedId(), "anim@move_m@prisoner_cuffed", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) then
        return TriggerServerEvent("esx_hostage:Rollback", true)
    end
    TriggerEvent('skinchanger:getSkin', function(skin)
        local skin = skin
        tempSkin = {}
        tempSkin["mask_1"] = skin["mask_1"]
        tempSkin["mask_2"] = skin["mask_2"]
        tempSkin["helmet_1"] = skin["helmet_1"]
        tempSkin["helmet_2"] = skin["helmet_2"]
        tempSkin["hair_1"] = skin["hair_1"]
        tempSkin["hair_2"] = skin["hair_2"]
        skin["mask_1"] = 0
        skin["mask_2"] = 0
        skin["helmet_1"] = -1
        skin["helmet_2"] = 0
        skin["hair_1"] = 0
        skin["hair_2"] = 0
        TriggerEvent('skinchanger:loadSkin', skin)
		exports.essentialmode:DisableControl(true)
		TriggerEvent("dpemote:enable", false)
		TriggerEvent("dpclothingAbuse", true)
		ESX.SetPlayerData("isSentenced", true)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'plastik', 0.9)
        TriggerServerEvent("esx_hostage:Finished")
        Cancel = false
        local GlobalCoord = GetEntityCoords(PlayerPedId())
        CreateB()
        TimeThread()
        ESX.Alert("Gerogan Giri Aghaz Shod, Ta 15 Daghighe Az Mahal Gerogan Giri Fasele Nagirid", "check")
        Worek = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(Worek, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
        Citizen.CreateThread(function()
            while DoesEntityExist(Worek) do
                Citizen.Wait(1000)
                local coord = GetEntityCoords(PlayerPedId())
                if ESX.GetDistance(coord, GlobalCoord) > 30.0 then
                    TriggerServerEvent("esx_hostage:Cancelled")
                end
            end
            skin["mask_1"] = tempSkin["mask_1"]
            skin["mask_2"] = tempSkin["mask_2"] 
            skin["helmet_1"] = tempSkin["helmet_1"]
            skin["helmet_2"] = tempSkin["helmet_2"]
            skin["hair_1"] = tempSkin["hair_1"]
            skin["hair_2"] = tempSkin["hair_2"]
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerServerEvent("esx_hostage:Rollback")
            --[[exports.essentialmode:DisableControl(false)
			TriggerEvent("dpemote:enable", true)
			TriggerEvent("dpclothingAbuse", false)
			ESX.SetPlayerData("isSentenced", false)]]
            if GlobalBlip then
                RemoveBlip(GlobalBlip)
            end
            Cancel = true
        end)
    end)
end)

function RunLoop(players, data)
    Citizen.CreateThread(function()
        while Condition do
            Citizen.Wait(3)
            local Break = false
            if #players + 1 ~= #ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0) then Break = true end
            for k, v in pairs(players) do
                local diss = ESX.Math.Round(GhadreMotlaq(#(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(v.id)))), 1)
                if diss <= 3.0 then
                    if Current and Current == v.id then
                        ESX.Game.Utils.DrawText3D(GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), "~g~("..diss.." Meters)", 0.6)
                        DrawMarker(27, GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 51, 255, 51, 150, false, true, 2, false, false, false, false)
                    else
                        ESX.Game.Utils.DrawText3D(GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), "("..diss.." Meters)", 0.6)
                        DrawMarker(27, GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 150, false, true, 2, false, false, false, false)
                    end
                else
                    Break = true
                    break
                end
            end
            if Break then 
                local aPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
                ESX.UI.Menu.CloseAll()
                if #aPlayers > 1 then
                    SelectPlayer(nil, aPlayers, data)
                end
                break 
            end
        end
    end)
end

function GhadreMotlaq(number)
    if number < 0 then
        return number * -1
    else
        return number
    end
end

function SortPlayers(ply)
    local temp = {}
    for k, v in pairs(ply) do
        if PlayerId() ~= v then
            table.insert(temp, {dis = GhadreMotlaq(#(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(v)))), id = v})
        end
    end
    if #temp == 1 then return {[1] = temp[1].id} end
    table.sort(temp, function(a, b)
        return a.dis < b.dis
    end)
    return temp
end

function SelectPlayer(cb, Players, data)
    ESX.UI.Menu.CloseAll()
    Condition = false
    Current = nil
    Citizen.Wait(5)
    local Players = SortPlayers(Players)
    if #Players == 1 then
        if cb then
            cb(Players[1])
        end
    elseif #Players > 1 then
        local element = {}
        for k, v in pairs(Players) do
            if not Current then
                Current = v.id
            end
            table.insert(element, {label = "("..ESX.Math.Round(v.dis, 1).." Meters), ID: "..GetPlayerServerId(v.id), value = v.id})
        end
        Condition = true
        RunLoop(Players, data)
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choose_person', {
            title    = 'Be Ki Mikhay Vasl Koni?',
            align    = 'top-left',
            elements = element,
        }, function(data, menu)
            if GhadreMotlaq(#(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(data.current.value)))) < 1.5 then
                if cb then
                    cb(data.current.value)
                else
                    closestPlayer = data.current.value
                    TriggerServerEvent("esx_hostage:SetBag", GetPlayerServerId(closestPlayer))
                end
                menu.close()
                Condition = false
            else
                ESX.Alert("Shoma Baraye Vasl Kardan Kit Bayad Nazdik Tar Shavid", "error")
            end
        end, function(data, menu)
            Condition = false
            menu.close()
        end, function(data, menu)
            Current = data.current.value
        end, function()
            Condition = false
        end)
    else
        ESX.Alert("Hich Kasi Nazdik Shoma Nist", "error")
    end
end

function TimeThread()
    local Seceonds = 59
    local Minutes  = 14
    Citizen.CreateThread(function()
        while true do
            if Cancel then
                break
            end
            if Seceonds < 10 then
                if Minutes < 10 then
                    ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~0"..Minutes..":0"..Seceonds)
                else
                    ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~"..Minutes..":0"..Seceonds)
                end
                if Seceonds == 0 then
                    if Minutes == 0 and Seceonds == 0 then
                        ESX.ShowMissionText("~g~Zaman Baghi Mande : ~g~0"..Minutes..":"..Seceonds)
                        Cancel = true
                        TriggerServerEvent("esx_hostage:TimerFinished", ESX.Game.GetPlayersToSend(30.0))
                        break
                    else
                        Minutes = Minutes - 1
                        Seceonds = 60
                    end
                end
            else
                if Minutes < 10 then
                    ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~0"..Minutes..":"..Seceonds)
                else
                    ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~"..Minutes..":"..Seceonds)
                end
            end
            Seceonds = Seceonds - 1
            Citizen.Wait(1000)
        end
    end)
end