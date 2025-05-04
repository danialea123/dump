ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        local distance = #(coords - vector3(-1069.69,-2083.47,14.37))
        if distance < 3.5 then
            if distance < 2.0 then
                if IsControlJustReleased(1, 38) then
                    SendNUIMessage({
                        action = "open",
                        JobName = "slaughterer",
                        img = "butcher",
                        Desc = "مراحل کار قصابی : <br><br> مرحله اول : یه سمت رخت کن برید و لباس و ماشین بردارید <br><br> مرحله دوم : با ماشین به محل قصابی بروید <br><br> مرحله سوم : گوشت کافی جمع کنید و به سمت مرحله بدی بروید <br><br> مر حله جهارم : به خریدار گوشت ها رو بفروشید <br><br> مرحله پنجم : و به سمت محل برگردید <br><br> مرحله شیشم : و از کار خارج شوید",
                        Title = "Diamond Butcher Job",
                        color = "rgb(255, 0, 0)",
                        color2 = "rgb(255, 0, 0)",
                        border = "rgb(255, 0, 0)",
                        box_shadow = "0 0 40px rgb(255, 0, 0)",
                        buttom_shadow = "0 0 22px rgb(255, 0, 0)",
                        buttom_shadow2 = "0 0 22px rgb(255, 0, 0)",
                        xcolor = "rgb(255, 0, 0)"
                    })
                end
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

-- Ped Section

Citizen.CreateThread(function()
    RequestModel(GetHashKey("s_m_m_linecook"))
    while not HasModelLoaded(GetHashKey("s_m_m_linecook")) do
      Wait(1)
    end
    local ped =  CreatePed(1, GetHashKey("s_m_m_linecook"), -1069.69,-2083.47,13.37,309.52, false, false)
    SetEntityHeading(ped, 309.52)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

-- Ped Section

local firstWayPoints = {
    ["lumberjack"] = vector2(1200.63, -1276.39),
    ["slaughterer"] = vector2(-1071.06, -2003.75),
    ["hunter"] = vector2(-567.95, 5253.26),
    ["miner"] = vector2(892.19, -2172.8),
    ["delivery"] = vector2(143.97, -1461.82),
    ["fueler"] = vector2(557.92, -2327.83),
    ["fisherman"] = vector2(868.24, -1639.66),
}

local Pointer = {
    ["lumberjack"] = {
        [1] = vector2(1200.63, -1276.39),
        [2] = vector2(1191.96, -1261.77),
        [3] = vector2(-531.86, 5373.34),
        [4] = vector2(1201.26, -1327.73),
    },
    ["slaughterer"] = {
        [1] = vector2(-1071.06, -2003.75),
        [2] = vector2(-1042.94, -2023.25),
        [3] = vector2(-62.34, 6239.67),
        [4] = vector2(-596.12, -889.25),
    },
    ["hunter"] = {
        [1] = vector2(-567.95, 5253.26),
        [2] = vector2(-96.82, 6205.78),
        [3] = vector2(-62.34, 6239.67),
        [4] = vector2(-596.12, -889.25),
    },
    ["miner"] = {
        [1] = vector2(892.19, -2172.8),
        [2] = vector2(884.72, -2176.47),
        [3] = vector2(318.26, 2864.48),
        [4] = vector2(1114.04, -2006.19),
        [5] = vector2(-91.59, -1029.91),
        [6] = vector2(-149.29, -1040.09),
        [7] = vector2(-620.5, -228.4),
        [8] = vector2(892.19, -2172.8),
    },
    ["fueler"] = {
        [1] = vector2(557.92, -2327.83),
        [2] = vector2(554.59, -2314.43),
        [3] = vector2(611.05, 2860.98),
        [4] = vector2(2737.04, 1416.92),
        [5] = vector2(265.42, -3012.44),
        [6] = vector2(492.06, -2162.7),
    },
    ["fisherman"] = {
        [1] = vector2(868.24, -1639.66),
        [2] = vector2(880.49, -1663.94),
        [3] = vector2(-1546.67, -1294.84),
        [4] = vector2(-1012.51,-1354.52),
    }
}

RegisterNUICallback('joinjob', function(data, cb)
    SetNewWaypoint(firstWayPoints[data.job].x, firstWayPoints[data.job].y)
    --[[if Pointer[data.job] then
        StartPointing(Pointer[data.job], data.job)
    end]]
    TriggerServerEvent('takejob:setjob', data.job)
end)

RegisterNUICallback('quitjob', function(data, cb)
    TriggerServerEvent('quitjob:quit')
end)

RegisterNUICallback("stats", function(data)
    SetNuiFocus(data.stats, data.stats)
end)

function StartPointing(coords, job)
    Citizen.CreateThread(function()
        while ESX.GetPlayerData().job.name == job do
            Citizen.Wait(750)
            local coord = GetEntityCoords(PlayerPedId())
            for k, v in pairs(coords) do
                local distance = #(coord.xy - v.xy)
                print(distance)
                if distance <= 3.0 then
                    local key = k + 1
                    print(key, Pointer[job][key].x)
                    if Pointer[job][key] then
                        SetNewWaypoint(Pointer[job][key].x, Pointer[job][key].y)
                    else
                        break
                    end
                end
            end
        end
    end)
end

-- Create blips
Citizen.CreateThread(function()

    local blip = AddBlipForCoord(-1069.69,-2083.47,14.37)

    SetBlipSprite (blip, 273)
    --SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 1)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Ghasabi")
    EndTextCommandSetBlipName(blip)
end)