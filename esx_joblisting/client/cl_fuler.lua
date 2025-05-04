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
        local distance = #(coords - vector3(581.13,-2285.81,6.39))
        if distance < 3.5 then
            if distance < 2.0 then
                if IsControlJustReleased(1, 38) then
                    SendNUIMessage({
                        action = "open",
                        JobName = "fueler",
                        img = "oilcompany",
                        Desc = "مراحل کار شرکت نفت : <br><br> مرحله اول : به سمت رخت کن برید و لباس و ماشین بردارید <br><br> مرحله دوم : با ماشین به محل شرکت نفت بروید <br><br> مرحله سوم : نفت کافی جمع کنید و به سمت مرحله بدی بروید <br><br> مر حله جهارم : به خریدار نفت ها رو بفروشید <br><br> مرحله پنجم : و به سمت محل برگردید <br><br> مرحله شیشم : و از کار خارج شوید",
                        Title = "Diamond Fuler Job",
                        color = "rgb(31, 46, 78)",
                        color2 = "rgb(31, 46, 78)",
                        border = "rgb(31, 46, 78)",
                        box_shadow = "0 0 49px rgb(9, 41, 224)",
                        buttom_shadow = "0 0 22px rgb(9, 41, 224",
                        buttom_shadow2 = "0 0 22px rgb(9, 41, 224)",
                        xcolor = "rgb(31, 46, 78)"
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
    RequestModel(GetHashKey("s_m_y_construct_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_construct_01")) do
      Wait(1)
    end
    local ped =  CreatePed(1,  GetHashKey("s_m_y_construct_01"), 581.13,-2285.81,5.39,165.86, false, false)
    SetEntityHeading(ped, 165.0)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

RegisterNUICallback("stats", function(data)
    SetNuiFocus(data.stats, data.stats)
end)

-- Create blips
Citizen.CreateThread(function()

    local blip = AddBlipForCoord(581.13,-2285.81,6.39)

    SetBlipSprite (blip, 648)
    --SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 76)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('fuller'))
    EndTextCommandSetBlipName(blip)

end)