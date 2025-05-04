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
        local distance = #(coords - vector3(-87.14, 1880.41, 196.32))
        if distance < 3.5 then
            if distance < 2.0 then
                if IsControlJustReleased(1, 38) then
                    SendNUIMessage({
                        action = "open",
                        JobName = "hunter",
                        img = "hunter",
                        Desc = "مراحل کار شکارچی : <br><br> مرحله اول : به سمت رخت کن برید و لباس و ماشین بردارید <br><br> مرحله دوم : با ماشین به محل شکار بروید <br><br> مرحله سوم : گوشت کافی جمع کنید و به سمت مرحله بدی بروید  <br><br> مر حله جهارم : به خریدار گوشت ها رو بفروشید  <br><br>  مرحله پنجم : و به سمت محل برگردید <br><br>  مرحله شیشم : و از کار خارج شوید",
                        Title = "Diamond Hunter Job",
                        color = "rgb(34, 170, 29",
                        color2 = "rgb(34, 170, 29",
                        border = "rgb(34, 170, 29",
                        box_shadow = "0 0 40px rgb(34, 170, 29",
                        buttom_shadow = "0 0 22px rgb(34, 170, 29",
                        buttom_shadow2 = "0 0 22px rgb(34, 170, 29",
                        xcolor = "rgb(34, 170, 29)"
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
    RequestModel(GetHashKey("mp_m_exarmy_01"))
    while not HasModelLoaded(GetHashKey("mp_m_exarmy_01")) do
      Wait(1)
    end
    local ped =  CreatePed(1,  0x45348DBB, -87.14, 1880.41, 196.32, 159.3, false, false)
    SetEntityHeading(ped, 265.86)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

RegisterNUICallback("stats", function(data)
    SetNuiFocus(data.stats, data.stats)
end)

-- Create blips
Citizen.CreateThread(function()


    local blip = AddBlipForCoord(-87.14, 1880.41, 196.32)

    SetBlipSprite (blip, 141)
    --SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour(blip, 21)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('hunter'))
    EndTextCommandSetBlipName(blip)

end)