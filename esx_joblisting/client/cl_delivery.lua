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
        local distance = #(coords - vector3(133.1, 96.65, 83.51))
        if distance < 3.5 then
            if distance < 2.0 then
                if IsControlJustReleased(1, 38) then
                    SendNUIMessage({
                        action = "open",
                        JobName = "delivery",
                        img = "delivery",
                        Desc = " مراحل کار باربری : <br><br> مرحله اول : به سمت رخت کن برید و لباس و ماشین بردارید <br><br> مرحله دوم : با ماشین به محل چوب باربری بروید <br><br> مرحله سوم : بسته های کافی جمع کنید و به سمت مرحله بدی بروید <br><br> مر حله جهارم : به خریدار بسته ها رو تحویل دهید <br><br> مرحله پنجم : و به سمت محل برگردید <br><br> مرحله شیشم : و از کار خارج شوید",
                        Title = "Diamond Delivery Job",
                        color = "#0b4250",
                        color2 = "#0b4250",
                        border = "#0b4250",
                        box_shadow = "0 0 40px #0b4250",
                        buttom_shadow = "0 0 22px #0b4250",
                        buttom_shadow2 = "0 0 22px #0b4250",
                        xcolor = "#0b4250"
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
    RequestModel(GetHashKey("u_m_m_fibarchitect"))
    while not HasModelLoaded(GetHashKey("u_m_m_fibarchitect")) do
      Wait(1)
    end
    local ped =  CreatePed(1,  0x342333D3, 133.1, 96.65, 82.51, 159.3, false, false)
    SetEntityHeading(ped, 165.91)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

RegisterNUICallback("stats", function(data)
    SetNuiFocus(data.stats, data.stats)
end)

-- Create blips
Citizen.CreateThread(function()

    local blip = AddBlipForCoord(133.1, 96.65, 83.51)

    SetBlipSprite (blip, 478)
    --SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 2)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('delivery'))
    EndTextCommandSetBlipName(blip)

end)