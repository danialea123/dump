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
        local distance = #(coords - vector3(907.94,-2201.9,32.29))
        if distance < 3.5 then
            if distance < 2.0 then
                if IsControlJustReleased(1, 38) then
                    SendNUIMessage({
                        action = "open",
                        JobName = "miner",
                        img = "miner",
                        Desc = "مراحل کار ماینری : <br><br> مرحله اول : به سمت رخت کن برید و لباس و ماشین بردارید <br><br> مرحله دوم : با ماشین به محل ماینری بروید <br><br> مرحله سوم : متریال کافی جمع کنید و به سمت مرحله بدی بروید <br><br> مر حله جهارم : به خریدار متریال ها رو بفروشید <br><br> مرحله پنجم : و به سمت محل برگردید <br><br> مرحله شیشم : و از کار خارج شوید",
                        Title = "Diamond Miner Job",
                        color = "rgb(248, 195, 115)",
                        color2 = "rgb(248, 195, 115)",
                        border = "rgb(248, 195, 115)",
                        box_shadow = "0 0 40px rgb(248, 195, 115)",
                        buttom_shadow = "0 0 22px rgb(248, 195, 115)",
                        buttom_shadow2 = "0 0 22px rgb(248, 195, 115)",
                        xcolor = "rgb(248, 195, 115)"
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
    RequestModel(GetHashKey("s_m_m_dockwork_01"))
    while not HasModelLoaded(GetHashKey("s_m_m_dockwork_01")) do
      Wait(1)
    end
    local ped =  CreatePed(1,  GetHashKey("s_m_m_dockwork_01"), 907.94,-2201.9,31.29,270.75, false, false)
    SetEntityHeading(ped, 352.82)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

RegisterNUICallback("stats", function(data)
    SetNuiFocus(data.stats, data.stats)
end)

-- Create blips
Citizen.CreateThread(function()

    local blip = AddBlipForCoord(907.94,-2201.9,32.29)

    SetBlipSprite (blip, 618)
    --SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 46)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('miner'))
    EndTextCommandSetBlipName(blip)

end)