---@diagnostic disable: undefined-field, missing-parameter, undefined-global
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local isPlacing = false
local campfireObject = nil
local placementMode = false
local currentZOffset = -0.1
local zAdjustmentStep = 0.05
local placedCampfires = {}

local function LoadModel(model)
    RequestModel(model)
    local tries = 0
    while not HasModelLoaded(model) and tries < 100 do
        Wait(100)
        tries = tries + 1
    end
    return HasModelLoaded(model)
end

local function GetGroundPosition(x, y, z)
    local ground, groundZ = GetGroundZFor_3dCoord(x, y, z, true)
    return ground, groundZ + currentZOffset
end

local function CreatePlacementPreview()
    if campfireObject then
        DeleteObject(campfireObject)
    end
    
    local modelHash = GetHashKey(ConfigCamp.CampfireProp)
    if LoadModel(modelHash) then
        campfireObject = CreateObject(modelHash, 0.0, 0.0, 0.0, false, true, true)
        SetEntityAlpha(campfireObject, 200, false)
        SetEntityCollision(campfireObject, false, false)
        ESX.ShowNotification("Shoma ba movafaghiat Campfire use kardid!")
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"[SYSTEM]", "Moshkeli dar campfire be vojud amade, be developer etela dahid!"}
        })
    end
end

local function UpdatePlacementPreview()
    if not campfireObject then return end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local forward = GetEntityForwardVector(playerPed)
    local x, y, z = table.unpack(coords + forward * ConfigCamp.PlacementDistance)
    local ground, groundZ = GetGroundPosition(x, y, z)
    if ground then
        SetEntityCoords(campfireObject, x, y, groundZ)
        SetEntityHeading(campfireObject, GetEntityHeading(playerPed))
    end
end

local function PlaceCampfire()
    if not campfireObject then return end
    
    local coords = GetEntityCoords(campfireObject)
    local heading = GetEntityHeading(campfireObject)
    
    TriggerServerEvent('campfire:placeCampfire', coords, heading)
    
    DeleteObject(campfireObject)
    campfireObject = nil
    isPlacing = false
    placementMode = false
    currentZOffset = -0.1
end

local function PickupCampfire(campfireId)
    if not campfireId then return end

    if placedCampfires[campfireId] and DoesEntityExist(placedCampfires[campfireId].object) then
        DeleteObject(placedCampfires[campfireId].object)
    end
    
    TriggerServerEvent('campfire:pickupCampfire', campfireId)
    
    placedCampfires[campfireId] = nil
end

RegisterNetEvent('campfire:startPlacement')
AddEventHandler('campfire:startPlacement', function()
    if isPlacing then return end
    
    ESX.ShowNotification("Shoma ba movafaghiat Campfire use kardid!")
    
    isPlacing = true
    placementMode = true
    currentZOffset = -0.1
    CreatePlacementPreview()
    
    Citizen.CreateThread(function()
        while placementMode do
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentString('Press ~INPUT_CONTEXT~ to place campfire~n~Press ~INPUT_FRONTEND_RRIGHT~ to cancel')
            -- AddTextComponentString('Use ~INPUT_CELLPHONE_UP~/~INPUT_CELLPHONE_DOWN~ to adjust height')
            EndTextCommandDisplayHelp(0, false, true, -1)
            UpdatePlacementPreview()
            
            if IsControlJustPressed(0, 38) then
                PlaceCampfire()
            elseif IsControlJustPressed(0, 177) then
                placementMode = false
                if campfireObject then
                    DeleteObject(campfireObject)
                    campfireObject = nil
                end
                isPlacing = false
                currentZOffset = -0.1
                TriggerServerEvent('campfire:returnItem')
                ESX.ShowNotification("Shoma ba movafaghiat ~g~Action ~w~ra cancel kardid!")
            end
            
            if IsControlPressed(0, 14) then
                currentZOffset = currentZOffset + zAdjustmentStep
                Wait(100)
            elseif IsControlPressed(0, 15) then
                currentZOffset = currentZOffset - zAdjustmentStep
                Wait(100)
            end
            
            Wait(0)
        end
    end)
end)

RegisterNetEvent('campfire:placeCampfireClient')
AddEventHandler('campfire:placeCampfireClient', function(campfireId, coords, heading, owner)
    local modelHash = GetHashKey(ConfigCamp.CampfireProp)
    if LoadModel(modelHash) then
        local campfire = CreateObject(modelHash, coords.x, coords.y, coords.z, false, true, false)
        SetEntityHeading(campfire, heading)
        PlaceObjectOnGroundProperly(campfire)
        SetEntityCoords(campfire, coords.x, coords.y, coords.z)
        FreezeEntityPosition(campfire, true)
        
        placedCampfires[campfireId] = {
            object = campfire,
            coords = coords,
            heading = heading,
            owner = owner
        }
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"[SYSTEM]", "Moshkeli dar campfire be vojud amade, be developer etela dahid!"}
        })
    end
end)

RegisterNetEvent('campfire:removeCampfireClient')
AddEventHandler('campfire:removeCampfireClient', function(campfireId)
    if placedCampfires[campfireId] then
        if DoesEntityExist(placedCampfires[campfireId].object) then
            DeleteObject(placedCampfires[campfireId].object)
        end
        placedCampfires[campfireId] = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local foundCampfire = false
        
        for id, campfire in pairs(placedCampfires) do
            local distance = #(playerCoords - vector3(campfire.coords.x, campfire.coords.y, campfire.coords.z))
            if distance < 10.0 then
                foundCampfire = true
                if distance < 2.0 and (campfire.owner == GetPlayerServerId(PlayerId()) or ESX.GetPlayerData().admin == 1) then
                    sleep = 0
                    DrawText3D(campfire.coords.x, campfire.coords.y, campfire.coords.z + 1.0, "Press ~g~F~w~ to destroy campfire")
                    if IsControlJustPressed(0, 49) then
                        PickupCampfire(id)
                    end
                end
            end
        end
        
        if not foundCampfire then
            sleep = 750
        end
        
        Wait(sleep)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end 