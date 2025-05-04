---@diagnostic disable: undefined-field
lib.locale()

if Config.Framework == "ESX" then
    if Config.NewESX then
        ESX = exports["es_extended"]:getSharedObject()
    else
        ESX = nil
        CreateThread(function()
            while ESX == nil do
                TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
                Wait(100)
            end
        end)
    end
elseif Config.Framework == "qbcore" then
    QBCore = nil
    QBCore = exports["qb-core"]:GetCoreObject()
elseif Config.Framework == "standalone" then
    -- ADD YOU FRAMEWORK
end

-- Your notification type settings
-- •» You can edit a type of notifications, with chaning type or triggering your own.
Notify = function(type, title, text)
    if Config.NotificationType == "ESX" then
        ESX.ShowNotification(text)
    elseif Config.NotificationType == "ox_lib" then
        if type == "info" then
            lib.notify({
                title = title,
                description = text,
                type = "inform"
            })
        elseif type == "error" then
            lib.notify({
                title = title,
                description = text,
                type = "error"
            })
        elseif type == "success" then
            lib.notify({
                title = title,
                description = text,
                type = "success"
            })
        end
    elseif Config.NotificationType == "qbcore" then
        if type == "success" then
            QBCore.Functions.Notify(text, "success")
        elseif type == "info" then
            QBCore.Functions.Notify(text, "primary")
        elseif type == "error" then
            QBCore.Functions.Notify(text, "error")
        end
    elseif Config.NotificationType == "custom" then
        print("add your notification system! in cl_Utils.lua")
        -- ADD YOUR NOTIFICATION | TYPES ARE info, error, success
    end
end

ProgressBar = function(duration, label)
    if Config.Progress == "ox_lib" then
        lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = false
        })
    elseif Config.Progress == "qbcore" then
        QBCore.Functions.Progressbar(label, label, duration - 500, false, true, {
        }, {}, {}, {}, function()
        end)
        Wait(duration)
    elseif Config.Progress == "progressBars" then
        exports["esx_basicneeds"]:startUI(duration, label)
        Wait(duration)
    end
end

Action = function(data)
    if Config.Framework == "ESX" then
        if data.status == "drunk" then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
            local playerPed = PlayerPedId()
            DoScreenFadeOut(800)
            Wait(1000)
            RequestAnimSet("move_m@drunk@slightlydrunk")
            while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
                Wait(0)
            end
            SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
            SetTimecycleModifier("spectator5")
            SetPedMotionBlur(playerPed, true)
            SetPedIsDrunk(playerPed, true)
            DoScreenFadeIn(800)
            Wait(math.random(30000, 70000))
            DoScreenFadeOut(800)
            Wait(1000)
            ClearTimecycleModifier()
            ResetScenarioTypesEnabled()
            ResetPedMovementClipset(playerPed, 0)
            SetPedIsDrunk(playerPed, false)
            SetPedMotionBlur(playerPed, false)
            DoScreenFadeIn(800)
        else
            TriggerServerEvent("drc-consumables:server:add", data.status, data.add)
        end
    elseif Config.Framework == "qbcore" then
        if data.status == "drunk" then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
            local playerPed = PlayerPedId()
            DoScreenFadeOut(800)
            Wait(1000)
            RequestAnimSet("move_m@drunk@slightlydrunk")
            while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
                Wait(0)
            end
            SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
            SetTimecycleModifier("spectator5")
            SetPedMotionBlur(playerPed, true)
            SetPedIsDrunk(playerPed, true)
            DoScreenFadeIn(800)
            Wait(math.random(20000, 50000))
            DoScreenFadeOut(800)
            Wait(1000)
            ClearTimecycleModifier()
            ResetScenarioTypesEnabled()
            ResetPedMovementClipset(playerPed, 0)
            SetPedIsDrunk(playerPed, false)
            SetPedMotionBlur(playerPed, false)
            DoScreenFadeIn(800)
        else
            TriggerServerEvent("drc-consumables:server:add", data.status,
                QBCore.Functions.GetPlayerData().metadata[data.status] + data.add / 10000)
        end
    end
end

--BossMenu
OpenBossMenu = function()
    --[[if Config.BossMenu == "esx_society" then
        TriggerEvent('esx_society:openBossMenu', "wine", function(data, menu)
            menu.close()
        end, { wash = false })
    elseif Config.BossMenu == "qb-management" then
        TriggerEvent("qb-bossmenu:client:OpenMenu")
    end]]
end


TextUIShow = function(text)
    if Config.TextUI == "ox_lib" then
        lib.showTextUI(text)
    elseif Config.TextUI == "esx" then
        exports["esx_textui"]:TextUI(text)
    elseif Config.TextUI == "luke" then
        TriggerEvent('luke_textui:ShowUI', text)
    elseif Config.TextUI == "custom" then
        print("add your textui system! in cl_Utils.lua")
        -- ADD YOUR TEXTUI | TO SHOW
    end
end

IsTextUIShowed = function()
    if Config.TextUI == "ox_lib" then
        return lib.isTextUIOpen()
    elseif Config.TextUI == "esx" then
        --exports["esx_textui"]:TextUI(text)
    elseif Config.TextUI == "luke" then
        --TriggerEvent('luke_textui:ShowUI', text)
    elseif Config.TextUI == "custom" then
        print("add your textui system! in cl_Utils.lua")
        -- ADD YOUR TEXTUI | TO SHOW
    end
end

TextUIHide = function()
    if Config.TextUI == "ox_lib" then
        lib.hideTextUI()
    elseif Config.TextUI == "esx" then
        exports["esx_textui"]:HideUI()
    elseif Config.TextUI == "luke" then
        TriggerEvent('luke_textui:HideUI')
    elseif Config.TextUI == "custom" then
        print("add your textui system! in cl_Utils.lua")
        -- ADD YOUR TEXTUI | TO HIDE
    end
end

Draw3DText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    
    if onScreen then
        SetTextFont(Config.FontId)
        SetTextScale(0.33, 0.30)
        SetTextDropshadow(10, 100, 100, 100, 255)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 350
        DrawRect(_x,_y+0.0135, 0.025+ factor, 0.03, 0, 0, 0, 10)
    end
end

Target = function()
    if Config.Target == "qtarget" then
        return exports['qtarget']
    end
    if Config.Target == "qb-target" then
        return exports['qb-target']
    end
    if Config.Target == "ox_target" then
        return exports['qtarget']
    end
end

OpenStash = function(stash)
    --[[if Config.Framework == "qbcore" then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", stash)
        TriggerEvent("inventory:client:SetCurrentStash", stash)
    elseif Config.Framework == "ESX" then
        exports.ox_inventory:openInventory('stash', stash)
    end]]
end

OpenCloakRoomMenu = function()
    lib.registerContext({
        id = 'wine_cloakroom',
        title = 'CloakRoom',
        options = {
            ['Outfits'] = {
                arrow = false,
                event = 'drc_wine:outfits'
            },
            ['Put on job outfit'] = {
                arrow = false,
                event = 'drc_wine:joboutfit'
            }
        }
    })
    lib.showContext('wine_cloakroom')
end

local male = json.decode('{"glasses_1":0,"pants_2":24,"shoes_1":7,"arms":67,"pants_1":89,"decals_2":0,"tshirt_2":0,"bproof_1":0,"decals_1":0,"torso_2":0,"glasses_2":0,"mask_2":0,"chain_2":0,"shoes_2":1,"mask_1":0,"tshirt_1":15,"bags_2":0,"chain_1":0,"torso_1":5,"bproof_2":0,"helmet_1":-1,"bags_1":0,"helmet_2":0}')
local female = json.decode('{"glasses_1":5,"pants_2":19,"shoes_1":27,"arms":83,"pants_1":92,"decals_2":0,"tshirt_2":0,"bproof_1":0,"decals_1":0,"torso_2":0,"glasses_2":0,"mask_2":0,"chain_2":4,"shoes_2":0,"mask_1":0,"tshirt_1":15,"bags_2":0,"chain_1":83,"torso_1":14,"bproof_2":0,"helmet_1":-1,"bags_1":0,"helmet_2":0}')

RegisterNetEvent("drc_wine:joboutfit", function()
    if Config.Clothing == "esx_skin" then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if tonumber(skin.sex) == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, male)
            else
                TriggerEvent('skinchanger:loadClothes', skin, female)
            end
        end)
        TriggerServerEvent("esx_winemaker:SetJob")
    end
end)

RegisterNetEvent("drc_wine:outfits", function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
        TriggerServerEvent('esx_winemaker:SetLastJob')
    end)
end)

--Config.Blips creating
CreateThread(function()
    for _, v in pairs(Config.Blips) do
        local blip = AddBlipForCoord(v.BlipCoords)
        SetBlipSprite(blip, v.Sprite)
        SetBlipDisplay(blip, v.Display)
        SetBlipScale(blip, 0.6)
        SetBlipColour(blip, v.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(v.Name)
        EndTextCommandSetBlipName(blip)
    end
end)

--job Blips
CreateThread(function()
    while not GetJob() do
        Wait(1000)
    end
    if GetJob() == Config.JobName and not ShopBlips then
        for _, v in pairs(Config.JobBlips) do
            local ShopBlips = AddBlipForCoord(v.BlipCoords)
            SetBlipSprite(ShopBlips, v.Sprite)
            SetBlipDisplay(ShopBlips, v.Display)
            SetBlipScale(ShopBlips, 0.6)
            SetBlipColour(ShopBlips, v.Colour)
            SetBlipAsShortRange(ShopBlips, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(v.Name)
            EndTextCommandSetBlipName(ShopBlips)
        end
    end
end)

--Get Player job
function GetJob()
    while ESX == nil do Citizen.Wait(3000) end
    if Config.Framework == "ESX" then
        if ESX.GetPlayerData().job then
            return ESX.GetPlayerData().job.name
        else
            return false
        end
    elseif Config.Framework == "qbcore" then
        if QBCore.Functions.GetPlayerData().job then
            return QBCore.Functions.GetPlayerData().job.name
        else
            return false
        end
    end
end

SpawnVehicle = function(model, coords, heading, livery)
    if Config.Framework == "ESX" then
        ESX.Game.SpawnVehicle(model, coords, heading, function(vehicle)
            SetEntityHeading(vehicle, heading)
            SetVehicleLivery(vehicle, livery)
            ESX.CreateVehicleKey(vehicle)
        end)
    elseif Config.Framework == "qbcore" then
        QBCore.Functions.SpawnVehicle(model, function(vehicle)
            SetEntityHeading(vehicle, heading)
            SetVehicleLivery(vehicle, livery)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
        end, coords, true)
    elseif Config.Framework == "standalone" then
        -- ADD YOU FRAMEWORK
    end
end

GetClosestCar = function(coords)
    if Config.Framework == "ESX" then
        return ESX.Game.GetClosestVehicle(coords)
    elseif Config.Framework == "qbcore" then
        return QBCore.Functions.GetClosestVehicle()
    elseif Config.Framework == "standalone" then
        -- ADD YOU FRAMEWORK
    end
end

Minigame = function()
    success = lib.skillCheck({'easy'}, {'w', 'a', 's', 'd'})
    return success
end

local using = false
RegisterNetEvent('drc_wine:consumables', function(text, animation, duration, effect)
    if not using then
        using = true
        TriggerEvent('esx_status:add', 'mental', 700000)
        if animation.emote.enabled then
            dict = animation.emote.anim.dict
            clip = animation.emote.anim.clip
            model = animation.emote.prop.model
            pos = animation.emote.prop.pos
            rot = animation.emote.prop.rot
            bone = animation.emote.prop.bone
            RequestAnimDict(dict)
            while (not HasAnimDictLoaded(dict)) do Wait(0) end
            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
            local hash = model
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(100)
                RequestModel(hash)
            end
            local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
            AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, bone), pos, rot,
                true, true, false, false, 1, true)
            ProgressBar(duration, text)
            using = false
            DetachEntity(prop, false, false)
            DeleteEntity(prop)
            ClearPedTasks(cache.ped)
            Action(effect)
            using = false
        elseif animation.scenario.enabled then
            TaskStartScenarioInPlace(cache.ped, animation.scenario.anim.scenario, 0, false)
            ProgressBar(duration, text)
            using = false
            ClearPedTasks(cache.ped)
            Action(effect)
            using = false
        end
    end
end)
