---@diagnostic disable: undefined-field, missing-parameter, lowercase-global, undefined-global, inject-field, need-check-nil
ESX = nil
local PlayerData = nil
local timer = 0
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
  while ESX.GetPlayerData().job == nil do 
    Citizen.Wait(100)
  end
  PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
    LimitedWeapons()
    NoWeapons()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
  if not ESX then return end
  if ESX.Game.DoesPlayerExistInArea(id) then
    local pid = GetPlayerFromServerId(id)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
      TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
        args = { name, message }
      })
    end
  end
end)

RegisterNetEvent('esx:playerLevelChanged')
AddEventHandler('esx:playerLevelChanged', function(lvl)
    if GetInvokingResource() then return end
    ESX.PlayerData.Level = lvl
    ESX.PlayerData.XP = 0
    PlayerData.Level = lvl
    PlayerData.XP = 0
    ESX.SetPlayerData("Level", lvl)
    ESX.SetPlayerData("XP", 0)
    if lvl ~= 0 then
        ResetTeam() 
    end
    Citizen.Wait(5000)
    LimitedWeapons()
    NoWeapons()
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
  if not ESX then return end
  if ESX.Game.DoesPlayerExistInArea(id) then
    local pid = GetPlayerFromServerId(id)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
      TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {name..": ", message}
      })
    end
  end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
  if not ESX then return end
  if ESX.Game.DoesPlayerExistInArea(id) then
    local pid = GetPlayerFromServerId(id)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
      TriggerEvent('chat:addMessage', { args = { '^1((' .. name .. '))', "^1 " .. message } })
    end
  end
end)

RegisterCommand('like',function()
    if ESX.GetPlayerData().isSentenced then return end
    if ESX.isDead() then return end
    ExecuteCommand('e thumbsup')
end)

RegisterCommand('dlike',function()
    if ESX.GetPlayerData().isSentenced then return end
    if ESX.isDead() then return end
    loadanimdict('anim@arena@celeb@flat@solo@no_props@')
    TaskPlayAnim(PlayerPedId(), 'anim@arena@celeb@flat@solo@no_props@', 'thumbs_down_a_player_a', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
end)

RegisterCommand('s', function(source, args)
    local player = PlayerPedId()
    if args[1] then
        if GetGameTimer() - timer > 5000 then
            TriggerServerEvent('esx_rpchat:s', table.concat(args," "), ESX.Game.GetPlayersToSend(100))
            timer = GetGameTimer()
        else
            ESX.Alert("Lotfan Spam Nakonid", "error")
        end
    else
        ESX.Alert('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.', "error")
    end
end, false)

RegisterCommand('do', function(source, args)
    local player = PlayerPedId()
    if args[1] then
        if GetGameTimer() - timer > 5000 then
            TriggerServerEvent('esx_rpchat:do', table.concat(args," "), ESX.Game.GetPlayersToSend(25))
            timer = GetGameTimer()
        else
            ESX.Alert("Lotfan Spam Nakonid", "error")
        end
    else
        ESX.Alert('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.', "error")
    end
end, false)

RegisterCommand('ooc', function(source, args)
    local player = PlayerPedId()
    if args[1] then
        if GetGameTimer() - timer > 5000 then
            TriggerServerEvent('esx_rpchat:ooc', table.concat(args," "), ESX.Game.GetPlayersToSend(100))
            timer = GetGameTimer()
        else
            ESX.Alert("Lotfan Spam Nakonid", "error")
        end
    else
        ESX.Alert('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.', "error")
    end
end, false)

RegisterCommand('b', function(source, args)
    local player = PlayerPedId()
    if args[1] then
        if GetGameTimer() - timer > 5000 then
            TriggerServerEvent('esx_rpchat:ooc', table.concat(args," "), ESX.Game.GetPlayersToSend(100))
            timer = GetGameTimer()
        else
            ESX.Alert("Lotfan Spam Nakonid", "error")
        end
    else
        ESX.Alert('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.', "error")
    end
end, false)

RegisterNetEvent('sendProximityMessageS')
AddEventHandler('sendProximityMessageS', function(id, name, message)
  if not ESX then return end
  if ESX.Game.DoesPlayerExistInArea(id) then
    local pid = GetPlayerFromServerId(id)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(pid)), true) < 70.0 then
      TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 25, 0, 0.4); border-radius: 3px;"><i class="fas fa-globe"></i> ({0}) Faryad Mizane:<br>  {1}</div>',
        args = { id, message}
      })
    end
  end
end)

RegisterCommand('mp', function(source, args)
    local player = PlayerPedId()
    if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "fbi" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "forces" or PlayerData.job.name == "mechanic" or PlayerData.job.name == "justice" or PlayerData.job.name == "benny" or PlayerData.job.name == "medic" then
        if args[1] then
            if GetGameTimer() - timer > 5000 then
                TriggerServerEvent('esx_rpchat:mp', table.concat(args," "), ESX.Game.GetPlayersToSend(100))
                timer = GetGameTimer()
            else
                ESX.Alert("Lotfan Spam Nakonid", "error")
            end
        else
            ESX.Alert('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.', "error")
        end
    else
        ESX.Alert('~r~~h~Shoma Ozv Hich Organi nistid!', "error")
    end
end, false)

RegisterNetEvent('sendProximityMessageMP')
AddEventHandler('sendProximityMessageMP', function(id, message, j)
    if not ESX then return end
        if ESX.Game.DoesPlayerExistInArea(id) then
        local pid = GetPlayerFromServerId(id)
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(pid)), false) < 85.0 then
            if j == "ambulance" then
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 153, 150, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> Bolandgu Ambulance({0}):<br> {1}</div>',
                    args = { id, message }
                })
            elseif j == "medic" then
                    TriggerEvent('chat:addMessage', {
                        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 153, 150, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> Bolandgu Medic({0}):<br> {1}</div>',
                        args = { id, message }
                    })
            elseif j == "police" then 
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> Bolandgu Police({0}):<br> {1}</div>',
                    args = { id, message }
                })
            elseif j == "sheriff" then
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 153, 51, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> Bolandgu Sheriff({0}):<br> {1}</div>',
                    args = { id, message }
                })
            elseif j == "fbi" then
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> Bolandgu FBI({0}):<br> {1}</div>',
                    args = { id, message }
                })
            elseif j == "mechanic" then 
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(220, 120, 0, 0.7);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> Bolandgu Mechanic({0}):<br> {1}</div>',
                    args = { id, message }
                })
            elseif j == "forces" then 
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(153, 51, 250, 0.7);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> Bolandgu Special Force({0}):<br> {1}</div>',
                    args = { id, message }
                })
            elseif j == "justice" then
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 153, 51, 0.7);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> Bolandgu Justice({0}):<br> {1}</div>',
                    args = { id, message }
                })
            elseif j == "benny" then
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(220, 120, 0, 0.7);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> Bolandgu Benny({0}):<br> {1}</div>',
                    args = { id, message }
                })
            end
        end
    end
end)

RegisterCommand('admins',function(source)
    ESX.TriggerServerCallback('getadminsinfo', function(info,cc)
        local elements = {}
        for i=1, #info, 1 do
            table.insert(elements, {
                label = "Admin "..info[i].perm.." - "..info[i].name.."("..info[i].source..") - "..info[i].vaziat
            })
        end
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'test',
        {
            title    = 'Admin Haye Online ('..cc..') Nafar',
            align    = 'center',
            elements = elements
        },function(data2, menu2)  
                
        end,function(data2, menu2)
            menu2.close()
        end)
    end)
end)

RegisterCommand('responders',function(source)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
            ESX.TriggerServerCallback('esx:getResponders', function(info,cc)
                local elements = {}
                for i=1, #info, 1 do
                    table.insert(elements, {
                        label = "Responder "..info[i].perm.." - "..info[i].name.."("..info[i].source..") - "..info[i].vaziat
                    })
                end
                ESX.UI.Menu.CloseAll()
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'test',
                {
                    title    = 'Responder Haye Online ('..cc..') Nafar',
                    align    = 'center',
                    elements = elements
                },function(data2, menu2)  
                        
                end,function(data2, menu2)
                    menu2.close()
                end)
            end)
        end
    end)
end)

local Blips = {}
local globalArray = {}
local gangPos = {}
local area

RegisterNetEvent('gangs:GangPublicBlip')
AddEventHandler('gangs:GangPublicBlip', function(GangPosjson)
    area = nil
    gangPos = {}
    globalArray = GangPosjson
    for k, v in pairs(Blips) do
        RemoveBlip(v)
    end
    Blips = {}
    for k, v in pairs(GangPosjson) do
        local Blip = json.decode(v.blip)
        table.insert(gangPos, vector3(Blip.x, Blip.y, Blip.z))
        Blips[k] = AddBlipForRadius(Blip.x, Blip.y, Blip.z, 50.0)
        SetBlipHighDetail(Blips[k], true)
        SetBlipColour(Blips[k], 17)
        SetBlipAlpha(Blips[k], 100)
        SetBlipAsShortRange(Blips[k], true)
        if v.circle == 0 then
            SetBlipAlpha(Blips[k], 0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        if area == nil then
            for k, v in pairs(gangPos) do
                if GetDistanceBetweenCoords(coords, v, false) <= 30.0 then
                    area = k
                    StartInNCZ()
                    break
                end
            end
        elseif GetDistanceBetweenCoords(coords, gangPos[area], false) >= 30.0 then
            area = nil
        end
        Citizen.Wait(1000)
    end
end)

function StartInNCZ()
	if area ~= nil then
		Citizen.CreateThread(function()
			while area ~= nil do
                DisablePlayerFiring(PlayerPedId(), true)
                DisableControlAction(0,24,true) -- disable attack
                --[[DisableControlAction(0,47,false) -- disable weapon]]
                DisableControlAction(0,58,true) -- disable weapon
                DisableControlAction(0,263,true) -- disable melee
                DisableControlAction(0,264,true) -- disable melee
                DisableControlAction(0,257,true) -- disable melee
                DisableControlAction(0,140,true) -- disable melee
                DisableControlAction(0,141,true) -- disable melee
                DisableControlAction(0,142,true) -- disable melee
                DisableControlAction(0,143,true) -- disable melee
                DisableControlAction(0, 45, true)
                DisableControlAction(0, 69, true) -- Melee Attack 1
                DisableControlAction(0, 70, true)
                DisableControlAction(0, 92, true)
				Citizen.Wait(1)
			end
		end)
	end
end

local used = false

RegisterCommand("gangblips", function()
    if ESX.GetPlayerData().aduty and ESX.GetPlayerData().admin and not used then
        used = true
        local pussy = {}
        Citizen.CreateThread(HideOtherBlips)
        Citizen.Wait(1500)
        for k, v in pairs(globalArray) do
            local Blip = json.decode(v.blip)
            pussy[k] = AddBlipForCoord(Blip.x, Blip.y, Blip.z)
            SetBlipSprite (pussy[k], 409)
            SetBlipScale  (pussy[k], 1.2)
            SetBlipDisplay(pussy[k], 4)
            SetBlipColour (pussy[k], 33)
            SetBlipAsShortRange(pussy[k], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(k)
            EndTextCommandSetBlipName(pussy[k])
        end
        Citizen.SetTimeout(30000, function()
            used = false
            for k, v in pairs(pussy) do 
                RemoveBlip(v)
            end
        end)
        ESX.Alert("Activated", "check")
    end
end)

function HideOtherBlips()
    local blips = getAllBlips()
    local savedAlpha = {}
    for k, v in pairs(blips) do
        savedAlpha[v] = GetBlipAlpha(v)
        SetBlipAlpha(v, 0)
    end
    Citizen.Wait(32000)
    for k, v in pairs(blips) do
        SetBlipAlpha(v, savedAlpha[v])
    end
end

function getAllBlips()
    local blips = {}
    for k = 0, 826, 1 do 
        local blip = GetFirstBlipInfoId(k)
        if DoesBlipExist(blip) then
            table.insert(blips, blip)
            while true do
                local blip = GetNextBlipInfoId(k)
                if DoesBlipExist(blip) then
                    table.insert(blips, blip)
                else
                    break
                end
            end
        end
    end
    return blips
end

local Levels = {
    [0]  = 3,
    [1]  = 3,
    [2]  = 6,
    [3]  = 12,
    [4]  = 15,
    [5]  = 15,
    [6]  = 17,
    [7]  = 20,
    [8]  = 20,
    [9]  = 22,
    [10] = 22,
    [11] = 25,
    [12] = 25,
    [13] = 27,
    [14] = 30,
    [15] = 35,
    [16] = 40,
    [17] = 45,
    [18] = 50,
    [19] = 70,
    [20] = 100,
    [21] = 120,
    [22] = 140,
    [23] = 160,
    [24] = 180,
    [25] = 200,
    [26] = 220,
    [27] = 240,
    [28] = 260,
    [29] = 280,
    [30] = 300,
    [31] = 340,
    [32] = 380,
    [33] = 420,
    [34] = 460,
    [35] = 500,
    [36] = 540,
    [37] = 580,
    [38] = 620,
    [39] = 660,
    [40] = 700,
}

RegisterNetEvent('esx_Quest:AddXP')
AddEventHandler('esx_Quest:AddXP', function(AddedXP)
    if GetInvokingResource() then return end
    if PlayerData.XP + AddedXP >= Levels[PlayerData.Level + 1] then
        repeat
            CreateRankBar(0, Levels[PlayerData.Level + 1], PlayerData.XP, Levels[PlayerData.Level + 1], PlayerData.Level)
            PlayerData.Level = PlayerData.Level + 1
            AddedXP = PlayerData.XP + AddedXP - Levels[PlayerData.Level]
            PlayerData.XP = 0
            TriggerEvent("RankUpMessage", "Self Level Up Complete", 4000)
        until PlayerData.XP + AddedXP < Levels[PlayerData.Level + 1]
        if AddedXP > 0 then
            PlayerData.XP = PlayerData.XP + AddedXP
        end
        CreateRankBar(0, Levels[PlayerData.Level + 1], 0, PlayerData.XP, PlayerData.Level)
    else
        CreateRankBar(0, Levels[PlayerData.Level + 1], PlayerData.XP, PlayerData.XP + AddedXP, PlayerData.Level)
        PlayerData.XP = PlayerData.XP + AddedXP
    end
    local data = GetMetaData()
    PlayerData.Level = data.Level
    PlayerData.XP = data.XP
end)

RegisterKey("I", false, function()
    if PlayerData.Level and PlayerData.XP then
        CreateRankBar(0, Levels[PlayerData.Level + 1], PlayerData.XP, PlayerData.XP, PlayerData.Level)
    end
end)

function CreateRankBar(XP_StartLimit_RankBar, XP_EndLimit_RankBar, playersPreviousXP, playersCurrentXP, CurrentPlayerLevel, TakingAwayXP)
    RankBarColor = TakingAwayXP and 6 or 116
    if not HasHudScaleformLoaded(19) then
            RequestHudScaleform(19)
        while not HasHudScaleformLoaded(19) do
            Wait(1)
        end
    end
    BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
    PushScaleformMovieFunctionParameterInt(RankBarColor)
    EndScaleformMovieMethodReturn()
    BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
    PushScaleformMovieFunctionParameterInt(XP_StartLimit_RankBar)
    PushScaleformMovieFunctionParameterInt(XP_EndLimit_RankBar)
    PushScaleformMovieFunctionParameterInt(playersPreviousXP)
    PushScaleformMovieFunctionParameterInt(playersCurrentXP)
    PushScaleformMovieFunctionParameterInt(CurrentPlayerLevel)
    PushScaleformMovieFunctionParameterInt(100)
    EndScaleformMovieMethodReturn()
end

RegisterNetEvent('RankUpMessage')
AddEventHandler('RankUpMessage', function(MsgText, setCounter)
	local scaleform = RequestScaleformMovie("mp_big_message_freemode")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	BeginTextComponent("STRING")
	AddTextComponentString(MsgText)
	EndTextComponent()
	PopScaleformMovieFunctionVoid()	
	local counter = 0
	local maxCounter = (setCounter or 200)
	while counter < maxCounter do
		counter = counter + 1
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:NoticeDropToNearbyPlayers')
AddEventHandler('esx:NoticeDropToNearbyPlayers', function(name, source, pos, identifier, reason)
	local PlayerPed = PlayerPedId()
	local coords	= GetEntityCoords(PlayerPed)
	local dist 		= GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords, true)
	local Thread	= true

	if dist <= 100.0 then
		TriggerEvent('chat:addMessage', {
			args = { "^5Disconnect Message", " (^3[" .. source .. "] " .. name .."^0) Server ro Tark kard be dalil: " .. reason }
		})
	end

	local function Display()
		if Thread then
			local pcoords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pcoords.x, pcoords.y, pcoords.z, true) < 35.0 then
				ESX.Game.Utils.DrawText3D({x = pos.x, y = pos.y, z = pos.z + 0.15}, name .. " Left Game", 1, 255, 0, 0)
				ESX.Game.Utils.DrawText3D({x = pos.x, y = pos.y, z = pos.z + 0.00}, "ID: "..source.." ("..identifier..")\nReason: "..reason, 1, 255, 255, 255)
				SetTimeout(0, Display)
			else
				SetTimeout(3000, Display)
			end
		end
	end
	SetTimeout(0, Display)
	SetTimeout(20 * 1000, function() Thread = false end)
end)

RegisterNetEvent('esx:NearbyAdmin')
AddEventHandler('esx:NearbyAdmin', function(name, source, pos, duty)
    local PlayerPed = PlayerPedId()
	local coords	= GetEntityCoords(PlayerPed)
	local dist 		= GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords, true)
	local Duty		= duty and 'On' or 'Off'
    if dist <= 100.0 then
        TriggerEvent('chat:addMessage', {
            args = { "^5Admin Duty", " (^3[" .. source .. "] " .. name .. "^0) " .. Duty .. '-Duty Shod!' }
        })
    end
end)

local Guns = {
    ["WEAPON_PISTOL"]        = true,
    ["WEAPON_PISTOL_MK2"]    = true,
    ["WEAPON_COMBATPISTOL"]  = true,
    ["WEAPON_HEAVYPISTOL"]   = true,
    ["WEAPON_STUNGUN"]       = true,
    ["WEAPON_PISTOL50"]      = true,
    ["WEAPON_SNSPISTOL"]     = true,
    ["WEAPON_SNSPISTOL_MK2"] = true,
    ["WEAPON_VINTAGEPISTOL"] = true,
    ["WEAPON_FLAREGUN"]      = true,
    ["WEAPON_MARKSMANPISTOL"]= true,
    ["WEAPON_REVOLVER"]      = true,
    ["WEAPON_REVOLVER_MK2"]  = true,
    ["WEAPON_APPISTOL"]      = true,
    ["WEAPON_RAYPISTOL"]     = true,
    ["WEAPON_CERAMICPISTOL"] = true,
    ["WEAPON_NAVYREVOLVER"]  = true,
    ["WEAPON_GADGETPISTOL"]  = true,
    ["WEAPON_DOUBLEACTION"]  = true,
    ["WEAPON_UNARMED"]       = true,
    ["WEAPON_BAT"]           = true,
    ["WEAPON_KNIFE"]         = true,
    ["WEAPON_MUSKET"]        = true,
}

-- RegisterNetEvent('PaintBall:Start')
-- AddEventHandler('PaintBall:Start', function()
--     if GetInvokingResource() then return end
--     Citizen.Wait(5000)
--     PlayerData.Level = 5
--     PlayerData.XP = 3
-- end)

-- RegisterNetEvent('PaintBall:End')
-- AddEventHandler('PaintBall:End', function()
--     if GetInvokingResource() then return end
--     local data = GetMetaData()
--     PlayerData.Level = data.Level
--     PlayerData.XP = data.XP
--     LimitedWeapons()
--     NoWeapons()
-- end)

-- RegisterNetEvent('capture:JoinPlayerInCapIns')
-- AddEventHandler('capture:JoinPlayerInCapIns', function()
--     if GetInvokingResource() then return end
--     PlayerData.Level = 5
--     PlayerData.XP = 3
-- end)

-- RegisterNetEvent('capture:CaptureEnded')
-- AddEventHandler('capture:CaptureEnded', function()
--     if GetInvokingResource() then return end
--     local data = GetMetaData()
--     PlayerData.Level = data.Level
--     PlayerData.XP = data.XP
--     LimitedWeapons()
--     NoWeapons()
-- end)

function GetMetaData()
	local p = promise.new()
	ESX.TriggerServerCallback('esx:GetPlayerSelfData',function(cb)
		p:resolve(cb)
	end)
	return Citizen.Await(p)
end

function LimitedWeapons()
    Citizen.CreateThread(function()
        while PlayerData.Level == 2 do
            Citizen.Wait(500)
            local CanEquip = false
            for k, v in pairs(Guns) do
                if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(k) then
                    CanEquip = true
                end
            end
            if not CanEquip then
                Citizen.Wait(75)
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                Citizen.Wait(75)
                --exports['pNotify']:Alert("ERROR", "<span style='color:#c7c7c7'> Level Shoma 1 Ast! Faghat Az Pistol Mitavanid Estefade Konid <span style='color:#ff0000'></span>!", 5000, 'error')
                exports['esx_notify']:Notification({
                    title = 'INFO',
                    message = 'Level Shoma 2 Ast! Faghat Az Pistol Mitavanid Estefade Konid',
                    image = 'https://media.discordapp.net/attachments/766026362594656286/912334083193962526/ic_fluent_info_24_filled.png',
                    timeout = 6000,
                    bgColor = 'rgba(0, 17, 255, 0.4)'
                })
            end
        end
    end)
end

function NoWeapons()
    Citizen.CreateThread(function()
        while PlayerData.Level == 0 or PlayerData.Level == 1 do
            Citizen.Wait(200)
            DisableControlAction(0, 37, true)
            DisableControlAction(1, 37, true)
            DisableControlAction(2, 37, true)
            SetPedCanSwitchWeapon(PlayerPedId(), false)
            if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_UNARMED") and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_MUSKET") and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_KNIFE") then
                Citizen.Wait(75)
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                Citizen.Wait(75)
                --exports['pNotify']:Alert("ERROR", "<span style='color:#c7c7c7'> Level Shoma 0 Ast! Nemitavanid Az Gun Estefade Konid <span style='color:#ff0000'></span>!", 10000, 'error')
                exports['esx_notify']:Notification({
                    title = 'INFO',
                    message = 'Level Shoma 0 Ya 1 Ast! Nemitavanid Az Aslahe Estefade Konid',
                    image = 'https://media.discordapp.net/attachments/766026362594656286/912334083193962526/ic_fluent_info_24_filled.png',
                    timeout = 6000,
                    bgColor = 'rgba(0, 17, 255, 0.4)'
                })
            end
        end
    end)
end

--[[RegisterNetEvent("esx_exclude:RemoveGunAccess")
AddEventHandler("esx_exclude:RemoveGunAccess", function()
    if GetInvokingResource() then return end
    fightBan = true
end)]]

function ResetTeam()
    local my_team = 5
    local relgroup=GetHashKey("PLAYER")
    local myself=PlayerId()
    SetPlayerTeam(myself,my_team)
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(),true,true)
    for k, i in pairs(GetActivePlayers()) do
        SetPlayerTeam(i,4)
    end
    Citizen.Wait(500)
    for i=0,255 do
        if i~=myself then
            local ped=GetPlayerPed(i)
            local team=GetPlayerTeam(i)
            local friend=(team==my_team)
            SetEntityCanBeDamagedByRelationshipGroup(ped,true,relgroup)
            SetPedCanBeTargettedByTeam(ped,team,true)
        end
    end
    Citizen.Wait(500)
end

Citizen.CreateThread(function()
    while not PlayerData do Citizen.Wait(2000) end
    while true do
        Citizen.Wait(500)
        if PlayerData.Level == 0 or fightBan then
            if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_UNARMED") then 
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
            end
            local my_team = 5
            local relgroup=GetHashKey("PLAYER")
            local myself=PlayerId()
            SetPlayerTeam(myself,my_team)
            NetworkSetFriendlyFireOption(true)
            SetCanAttackFriendly(PlayerPedId(),true,true)
            for k, i in pairs(GetActivePlayers()) do
                SetPlayerTeam(i,5)
            end
            Citizen.Wait(500)
            for i=0,255 do
                if i~=myself then
                    local ped=GetPlayerPed(i)
                    local team=GetPlayerTeam(i)
                    local friend=(team==my_team)
                    SetEntityCanBeDamagedByRelationshipGroup(ped,not friend,relgroup)
                    SetPedCanBeTargettedByTeam(ped,team,false)
                end
            end
            Citizen.Wait(500)
        else
            NetworkSetFriendlyFireOption(true)
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()

    TriggerEvent('chat:addSuggestion', '/ooc', 'OOC', {
  
      { name="Text", help="Text" }
  
    })
  
    TriggerEvent('chat:addSuggestion', '/b', 'OOC', {
  
      { name="Text", help="Text" }
  
    })
  
    TriggerEvent('chat:addSuggestion', '/s', 'Faryad zadan', {
  
      { name="Text", help="Text" }
  
    })
  
  end)

  
function loadanimdict(dictname)

    if not HasAnimDictLoaded(dictname) then

        RequestAnimDict(dictname)

        while not HasAnimDictLoaded(dictname) do

            Citizen.Wait(1)

        end

    end

end

AddEventHandler("esx:DrugUsed", function()
    timer = 0
end)

--[[RegisterNetEvent("esx:newPlayerConfirmed")
AddEventHandler("esx:newPlayerConfirmed", function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            ESX.ShowMissionText("~y~/help ~w~-~g~ Menu Amoozeshi Server")
        end
    end)
end)]]

local Coords = {
    vector3(71.0,-1388.38,29.38),
    vector4(-715.6,-146.62,37.42,201.68),
    vector3(-164.61,-311.47,39.73),
    vector3(429.92,-810.48,29.49),
    vector3(-820.78,-1067.67,11.33),
    vector3(-1446.03,-229.78,49.81),
    vector3(4.73,6506.32,31.88),
    vector3(130.3,-215.2,54.56),
    vector3(1698.99,4818.95,42.07),
    vector3(613.95,2753.52,42.09),
    vector3(1201.06,2714.7,38.22),
    vector3(-1201.37,-772.76,17.32),
    vector3(-3165.83,1051.99,20.86),
    vector3(-1101.1,2716.72,19.11),
}

local Nie = false
Config = Config or {}
Config.Size          = { x = 1.1, y = 1.1, z = 1.1 }
Config.Color         = { r = 40, g = 50, b = 200 }
Config.Type          = 2

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        local Skip = true
        for k, v in pairs(Coords) do
            local dis = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v, true)
            if dis < 3.0 and (PlayerData.gang.grade == 12 or PlayerData.gang.grade == 13) then
                Skip = false
                Nie = true
                DrawMarker(20, v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Set Kardan Lebas Gang')
            end
        end
        if Skip then Citizen.Wait(500) Nie = false end
    end 
end)

local Sellable = {
	[GetHashKey('mp_m_freemode_01')] = {
		["tshirt_1"] = {
			[213] = true,
			[225] = true,
			[245] = true,
            [242] = true,
		},
		["bags_1"] = {
			[124] = true,
			[125] = true,
            [120] = true,
		},
		["bproof_1"] = {
			[72] = true,
		},
		["chain_1"] = {
			[167] = true,
			[197] = true,
			[202] = true,
			[203] = true,
			[214] = true,
            [178] = true,
            [221] = true,
		},
        ["torso_1"] = {
            [645] = true,
        }
	},
	[GetHashKey('mp_f_freemode_01')] = {
		["tshirt_1"] = {
			[325] = true,
            [311] = true,
		},
		["bags_1"] = {
			[148] = true,
		},
		["bproof_1"] = {
			[59] = true,
			[114]= true,
		},
		["chain_1"] = {
			[199] = true,
			[202] = true,
			[203] = true,
            [208] = true,
            [205] = true,
		},
        ["torso_1"] = {
            [688] = true,
        }
	},
}

local Naked = {
    [GetHashKey('mp_m_freemode_01')] = {
		shoes_1 = 34,
		pants_1 = 14,
		torso_1 = 15,
		arms = 15,
		tshirt_1 = 15,
        mask_1 = 0,
        helmet_1 = -1,
        bproof_1 = 0,
        watches_1 = -1,
        bracelets_1 = -1,
        decals_1 = 0,
        bags_1 = 0,
        chain_1 = 0,
        glasses_1 = 0,
        ears_1 = -1,
    },
    [GetHashKey('mp_f_freemode_01')] = {
		shoes_1 = 35,
		pants_1 = 14,
		torso_1 = 15,
		arms = 15,
		tshirt_1 = 15,
        mask_1 = 0,
        helmet_1 = -1,
        bproof_1 = 0,
        watches_1 = -1,
        bracelets_1 = -1,
        decals_1 = 0,
        bags_1 = 0,
        chain_1 = 0,
        glasses_1 = 5,
        ears_1 = -1,
    }
}

AddEventHandler("onKeyDown", function(key)
    if key == "e" then
        if Nie then
            ESX.TriggerServerCallback('getganggrade', function(foundStore, foundGang)
                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'doyowannasave',
                    {
                        title = 'Aya Mayelid ke Lebas Khod Ra Baraye Gang Save Konid?',
                        align = 'top-left',
                        elements = {
                            {label = 'Yes', value = 'yes'},
                            {label = 'No' , value = 'no' }
                        }
                    }, function(data2,menu2)
                        if data2.current.value == 'yes' then
                            menu2.close()

                        local elements = {}
                        if foundGang then
                            table.insert(elements,{label = 'Zakhire in Lebas Baraye Gang', value = 'buyforgang'})
                        end

                        ESX.UI.Menu.Open(
                            'default', GetCurrentResourceName(), 'ask_for_save',
                            {
                                title = 'Dar koja Zakhire shavad?',
                                align = 'top-left',
                                elements = elements
                            },
                            function(data3, menu3)
                                if data3.current.value == 'buyforgang' then
                                    local elements = {}
                                    for i=1, #foundGang do
                                        table.insert(elements, {label = foundGang[i].label, value = foundGang[i].grade})
                                    end

                                    ESX.UI.Menu.Open(
                                        'default', GetCurrentResourceName(), 'gang_ranks',
                                        {
                                            title = 'Baraye Kodom rank Set Shavad?',
                                            align = 'top-left',
                                            elements = elements
                                        },
                                        function(data4, menu4)
                                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask_index',
                                                {
                                                    title = 'Baraye Kodoom Set Save Beshe?',
                                                    align = 'top-left',
                                                    elements = {
                                                        {label = "Set 1", value = 1},
                                                        {label = "Set 2", value = 2},
                                                        {label = "Set 3", value = 3}
                                                    }
                                                },
                                                function(data5, menu5)
                                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                                        local skin = skin
                                                        for k, v in pairs(skin) do
                                                            if Sellable[GetEntityModel(PlayerPedId())][k] and Sellable[GetEntityModel(PlayerPedId())][k][v] then 
                                                                skin[k] = Naked[GetEntityModel(PlayerPedId())][k]
                                                            end
                                                        end
                                                        TriggerServerEvent('gangs:saveOutfit', data4.current.value, skin, data5.current.value)
                                                    end)
                                                    ESX.Alert('Taghirat Baraye ' .. data4.current.label .. ' Anjam Shod', "info")
                                                end, function(data5, menu5)
                                                    menu5.close()
                                                end)
                                        end,function(data4, menu4)
                                            menu4.close()
                                        end)
                                elseif data3.current.value == 'buyforproprty' then
                                    ESX.UI.Menu.Open(
                                        'dialog', GetCurrentResourceName(), 'outfit_name',
                                        {
                                            title = 'Esm Baraye in Set Lebas',
                                        },
                                        function(data3, menu4)
                                            menu3.close()
                                            menu4.close()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                TriggerServerEvent('esx_eden_clotheshop:saveOutfit', data3.value, skin)
                                            end)

                                            ESX.Alert('Lebase Shoma Ba Movafaqiyat Save Shod')

                                        end,
                                    function(data3, menu4)
                                        menu4.close()
                                    end)
                                end
                            end,
                        function(data3, menu3)
                            menu3.close()
                        end)
                        else
                            menu2.close()
                        end
                    end, 			
                function(data2, menu2)
                        menu2.close()
                end)
            end)
        end
    end
end)

RegisterNetEvent("esx:copyToClipboard")
AddEventHandler("esx:copyToClipboard", function(copy)
    exports['esx_shoprobbery']:SetClipboard(copy)
    ESX.Alert("Code Dar Clipboard Shoma Copy Shod", "check")
end)
