local TSE = TriggerServerEvent

if Config.Shop.enabled then

RegisterNetEvent("d-houserobbery:Shop:menus", function()
    PlayPedAmbientSpeechNative(houserobberyNPC, 'Generic_Hows_It_Going', 'Speech_Params_Force')
    options = {}
    for _, v in pairs(Config.Shop.Items) do
        options[v.label] = {}
        options[v.label].arrow = false
        options[v.label].description = v.description .. v.price
        options[v.label].event = 'd-houserobbery:Shop:progress'
        options[v.label].args = { item = v.item, price = v.price, min = v.MinAmount, 
            max = v.MaxAmount }
    end
    lib.registerContext({
        id = 'Shop',
        title = Config.Shop.Header,
        options = options
    })
    lib.showContext('Shop')

end)

RegisterNetEvent("d-houserobbery:Shop:progress")
AddEventHandler("d-houserobbery:Shop:progress", function(data)
    amount = lib.inputDialog(locale("Pricefor") .. data.price, { locale("Amount") .. locale("Range") .. data.min .. ' - ' .. data.max })
    amount = tonumber(amount[1])

    if amount then
        if tonumber(amount) >= data.min and tonumber(amount) <= data.max then
            lib.callback('d-houserobbery:Shop:getitem', false, function(value)
                if value then
                    dict = "misscarsteal4@actor"
                    clip = "actor_berating_loop"
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Wait(0) end
                    TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                    ProgressBar(2500, locale("buying"))
                    ClearPedTasks(cache.ped)
                    PlayPedAmbientSpeechNative(houserobberyNPC, 'GENERIC_THANKS', 'SPEECH_PARAMS_FORCE')
                    TSE("d-houserobbery:Shop:giveitems", data.item, data.price, amount)
                else
                    Notify("error", locale("error"), locale("RequiredItems"))
                end
            end, data.price, amount)
        else
            Notify("error", locale("error"), locale("IvalidAmount"))
        end
    else
        Notify("error", locale("error"), locale("IvalidAmount"))
    end
end)

local ShopPed = nil
local Spawned = false
CreateThread(function()
    while true do
        Wait(1000)
        local Coords = GetEntityCoords(PlayerPedId())
        local distance = #(Coords - vec3(Config.Shop.Ped.coords.xyz))
        if distance < 20 and not Spawned then
            Spawned = true
            RequestModel(Config.Shop.Ped.model)

            while not HasModelLoaded(Config.Shop.Ped.model) do
                Wait(100)
            end

            houserobberyNPC = CreatePed(4, Config.Shop.Ped.model, Config.Shop.Ped.coords.x, Config.Shop.Ped.coords.y, Config.Shop.Ped.coords.z, Config.Shop.Ped.coords.w, false, true)
            ShopPed = houserobberyNPC
            if Config.InteractionType == 'textui' or Config.InteractionType == "3dtext" then
                npctxtui = lib.zones.sphere({
                    coords = GetEntityCoords(houserobberyNPC),
                    radius = 1,
                    debug = Config.Debug,
                    inside = function(self)
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('d-houserobbery:Shop:menus')
                        end

                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, string.format("[~g~E~w~] - %s", locale('buy')))
                        end
                    end,
                    onEnter = function()
                        if Config.InteractionType == "textui" then
                            TextUIShow('[E] - ' .. locale('buy'))
                        end
                    end,
                    onExit = function()
                        if Config.InteractionType == "textui" then
                            TextUIHide()
                        end
                    end
                })
            elseif Config.InteractionType == 'target' then
                SetTimeout(1000, function()
                    local target = Target()
                    if target then
                        target:AddTargetEntity(houserobberyNPC, {
                            options = {
                                {
                                    type = "client",
                                    event = "d-houserobbery:Shop:menus",
                                    icon = "fas fa-laptop",
                                    label = locale("shop"),
                                    action = function()
                                        TriggerEvent("d-houserobbery:Shop:menus")
                                    end
                                },
                            },
                            distance = 2
                        })
                    else
                        print("TEMP")
                    end
                end)
            end
            
            for i = 0, 255, 51 do
                Wait(50)
                SetEntityAlpha(houserobberyNPC, i, false)
            end
            FreezeEntityPosition(houserobberyNPC, true)
            SetEntityInvincible(houserobberyNPC, true)
            SetBlockingOfNonTemporaryEvents(houserobberyNPC, true)
            TaskStartScenarioInPlace(houserobberyNPC, Config.Shop.Ped.scenario, 0, true)
        elseif distance >= 20 and Spawned then
            for i = 255, 0, -51 do
                Wait(50)
                SetEntityAlpha(ShopPed, i, false)
            end
            DeletePed(ShopPed)
            Spawned = false
        end
    end
end)

end