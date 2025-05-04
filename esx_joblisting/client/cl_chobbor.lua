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
        local distance = #(coords - vector3(1219.01,-1267.01,36.42))
        if distance < 3.5 then
            if distance < 2.0 then
                if IsControlJustReleased(1, 38) then
                    SendNUIMessage({
                        action = "open",
                        JobName = "lumberjack",
                        img = "chobor",
                        Desc = " مراحل کار چوب بری : <br><br> مرحله اول : به سمت رخت کن برید و لباس و ماشین بردارید <br><br> مرحله دوم : با ماشین به محل چوب بری بروید <br><br> مرحله سوم : چوب کافی جمع کنید و به سمت مرحله بدی بروید <br><br> مر حله جهارم : به خریدار چوب ها رو بفروشید <br><br> مرحله پنجم : و به سمت محل برگردید <br><br> مرحله شیشم : و از کار خارج شوید",
                        Title = "Diamond Wood Cutter Job",
                        color = "rgb(88, 33, 26)",
                        color2 = "rgb(88, 33, 26)",
                        border = "rgb(88, 33, 26)",
                        box_shadow = "0 0 40px rgb(88, 33, 26)",
                        buttom_shadow = "0 0 22px rgb(88, 33, 26)",
                        buttom_shadow2 = "0 0 22px rgb(88, 33, 26)",
                        xcolor = "rgb(88, 33, 26)"
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
    RequestModel(GetHashKey("s_m_y_construct_02"))
    while not HasModelLoaded(GetHashKey("s_m_y_construct_02")) do
      Wait(1)
    end
    local ped =  CreatePed(1, GetHashKey("s_m_y_construct_02"), 1219.01,-1267.01,35.42,93.47, false, false)
    SetEntityHeading(ped, 93.4)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

RegisterNUICallback("stats", function(data)
    SetNuiFocus(data.stats, data.stats)
end)

-- Create blips
Citizen.CreateThread(function()

    local blip = AddBlipForCoord(1219.01,-1267.01,36.42)

    SetBlipSprite (blip, 238)
    --SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 17)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('chobor'))
    EndTextCommandSetBlipName(blip)

end)