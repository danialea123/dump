ESX = nil
local PlayerData       = {}
local PlayerWithBadges = {}

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

RegisterNetEvent('esx_badge:UpdateBadges')
AddEventHandler('esx_badge:UpdateBadges', function(badges)
    if tLength(PlayerWithBadges) == 0 then
        SetTimeout(1500, Optimize)
    end
    PlayerWithBadges = badges
end)

function DrawText3D(x,y,z, text, r,g,b) 
    local showing,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz)-vector3(x,y,z))
 
    local andaze = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local andaze = andaze*fov
   
    if showing then
        SetTextScale(0.0*andaze,0.55 *andaze)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function Optimize()
    Citizen.CreateThread(function()
        while tLength(PlayerWithBadges) > 0 do
            Citizen.Wait(3)
            local Pause = true
            for _, id in ipairs(GetActivePlayers()) do
                local serverid = GetPlayerServerId(id)
                if PlayerWithBadges[serverid] then
                    if PlayerWithBadges[serverid].Toggle then 
                        local dist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(id)),GetEntityCoords(PlayerPedId()))
                        if dist < 12.0 and HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(id), 17) and IsEntityVisible(GetPlayerPed(id)) then
                            if not IsPedInAnyVehicle(GetPlayerPed(id)) then
                                Pause = false
                                x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(id),true))
                                DrawText3D(x, y, z + 1.1, "#"..PlayerWithBadges[serverid].Number.." "..PlayerWithBadges[serverid].Label, 132, 212, 232)
                            end
                        end
                    end
                end
            end
            if Pause then Citizen.Wait(750) end
        end
    end)
end

function tLength(t)
	local l = 0
	for k,v in pairs(t)do
		l = l + 1
	end

	return l
end


