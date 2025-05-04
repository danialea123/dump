---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-field
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    
    while not ESX.GetPlayerData().job do
		Citizen.Wait(1000)
	end

	PlayerData = ESX.GetPlayerData()
end)

local blips = {}

RegisterNetEvent('esx_AdminArea:Set')
AddEventHandler("esx_AdminArea:Set", function(blip)
    if Length() == 0 then
        SetTimeout(3000, TriggerAdminAreaThread)
    end
    blips[blip.index] = {
        coords = blip.coords,
        bradius = blip.radius,
        blip = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z),
        radius = AddBlipForRadius(blip.coords.x, blip.coords.y,blip. coords.z, blip.radius+30.0),
        isCustom = tLength(blip.players) > 1,
        players = blip.players
    }
    
    SetBlipSprite(blips[blip.index].blip, blip.id)
    SetBlipAsShortRange(blips[blip.index].blip, true)
    SetBlipColour(blips[blip.index].blip, blip.color)
    SetBlipScale(blips[blip.index].blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blip.name)
    EndTextCommandSetBlipName(blips[blip.index].blip)
    SetBlipAlpha(blips[blip.index].radius, 80)
    SetBlipColour(blips[blip.index].radius, blip.color)
end)

RegisterNetEvent('esx_AdminArea:Load')
AddEventHandler("esx_AdminArea:Load", function(pblips)
    if Length() == 0 then
        SetTimeout(3000, TriggerAdminAreaThread)
    end
    for k,v in pairs(pblips) do
        blips[v.index] = {
            coords = v.coords,
            bradius = v.radius,
            blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z),
            radius = AddBlipForRadius(v.coords.x, v.coords.y, v.coords.z, v.radius+30.0),
            isCustom = tLength(v.players) > 1,
            players = v.players
        }
        SetBlipSprite(blips[v.index].blip, v.id)
        SetBlipAsShortRange(blips[v.index].blip, true)
        SetBlipColour(blips[v.index].blip, v.color)
        SetBlipScale(blips[v.index].blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(v.name)
        EndTextCommandSetBlipName(blips[v.index].blip)
        SetBlipAlpha(blips[v.index].radius, 80)
        SetBlipColour(blips[v.index].radius, v.color)
    end
end)

RegisterNetEvent('esx_AdminArea:Clear')
AddEventHandler("esx_AdminArea:Clear", function(blipID)
    if blips[blipID] then
        RemoveBlip(blips[blipID].blip)
        RemoveBlip(blips[blipID].radius)
        blips[blipID] = nil
    else
        print("There was a issue with removing blip: " .. tostring(blipID))
    end
end)

function Length()
    local count = 0 
    for k,v in pairs(blips) do
        count = count + 1
    end
    return count
end

function tLength(t)
	local l = 0
	for k,v in pairs(t)do
		l = l + 1
	end

	return l
end

function TriggerAdminAreaThread() -- matin gharch aziz salam
    Citizen.CreateThread(function()--man HR ban system hastam
        while Length() > 0 do
            local Near = false
            Citizen.Wait(4)
            for k,v in pairs(blips) do
                if v.isCustom and v.players[GetPlayerServerId(PlayerId())] and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords , false) < 30.0 then
                    DrawMarker(1, v.coords.x, v.coords.y, v.coords.z - 30, 0, 0, 0, 0, 0, 0, v.bradius * 2.0, v.bradius * 2.0, 80.0, 205, 226, 255, 150, 0, 0, 0, 0)
                    Near = true
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords , false) > (v.bradius) and PlayerData.permission_level < 1 then
                        ESX.SetEntityCoords(PlayerPedId(), v.coords.x, v.coords.y, v.coords.z)
                    end
                elseif not v.isCustom and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords , false) < 60.0 then
                    DrawMarker(1, v.coords.x, v.coords.y, v.coords.z - 30, 0, 0, 0, 0, 0, 0, v.bradius * 2.0, v.bradius * 2.0, 80.0, 205, 226, 255, 150, 0, 0, 0, 0)
                    Near = true
                end
            end
            if not Near then Citizen.Wait(710) end
        end
    end)
end

