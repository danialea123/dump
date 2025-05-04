CurrentID = nil
CurrentXP = 0
CurrentRank = 0
Leaderboard = nil
Players = {}
Player = nil
UIActive = true
ESX = nil
PlayerData = {}
Ready = false

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    
    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().gang == nil do
        Citizen.Wait(10)
    end 

    PlayerData = ESX.GetPlayerData()
    
    TriggerServerEvent("GangXPSys:sync")
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
    TriggerServerEvent("GangXPSys:sync")
    Wait(1000)
    if PlayerData.gang.name ~= 'nogang' then
        TriggerEvent("GangXPSys:update", CurrentXP, ESXT_GetRank(CurrentXP))
    end
end)

AddEventHandler('GangXPSys:isReady', function(cb)
    cb(Ready)
end)

RegisterNetEvent("GangXPSys:init")
AddEventHandler("GangXPSys:init", function(_id, _xp, _rank, gangs)
    local Ranks = CheckRanks()
    if #Ranks == 0 then
        CurrentID = tonumber(_id)
        CurrentXP = tonumber(_xp)
        CurrentRank = tonumber(_rank)

        local data = {
            xpm_init = true,
            xpm_config = Config,
            currentID = CurrentID,
            xp = CurrentXP
        }
    
        if Config.Leaderboard.Enabled and gangs then
            data.leaderboard = true
            data.players = gangs

            for k, v in pairs(gangs) do
                if v.gang_name == PlayerData.gang.name then
                    Player = v
                end
            end        
    
            Players = gangs                       
        end
    
        SendNUIMessage(data)
    
        StatSetInt("MPPLY_GLOBALXP", CurrentXP, 1)

        Ready = true
    end
end)

RegisterNetEvent("GangXPSys:update")
AddEventHandler("GangXPSys:update", function(_xp, _rank)
    local oldRank = CurrentRank
    local newRank = _rank
    local newXP = _xp

    SendNUIMessage({
        xpm_set = true,
        xp = newXP
    })

    CurrentXP = newXP
    CurrentRank = newRank
end)

if Config.Leaderboard.Enabled then
    RegisterNetEvent("GangXPSys:setPlayerData")
    AddEventHandler("GangXPSys:setPlayerData", function(gangs)
        for k, v in pairs(gangs) do
            table.insert(Players, v)

            if v.gang_name == PlayerData.gang.name then
                Player = v
            end     
        end

        SendNUIMessage({
            xpm_updateleaderboard = true,
            xpm_players = gangs
        })
    end)
end

function LimitXP(XPCheck)
    local Max = tonumber(Config.Ranks[#Config.Ranks])

    if XPCheck > Max then
        XPCheck = Max
    elseif XPCheck < 0 then
        XPCheck = 0
    end

    return tonumber(XPCheck)
end

function CheckRanks()
    local Limit = #Config.Ranks
    local InValid = {}

    for i = 1, Limit do
        local RankXP = Config.Ranks[i]

        if not IsInt(RankXP) then
            table.insert(InValid, _('err_lvl_check', i,  RankXP))
        end
        
    end

    return InValid
end

function SortLeaderboard(players, order)
    if order == nil then
        order = Config.Leaderboard.Order
    end

    if order == "rank" then
        table.sort(players, function(a,b)
            return a.rank > b.rank
        end)
    elseif order == "id" then
        table.sort(players, function(a,b)
            return a.id > b.id
        end)                      
    elseif order == "name" then
        table.sort(players, function(a,b)
            return a.name < b.name
        end)                
    end    
end

function IsInt(XPCheck)
    XPCheck = tonumber(XPCheck)
    if XPCheck and XPCheck == math.floor(XPCheck) then
        return true
    end
    return false
end

function UpdateXP(_xp, init, GangName)
    _xp = tonumber(_xp)

    local points = CurrentXP + _xp
    local max = ESXT_GetMaxXP()

    if init then
        points = _xp
    end

    points = LimitXP(points)

    local rank = ESXT_GetRank(points)
    ESX.TriggerServerCallback('GangXPSys:setXP', function()
    
    end, points, rank, GangName, _xp)
end


function ESXT_SetInitial(XPInit, GangName)
    local GoalXP = tonumber(XPInit)
    if not GoalXP or (GoalXP < 0 or GoalXP > ESXT_GetMaxXP()) then
        return
    end    
    UpdateXP(tonumber(GoalXP), true, GangName)
end

function ESXT_SetRank(Rank, GangName)
    local GoalRank = tonumber(Rank)

    if not GoalRank then
        return
    end

    local XPAdd = tonumber(Config.Ranks[GoalRank]) - CurrentXP

    ESXT_Add(XPAdd, GangName)
end

function ESXT_Add(XPAdd, GangName)
    if not tonumber(XPAdd) then
        return
    end       
    UpdateXP(tonumber(XPAdd), false, GangName)
end

function ESXT_Remove(XPRemove, GangName)
    if not tonumber(XPRemove) then
        return
    end       
    UpdateXP(-(tonumber(XPRemove)), false, GangName)
end

function ESXT_GetRank(_xp)

    if _xp == nil then
        return CurrentRank
    end

    local len = #Config.Ranks
    for rank = 1, len do
        if rank < len then
            if Config.Ranks[rank + 1] > tonumber(_xp) then
                return rank
            end
        else
            return rank
        end
    end
end	

function ESXT_GetXPToNextRank()
    local currentRank = ESXT_GetRank()

    return Config.Ranks[currentRank + 1] - tonumber(CurrentXP)   
end


function ESXT_GetXPToRank(Rank)
    local GoalRank = tonumber(Rank)
    if not GoalRank or (GoalRank < 1 or GoalRank > #Config.Ranks) then
        return
    end

    local goalXP = tonumber(Config.Ranks[GoalRankl])

    return goalXP - CurrentXP
end

function ESXT_GetXP()
    return tonumber(CurrentXP)
end

exports("ESXT_GetXP", ESXT_GetXP)

function ESXT_GetMaxXP()
    return Config.Ranks[#Config.Ranks]
end

function ESXT_GetMaxRank()
    return #Config.Ranks
end

function ESXT_ShowUI(update)
    UIActive = true

    if update ~= nil then
        TriggerServerEvent("GangXPSys:getGangsData")
    end
    
    SendNUIMessage({
        xpm_show = true
    })    
end

function ESXT_HideUI()
    UIActive = false
        
    SendNUIMessage({
        xpm_hide = true
    })      
end

exports("GetRank", function()
    return CurrentRank
end)

function ESXT_TimeoutUI(update)
    UIActive = true

    if update ~= nil then
        TriggerServerEvent("GangXPSys:getGangsData")
    end
    
    SendNUIMessage({
        xpm_display = true
    })    
end

function ESXT_SortLeaderboard(type)
    SendNUIMessage({
        xpm_lb_sort = true,
        xpm_lb_order = "xp"
    })   
end

local Timer = 0

RegisterKey("Z", false, function()
    if PlayerData.gang.name ~= 'nogang' then
        if GetGameTimer() - Timer > 1000 then
            Timer = GetGameTimer()  
            UIActive = not UIActive
            if UIActive then
                SendNUIMessage({
                    xpm_show = true
                })     
            else
                SendNUIMessage({
                    xpm_hide = true
                })                
            end
        end
    end
end)

RegisterNetEvent("GangXPSys:updateUI")
AddEventHandler("GangXPSys:updateUI", function(_xp)
    CurrentXP = tonumber(_xp)

    SendNUIMessage({
        xpm_set = true,
        xp = CurrentXP
    })
end)

RegisterNetEvent("GangXPSys:SetInitial")
AddEventHandler('GangXPSys:SetInitial', function(XP, GangName)
    ESXT_SetInitial(XP, GangName)
end)

RegisterNetEvent("GangXPSys:Add")
AddEventHandler('GangXPSys:Add', function(XP, GangName)
    ESXT_Add(XP, GangName)
end)

RegisterNetEvent("GangXPSys:Remove")
AddEventHandler('GangXPSys:Remove', function(XP, GangName)
    ESXT_Remove(XP, GangName)
end)

RegisterNetEvent("GangXPSys:SetRank")
AddEventHandler('GangXPSys:SetRank', function(Rank, GangName)
    ESXT_SetRank(Rank, GangName)
end)

--[[
RegisterNetEvent('addGangCarXP')
AddEventHandler('addGangCarXP', function(model, GangName)
    local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

    ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle)
		if DoesEntityExist(vehicle) then
			SetEntityVisible(vehicle, false, false)
			SetEntityCollision(vehicle, false)
			
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            local newPlate = exports.esx_vehicleshop:GeneratePlate()
			vehicleProps.plate = newPlate
            TriggerServerEvent('GangXPSys:giveGangVehicle', vehicleProps, GangName)
			ESX.Game.DeleteVehicle(vehicle)				
		end		
	end)
end)]]