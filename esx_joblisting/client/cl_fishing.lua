--[[ESX = nil

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
        local distance = #(coords - vector3(813.79,-1644.87,30.9))
        if distance < 3.5 then
            if distance < 2.0 then
                if IsControlJustReleased(1, 38) then
                    SendNUIMessage({
                        action = "open",
                        JobName = "fisherman",
                        img = "fisherman",
                        Desc = "مراحل کار ماهیگیری : <br><br> مرحله اول : به سمت رخت کن برید و لباس بردارید <br><br> مرحله دوم : با قایق به محل ماهیگیری بروید <br><br> مرحله سوم : ماهی کافی جمع کنید و به سمت مرحله بدی بروید <br><br> مر حله جهارم : به خریدار ماهی رو بفروشید  <br><br> مرحله پنجم : و به سمت محل برگردید <br><br> مرحله شیشم : و از کار خارج شوید",
                        Title = "Diamond Fishing Job",
                        color = "#058286",
                        color2 = "#058286",
                        border = "#058286",
                        box_shadow = "0 0 49px #058286",
                        buttom_shadow = "0 0 22px #058286",
                        buttom_shadow2 = "0 0 22px #058286",
                        xcolor = "#058286"
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
    RequestModel(GetHashKey("s_m_m_migrant_01"))
    while not HasModelLoaded(GetHashKey("s_m_m_migrant_01")) do
      Wait(1)
    end
    local ped =  CreatePed(1,  GetHashKey("s_m_m_migrant_01"), 813.79,-1644.87,29.9,263.15, false, false)
    SetEntityHeading(ped, 263.15)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

RegisterNUICallback("stats", function(data)
    SetNuiFocus(data.stats, data.stats)
end)

-- Create blips
Citizen.CreateThread(function()

    local blip = AddBlipForCoord(813.79,-1644.87,30.9)

    SetBlipSprite (blip, 410)
    --SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 74)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('fishing'))
    EndTextCommandSetBlipName(blip)

end)]]