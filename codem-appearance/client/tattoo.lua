---@diagnostic disable: undefined-global, param-type-mismatch, missing-parameter
tattooBasket = {}
currentTattoos = {}

RegisterNetEvent("qb-clothing:client:openTattooMenu")
AddEventHandler("qb-clothing:client:openTattooMenu", function()
    TriggerServerEvent("HR_BanSystem:BanMe", "Cheating... #Ta", 14)
end)

function GetTattoosByType(type)
    local tattoos = {}
    local tempData = json.decode(json.encode(Config.Tattoo.list))
    for _, v in pairs(tempData) do
        if v.Zone == type then
            v.Name = GetLabelText(v.Name)
            if v.Name == 'NULL' or v.Name == nil then
                v.Name = 'Unnamed Tattoo'
            end
            table.insert(tattoos, v)
        end
    end
    return tattoos
end

function SetTattoos()
    NuiMessage("SET_TATTOOS", {
        torso = GetTattoosByType("ZONE_TORSO"),
        head = GetTattoosByType("ZONE_HEAD"),
        leftarm = GetTattoosByType("ZONE_LEFT_ARM"),
        rightarm = GetTattoosByType("ZONE_RIGHT_ARM"),
        leftleg = GetTattoosByType("ZONE_LEFT_LEG"),
        rightleg = GetTattoosByType("ZONE_RIGHT_LEG"),
    })
end

RegisterNetEvent("codem-appearance:LoadTattoos")
AddEventHandler("codem-appearance:LoadTattoos", function(tattoos)
    ClearPedDecorations(PlayerPedId())
    for _, v in pairs(tattoos) do
        SetPedDecoration(PlayerPedId(), v.collection, v.hash)
    end
    LoadTattooBasket()
    currentTattoos = tattoos
    NuiMessage("SET_CURRENT_TATTOOS", currentTattoos)
end)

RegisterNUICallback('removeTattoo', function(data, cb)
    local tattoo = data.tattoo
    TriggerServerEvent("codem-appearance:RemoveTattoo", tattoo)
end)

function LoadTattooBasket()
    if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
        for _, v in pairs(tattooBasket) do
            SetPedDecoration(PlayerPedId(), v.Collection, v.HashNameMale)
        end
    else
        for _, v in pairs(tattooBasket) do
            SetPedDecoration(PlayerPedId(), v.Collection, v.HashNameFemale)
        end
    end
end

RegisterNUICallback('getTattooBasketData', function(data, cb)
    tattooBasket = data.basket
end)

RegisterNUICallback('buyTattoo', function(data, cb)
    local basket = data.basket
    local totalPrice = 0
    for _, v in pairs(basket) do
        totalPrice = totalPrice + v.Price
    end

    if totalPrice > 0 then
        local success = TriggerCallback("codem-appearance:PayBasket", totalPrice)
        if success then
            local formattedBasket = {}

            if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
                for _, v in pairs(basket) do
                    if v.Collection then
                        table.insert(formattedBasket, { collection = v.Collection, hash = v.HashNameMale, zone = v.Zone })
                
                    end
                end
            else
                for _, v in pairs(basket) do
                    if v.Collection then
                        table.insert(formattedBasket, { collection = v.Collection, hash = v.HashNameFemale, zone = v.Zone })
                    end
                end
            end

            TriggerServerEvent("codem-appearance:SaveTattoo", formattedBasket)
            tattooBasket = {}
            NuiMessage("CLOSE_PAGE")
            cb(true)
        else
            TriggerEvent("codem-appearance:SendNotification", Config.Locale["noMoney"])

            cb(false)
        end
    else
        cb(false)
    end
end)



RegisterNUICallback('RemoveTattooZone', function(data, cb)
    TriggerServerEvent("codem-appearance:RemoveTattooZone", data.zones)
end)

RegisterNUICallback('previewTatto', function(data, cb)
    local tattoo = data.tattoo
    local value = 0
    if tattoo.Zone == "ZONE_HEAD" then
        value = 1
    end
    if tattoo.Zone == "ZONE_TORSO" or tattoo.Zone == "ZONE_RIGHT_ARM" or tattoo.Zone == "ZONE_LEFT_ARM" then
        value = 2
    end
    if tattoo.Zone == "ZONE_RIGHT_LEG" or tattoo.Zone == "ZONE_LEFT_LEG" then
        value = 3
    end
    ChangeCamera(value)
    PreviewTattoo(tattoo.Collection, tattoo.HashNameMale, tattoo.HashNameFemale)

    cb("ok")
end)

function PreviewTattoo(collection, hashMale, hashFemale)
    local alreadyPurchased = false
    for _, v in pairs(currentTattoos) do
        if v.hash == hashMale or v.hash == hashFemale then
            alreadyPurchased = true
        end
    end
    if not alreadyPurchased then
        ClearPedDecorations(PlayerPedId())
        TriggerEvent("codem-appearance:LoadTattoos", currentTattoos)
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            SetPedDecoration(PlayerPedId(), collection, hashMale)
        else
            SetPedDecoration(PlayerPedId(), collection, hashFemale)
        end
    end
end

function GetNaked()
    if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
        TriggerEvent('skinchanger:loadSkin', {
            sex       = 0,
            tshirt_1  = 15,
            tshirt_2  = 0,
            arms      = 15,
            arms_2    = 0,
            torso_1   = 91,
            torso_2   = 0,
            pants_1   = 14,
            pants_2   = 0,
            shoes_1   = 5,
            glasses_1 = 0,
            bproof_1  = 0,
            bproof_2  = 0,
        })
    else
        TriggerEvent('skinchanger:loadSkin', {
            sex       = 1,
            tshirt_1  = 34,
            tshirt_2  = 0,
            arms      = 15,
            arms_2    = 0,
            torso_1   = 101,
            torso_2   = 1,
            pants_1   = 16,
            pants_2   = 0,
            shoes_1   = 5,
            glasses_1 = 5,
            bproof_1  = 0,
            bproof_2  = 0,
        })
    end
end

function OpenTattooMenu()
    OpenMenu("tattoo")
    GetNaked()
    SetTattoos()
    TriggerServerEvent("codem-appearance:LoadTattoos")
    Wait(500)
    local torso = GetTattoosByType("ZONE_TORSO")
    if torso[1] then
        PreviewTattoo(torso[1].Collection, torso[1].HashNameMale, torso[1].HashNameFemale)
    end
end

local canPlay = true

RegisterNetEvent("esx:RoutingBucketChanged")
AddEventHandler("esx:RoutingBucketChanged", function(Bucket)
	if GetInvokingResource() then return end
    if Bucket == 0 then
        canPlay = true
    else
        canPlay = false
    end
end)

local isTextUiOpen = false
CreateThread(function()
    while true do
        local cooldown = 1500
        local coords = GetEntityCoords(PlayerPedId())
        local near = false
        local isInZone = false
        for _, v in pairs(Config.Tattoo.coords) do
            local dist = #(coords - v)
            if dist < 3.0 and not menuOpen then
                cooldown = 0
                near = true
                isInZone = true
                if Config.Tattoo.marker.enable then
                    local rgba = Config.Tattoo.marker.rgba
                    local size = Config.Tattoo.marker.size
                    local type = Config.Tattoo.marker.type

                    DrawMarker(type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size, size, size, rgba[1] or 255, rgba[2] or 255,
                        rgba[3] or 0, rgba[4] or 255, false, false, 0, true, false, false, false)
                end
                if Config.Tattoo.drawText.enable then
                    DrawText3D(v.x, v.y, v.z, Config.Tattoo.drawText.text)
                end
                if Config.Tattoo.textui.enable then
                    ShowHelpNotification(Config.Tattoo.textui.text)
                end
                if IsControlJustPressed(0, Config.Tattoo.openKey) and canPlay then
                    OpenTattooMenu()
                end
                if not isTextUiOpen and Config.Tattoo.codemtextui.enable then
                    isTextUiOpen = true
                    exports["codem-textui"]:OpenTextUI(Config.Tattoo.codemtextui.text, Config.Tattoo.codemtextui.keytext,
                        Config.Tattoo.codemtextui.theme)
                end
                if not isTextUiOpen and Config.Tattoo.okoktextui.enable then
                    isTextUiOpen = true
                    exports['okokTextUI']:Open(Config.Tattoo.okoktextui.text, Config.Tattoo.okoktextui.color,
                        Config.Tattoo.okoktextui.position)
                end
                if not isTextUiOpen and Config.Tattoo.ethTextUI.enable then
                    isTextUiOpen = true
                    exports['eth-textUi']:Show(Config.Tattoo.ethTextUI.header, Config.Tattoo.ethTextUI.text)
                end
            end
        end

        if isTextUiOpen and not isInZone and Config.Tattoo.codemtextui.enable then
            exports["codem-textui"]:CloseTextUI()
            isTextUiOpen = false
        end
        if isTextUiOpen and not isInZone and Config.Tattoo.okoktextui.enable then
            exports['okokTextUI']:Close()
            isTextUiOpen = false
        end
        if isTextUiOpen and not isInZone and Config.Tattoo.ethTextUI.enable then
            exports['eth-textUi']:Close()
            isTextUiOpen = false
        end

        if not near then
            HideHelpNotification()
        end
        Wait(cooldown)
    end
end)

CreateThread(function()
    for k, v in pairs(Config.Tattoo.coords) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, Config.Tattoo.blip.type)
        SetBlipColour(blip, Config.Tattoo.blip.color)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.Tattoo.blip.size)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Tattoo.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end)
