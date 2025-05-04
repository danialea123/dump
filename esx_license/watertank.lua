Config = {}

Config.WaterPrice = 2 -- this is how much the water costs.

Config.TankModel = -742198632 -- this is the model of the tank if you wan't  to change it.

Config.DrinkingTime = 10000 -- this is specified in ms

ESX = nil

cachedData = {}

Citizen.CreateThread(function()

    while not ESX do

        --Fetching esx library, due to new to esx using this.

        TriggerEvent("esx:getSharedObject", function(library)

            ESX = library

        end)

        Citizen.Wait(0)

    end

    exports['diamond_target']:AddTargetModel({-742198632}, {

        options = {

            {

                icon = "fa-solid fa-glass-water",

                label = "آب خوردن",

                action = function(entity)

					PurchaseDrink()

                end,

            },

        },

        job = {"all"},

        distance = 3.5

    })

end)

RegisterNetEvent("esx:playerLoaded")

AddEventHandler("esx:playerLoaded", function(playerData)

    ESX.PlayerData = playerData

end)

-----------------------

PurchaseDrink = function()

    Drink()

end

Drink = function()

    local timeStarted = GetGameTimer()

    WaitForModel(GetHashKey("prop_cs_shot_glass"))

    ESX.Game.SpawnLocalObject("prop_cs_shot_glass", {

        GetEntityCoords(PlayerPedId())

    }, function(obj)

        AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)
        
        exports.essentialmode:DisableControl(true)
        
        TriggerEvent("dpemote:enable", false)
        
        TriggerEvent("dpclothingAbuse", true)

        local random = math.random(1,2)
        
        TriggerEvent('InteractSound_CL:PlayOnOne', 'drinking_'..random, 1.0)
        
        while not HasAnimDictLoaded("mp_player_intdrink") do

            Citizen.Wait(0)

            RequestAnimDict("mp_player_intdrink")

        end

        cachedData["drinking"] = true

        Citizen.CreateThread(function()

            while GetGameTimer() - timeStarted < Config.DrinkingTime do

                Citizen.Wait(100)

                if not IsEntityPlayingAnim(PlayerPedId(), "mp_player_intdrink", "loop_bottle", 3) then

                    TaskPlayAnim(PlayerPedId(), "mp_player_intdrink", "loop_bottle", 1.0, -1.0, 2000, 49, 0, 0, 0, 0)

                end

                TriggerEvent("esx_status:add", "thirst", 10000)

            end

            cachedData["drinking"] = false

            DeleteEntity(obj)

            exports.essentialmode:DisableControl(false)

            TriggerEvent("dpemote:enable", true)

            TriggerEvent("dpclothingAbuse", false)

        end)

        RemoveAnimDict("mp_player_intdrink")

        SetModelAsNoLongerNeeded(GetHashKey("prop_cs_shot_glass"))

    end)

end



WaitForModel = function(model)

    local DrawScreenText = function(text, red, green, blue, alpha)

        SetTextFont(4)

        SetTextScale(0.0, 0.5)

        SetTextColour(red, green, blue, alpha)

        SetTextDropshadow(0, 0, 0, 0, 255)

        SetTextEdge(1, 0, 0, 0, 255)

        SetTextDropShadow()

        SetTextOutline()

        SetTextCentre(true)

        BeginTextCommandDisplayText("STRING")

        AddTextComponentSubstringPlayerName(text)

        EndTextCommandDisplayText(0.5, 0.5)

    end

    if not IsModelValid(model) then

        return ESX.ShowNotification("This model does not exist ingame.")

    end

    if not HasModelLoaded(model) then

        RequestModel(model)

    end

    while not HasModelLoaded(model) do

        Citizen.Wait(0)

    end

end

-----------

-- Citizen.CreateThread(function()

--     while true do

--         local ped = PlayerPedId()

--         local pedCoords = GetEntityCoords(ped)

--         local closestTank = GetClosestObjectOfType(pedCoords, 5.0, Config.TankModel, false)

--         if DoesEntityExist(closestTank) then

--             sleepThread = 5

--             local markerCoords = GetOffsetFromEntityInWorldCoords(closestTank, 0.0, -0.2, 1.0)

--             local distanceCheck = #(pedCoords - markerCoords)

--             if distanceCheck <= 1.0 then

--                 local drinkable, displayText = not cachedData["drinking"], cachedData["drinking"] and "Dar Hal Ab Khordan..." or "Dokme ~INPUT_CONTEXT~ Jahat Ab Khordan"

--                 ESX.ShowHelpNotification(displayText)

--                 if drinkable then

--                     if IsControlJustPressed(0, 38) then

--                         PurchaseDrink()

--                     end

--                 end

--             end

--         else

--             Citizen.Wait(3000)

--         end

--         Citizen.Wait(10)

--     end

-- end)

