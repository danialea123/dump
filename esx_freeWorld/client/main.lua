---@diagnostic disable: lowercase-global, undefined-field
ESX = nil

local InRealWorld = true
local nearPoint = {active = false, key = nil}
local dis = false
local menuopen = false
local lastHP = 0
local lastArmor = 0
PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
    ESX.SetPlayerData("inFreeWorld", false)
    ShowHelps()
    ShowMarker()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function ShowHelps()
    CreateThread(function()
        for k, v in pairs(Config.Locations) do
            if v.Blip.Show then
                local blip = AddBlipForCoord(v.Coord.x, v.Coord.y, v.Coord.z)
                SetBlipSprite(blip, v.Blip.Sprite)
                SetBlipDisplay(blip, 2)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, v.Blip.Color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.Blip.Name)
                EndTextCommandSetBlipName(blip)
    
            end

            if v.Ped.Spawn then
                RequestModel(GetHashKey(v.Ped.Model))
                while not HasModelLoaded(GetHashKey(v.Ped.Model)) do
                    Wait(0)
                end
    
                Ped = CreatePed(4, GetHashKey(v.Ped.Model), v.Coord.x, v.Coord.y, v.Coord.z - 1, v.Coord.w, false, true)
                SetEntityHeading(Ped, v.Coord.w)
                FreezeEntityPosition(Ped, true)
                SetEntityInvincible(Ped, true)
                SetBlockingOfNonTemporaryEvents(Ped, true)
                SetPedDiesWhenInjured(Ped, false)
                SetPedCanPlayAmbientAnims(Ped, true)
                SetPedCanRagdollFromPlayerImpact(Ped, false)
                SetEntityLodDist(Ped, 100)
            end
        end
    end)
end


function ShowMarker()
    CreateThread(function()
        while true do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local sleepThread = 1000
    
            for k, point in ipairs(Config.Locations) do
                local distance = #(playerCoords - vector3(point.Coord.x, point.Coord.y, point.Coord.z))
                if point.Marker.Show then
                    if distance <= point.Marker.DrawDistance then
                        sleepThread = 1
    
                        DrawMarker(point.Marker.Type, point.Coord.x, point.Coord.y, point.Coord.z, 0, 0, 0, 0, 0, 0, point.Marker.Radius, point.Marker.Radius, 0.5, point.Marker.Color.r, point.Marker.Color.g, point.Marker.Color.b, point.Marker.Color.a, false, true, 2, nil, nil, false)
                        
                        if distance <= point.Marker.Radius then
                            nearPoint = {active = true, key = k}
                            ESX.ShowHelpNotification("Dokme ~INPUT_CONTEXT~ jahat baz kardan menu portal")
    
                            if IsControlJustPressed(0, 38) then
                                if not dis then
                                    openmenu()
                                end
                            end
                        else
                            nearPoint = {active = false}
                        end
                    end
                else
                    if distance <= 2.0 then
                        sleepThread = 0
                        nearPoint = {active = true, key = k}
                        ESX.ShowHelpNotification("Dokme ~INPUT_CONTEXT~ jahat baz kardan menu portal")

                        if IsControlJustPressed(0, 38) then
                            if not dis then
                                openmenu()
                            end
                        end
                    else
                        nearPoint = {active = false}
                    end
                end
            end
    
            Citizen.Wait(sleepThread)
        end
    end)
end

function isActive()
    return nearPoint.active
end

local isControlsDisabled = false
function disableallControl(state)
    isControlsDisabled = state
    if state then
        Citizen.CreateThread(function()
            while isControlsDisabled do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
        end)
    else
        Citizen.Wait(0)
    end
end

function openmenu() 
    --if ESX.GetPlayerData().admin ~= 1 then return ESX.Alert("Felan Dar Dastres Nist") end
    if (PlayerData.job.name == "weazel" or PlayerData.job.name == "forces" or PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "mechanic" or PlayerData.job.name == "taxi" or PlayerData.job.name == "fbi") then
        return ESX.Alert('Baraye Play Dar Freeworld Bayad Dar Job Khodeton Off-Duty Konid', "error")
    end
    ESX.TriggerServerCallback('D-FreeWorld:getcoupon',function(data)
        if data == 0 then
            local elements = {
                {label = "❌Shoma dastresi be portal nadarid❌" , value = "none"},
                {label = "💳Kharid dastresi💳" , value = "buy"}
            }
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
                {
                    title    = 'Portal menu',
                    align    = 'center',
                    elements = elements,
                },

                function(data, menu)
                    if data.current.value == "buy" then
                        menu.close()
                        local elements = {
                            {label = "----- Info ----" , value = "none"},
                            {label = "Tedad coupon : 15x" , value = "none"},
                            {label = "Ravesh kharid khod ra entekhab konid :" , value = "none"},
                            {label = "---------------------------------" , value = "none"},
                            {label = "2,000,000<span style='color:green'>$</span>" , value = "ic"},
                            {label = "70 DCoin" , value = "dcoin"},
                        }
                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
                            {
                                title    = 'Portal menu',
                                align    = 'center',
                                elements = elements,
                            },
                            function(data2, menu2)
                                if data2.current.value ~= "none" then
                                    menu2.close()
                                    local elements = {
                                        {label = "Aya az kharid khod motmaeen hastid?" , value = "none"},
                                        {label = "✔️Bale✔️" , value = "yes"},
                                        {label = "❌Kheir❌" , value = "no"},
                                    }
                                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
                                        {
                                            title    = 'Portal menu',
                                            align    = 'center',
                                            elements = elements,
                                        },
                                        function(data3, menu3)
                                            if data3.current.value == "yes" then    
                                                menu3.close()
                                                TriggerServerEvent('D-FreeWorld:buy', data2.current.value)
                                            elseif data3.current.value == "no" then      
                                                menu3.close()
                                            end
                                        end,
                                        function(data3, menu3)
                                            menu3.close()
                                        end
                                    )
                                end
                            end,
                            function(data2, menu2)
                                menu2.close()
                            end
                        )
                    end
                end,
                function(data, menu)
                    menu.close()
                end
            )
        else
            ESX.TriggerServerCallback('D-FreeWorld:getservers',function(sv, world, coupon)
                if data then
                    if world == 0 then
                        elements = {}
                        table.insert(elements,{label = "Coupon left : " .. coupon, value = "count"})
    
                        for k , v in pairs(sv) do
                            table.insert(elements,{label = "World " .. k , value = k })
                        end

                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
                            {
                                title    = 'Portal menu',
                                align    = 'center',
                                elements = elements,
                            },
                            function(data, menu)
                                if data.current.value ~= "count" then
                                    menu.close()
                                    ESX.TriggerServerCallback('D-FreeWorld:getservers',function(sv,world)

                                        if world == 0 then
                                            if sv[data.current.value] then
                                                TriggerServerEvent('D-FreeWorld:change', sv[data.current.value].id)
                                            end
                                        end
                                    end)
                                end
                            end,
                            function(data, menu)
                                menu.close()
                            end
                        )
                    else

                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy2',
                            {
                                title    = 'Portal menu',
                                align    = 'center',
                                elements = { {label = "Back to real world", value = "back"} }
                            }, function(data, menu)
                                menu.close()
                                if data.current.value == "back" then
                                    TriggerServerEvent('D-FreeWorld:change', 'normal')
                                end
                            end,

                        function(data, menu)
                            menu.close()
                        end)
                    end
                end
            end)
        end
    end)
end

RegisterNetEvent('D-FreeWorld:anim')
AddEventHandler('D-FreeWorld:anim',function()
    lastHP = GetEntityHealth(PlayerPedId())
    lastAr = GetPedArmour(PlayerPedId())
    ESX.SetPlayerData("inFreeWorld", true)
    RemoveAllPedWeapons(PlayerPedId(), true)
    SetTimecycleModifier("NG_filmic12") 
    SetTimecycleModifierStrength(0.0)
    local loop = true
    SetTimeout(20000,function()
        loop = false
    end)
    dis = true
    disableallControl(true)                           
    Citizen.CreateThread(function()
        local aaa = 0.0
        ExecuteCommand('e mindcontrol2')
        while loop do
            Wait(200)
            aaa = aaa + 0.01
            SetTimecycleModifierStrength(aaa)
            RequestNamedPtfxAsset("proj_xmas_firework")
            UseParticleFxAssetNextCall("proj_xmas_firework")
            StartParticleFxNonLoopedOnEntity("scr_firework_xmas_burst_rgw", PlayerPedId(), 0, 0, -0.5, 0, 0, 0, 1, false, false, false)
            StartParticleFxNonLoopedOnEntity("scr_firework_xmas_spiral_burst_rgw", PlayerPedId(), 0, 0, -0.5, 0, 0, 0, 1, false, false, false)
            StartParticleFxNonLoopedOnEntity("scr_xmas_firework_sparkle_spawn", PlayerPedId(), 0, 0, -0.5, 0, 0, 0, 1, false, false, false)
            ESX.UI.Menu.CloseAll()
        end
    end)

	TriggerEvent("mythic_progbar:client:progress", {
		name = "process_robbery",
		duration = 20000,
		label = "",
		useWhileDead = false,
		canCancel = false,
		controlDisables = {
			disableMovement = true, 
            disableCarMovement = true, 
            disableMouse = false, 
            disableCombat = true
		},
	}, function(status)
		if not status then
			Citizen.CreateThread(function()
                local aaa = 1.0

                while aaa > 0 do
                    Wait(200)
                    aaa = aaa - 0.1
                    SetTimecycleModifierStrength(aaa)
                    ESX.UI.Menu.CloseAll()
                    DisableAllControlActions(0)
                end

                SetTimecycleModifier("") 
                SetTimecycleModifierStrength(0.0)
                SetEntityAlpha(PlayerPedId(), 1000, false)
            end)  

            ClearPedTasksImmediately(PlayerPedId())    
            disableallControl(false)
            dis = false
		end
	end)
end)