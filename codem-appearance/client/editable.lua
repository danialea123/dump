---@diagnostic disable: undefined-global, missing-parameter, lowercase-global
-- RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
--     TriggerServerEvent("qb-clothes:loadPlayerSkin")
--     TriggerServerEvent("codem-appearance:LoadClothingCategories")
--     TriggerServerEvent("codem-appearance:LoadSavedClothings")
--     TriggerServerEvent("codem-appearance:LoadUnpaidOutfits")
-- end)

AddEventHandler("PlayerLoadedToGround", function()
    TriggerServerEvent("codem-appearance:LoadTattoos")
    TriggerServerEvent("codem-appearance:LoadClothingCategories")
    TriggerServerEvent("codem-appearance:LoadSavedClothings")
    TriggerServerEvent("codem-appearance:LoadUnpaidOutfits")
end)

-- RegisterCommand(Config.ReloadCommand, function()
--     TriggerEvent("codem-appearance:reloadSkin")
--     ClearPedBloodDamage(PlayerPedId())
--     ResetPedVisibleDamage(PlayerPedId())
--     ClearPedLastWeaponDamage(PlayerPedId())
-- end)

CreateThread(function()
    while true do
        if menuOpen then
            FreezeEntityPosition(PlayerPedId(), true)
            if not IsEntityPlayingAnim(PlayerPedId(), "anim@amb@clubhouse@mini@darts@", "wait_idle", 3) then
                RequestAnimDict("anim@amb@clubhouse@mini@darts@")
                while not HasAnimDictLoaded("anim@amb@clubhouse@mini@darts@") do
                    Wait(0)
                end
                TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@mini@darts@", "wait_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
            end
        end
        Wait(500)
    end
end)

-- RegisterNetEvent("codem-appearance:reloadSkin")
-- AddEventHandler("codem-appearance:reloadSkin", function()
--     local skin = TriggerCallback("codem-appearance:GetSkin")
--     if skin then
--         if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
--             TriggerEvent('skinchanger:loadSkin', skin)
--         else
--             TriggerEvent('skinchanger:loadSkin', FormatQBCoreData(skin))
--         end
--     end
-- end)

-- RegisterNetEvent('qb-clothing:client:loadOutfit')
-- AddEventHandler('qb-clothing:client:loadOutfit', function(oData)
--     oData = FormatQBCoreData(oData)
--     TriggerEvent('skinchanger:loadPedSkin', oData)
-- end)

function HidePlayers()
    CreateThread(function()
        while menuOpen do
            local time = 500
            time = 1
            for _, player in ipairs(GetActivePlayers()) do
                if player ~= PlayerId() and NetworkIsPlayerActive(player) then
                    NetworkFadeInEntity(GetPlayerPed(player), true)
                end
            end
            Wait(time)
        end

        for _, player in ipairs(GetActivePlayers()) do
            if player ~= PlayerId() and NetworkIsPlayerActive(player) then
                NetworkFadeOutEntity(GetPlayerPed(player), false)
            end
        end
    end)
end

RegisterNUICallback("mainClothes", function(data, cb)
    TriggerEvent("codem-appearance:reloadSkin")
    cb("ok")
end)

-- RegisterNetEvent("qb-clothing:client:openMenu")
-- AddEventHandler("qb-clothing:client:openMenu", function()
--     OpenMenu("charcreator")
-- end)

-- RegisterNetEvent('qb-clothing:client:loadPlayerClothing')
-- AddEventHandler('qb-clothing:client:loadPlayerClothing', function(skin, ped)
--     TriggerEvent('skinchanger:loadSkin', FormatQBCoreData(skin), nil, ped)
-- end)


-- RegisterNetEvent("qb-clothes:client:CreateFirstCharacter")
-- AddEventHandler("qb-clothes:client:CreateFirstCharacter", function()
--     OpenMenu("charcreator")
-- end)

-- RegisterNetEvent("qb-clothes:loadSkin")
-- AddEventHandler("qb-clothes:loadSkin", function(_, model, data)
--     local skin = TriggerCallback("codem-appearance:GetSkin")
--     if skin then
--         local gender = Core.Functions.GetPlayerData().charinfo.gender

--         if CheckSkin(skin) then
--             local model
--             if gender == 1 then                        -- Gender is ONE for FEMALE
--                 model = GetHashKey("mp_f_freemode_01") -- Female Model
--             else
--                 model = GetHashKey("mp_m_freemode_01") -- Male Model
--             end
--             TriggerServerEvent("codem-appearance:SaveSkin", FormatQBCoreData(skin), model)
--             while not migrated do
--                 Wait(0)
--             end
--             migrated = false
--         end
--         skin = TriggerCallback("codem-appearance:GetSkin")
--         if gender == 1 then
--             TriggerEvent('skinchanger:loadDefaultModel', false, nil)
--         else
--             TriggerEvent('skinchanger:loadDefaultModel', true, nil)
--         end
--         Wait(500)
--         TriggerEvent('skinchanger:loadSkin', FormatQBCoreData(skin))
--         TriggerServerEvent("codem-appearance:LoadTattoos")
--         if Config.ClothesAsItem then
--             TriggerEvent('codem-appereance:GetClothingData')
--         end
--     else
--         local gender = Core.Functions.GetPlayerData().charinfo.gender
--         if gender == 1 then
--             TriggerEvent('skinchanger:loadDefaultModel', false, nil)
--         else
--             TriggerEvent('skinchanger:loadDefaultModel', true, nil)
--         end
--         TriggerEvent('skinchanger:change', "sex", gender)
--         TriggerEvent('skinchanger:loadSkin', { sex = gender }, OpenMenu("charcreator"))
--         TriggerServerEvent("codem-appearance:LoadTattoos")
--     end
-- end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
    OpenSaveableMenu(submitCb, cancelCb)
end)

function OpenSaveableMenu(submitCb, cancelCb)
    OpenMenu("charcreator")
    while menuOpen do
        Wait(0)
    end
    submitCb()
end

AddEventHandler('esx_skin:playerRegistered', function()
    CreateThread(function()
        if firstSpawn then
            local skin = TriggerCallback("codem-appearance:GetSkin")
            if not skin then
                TriggerEvent('skinchanger:change', "sex", 0)
                TriggerEvent('skinchanger:loadSkin', { sex = 0 }, OpenMenu("charcreator"))
                Wait(100)
            else
                if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
                    TriggerEvent('skinchanger:loadSkin', skin)
                    if Config.ClothesAsItem then
                        TriggerEvent('codem-appereance:GetClothingData')
                    end
                else
                    TriggerEvent('skinchanger:loadSkin', FormatQBCoreData(skin))
                    if Config.ClothesAsItem then
                        TriggerEvent('codem-appereance:GetClothingData')
                    end
                end
                Wait(100)
            end

            firstSpawn = false
        end
    end)
end)


AddEventHandler('esx_skin:resetFirstSpawn', function()
    playerLoaded = false
    firstSpawn = true
end)

CreateThread(function()
    Wait(3000)
    WaitCore()
    WaitPlayer()
    TriggerServerEvent("codem-appearance:LoadTattoos")
    TriggerServerEvent("codem-appearance:LoadClothingCategories")
    TriggerServerEvent("codem-appearance:LoadSavedClothings")
    TriggerServerEvent("codem-appearance:LoadUnpaidOutfits")
    local playerName = TriggerCallback("codem-appearance:GetPlayerName")
    local pp = TriggerCallback("codem-appearance:GetPlayerPP")
    NuiMessage("SET_PLAYER_NAME", playerName)
    NuiMessage("SET_OUTFIT_PRICE", Config.Clothing.price)
    NuiMessage("SET_SURGERY_PRICE", Config.Surgery.price)
    NuiMessage("SET_LOCALES", Config.Locale)
    NuiMessage("SELECTED_MONEY_TYPE", Config.MoneyType)
    NuiMessage("SET_DEFAULT_IMAGE", Config.DefaultImage)
    NuiMessage("SET_PED_PAGE", Config.PedPage)
    NuiMessage("SET_SERVER_ID", GetPlayerServerId(PlayerId()))
    NuiMessage("SET_PLAYER_PP", pp)
    LoadPlayerInformations()
end)

-- RegisterNUICallback("changePedModel", function(data, cb)
--     local model = GetHashKey(data.model)
--     RequestModel(model)
--     while not HasModelLoaded(model) do
--         Wait(0)
--     end
--     SetPlayerModel(PlayerId(), model)
--     SetModelAsNoLongerNeeded(model)
--     TriggerServerEvent("codem-appearance:savePed", data.model)
-- end)

RegisterNUICallback("randomize", function(data, cb)
    TriggerEvent("skinchanger:getData", function(components, max)
        for key, v in pairs(components) do
            if v.name ~= 'skin_mom' and v.name ~= 'skin_dad' and v.name ~= 'sex' and v.name ~= 'mask_1' and v.name ~= 'mask_2' and v.name ~= 'helmet_1' and v.name ~= 'helmet_2' and v.name ~= 'bags_1' and v.name ~= 'bags_2' then
                local value = 0
                if tonumber(v.min) > tonumber(max[v.name]) then
                    value = v.min
                else
                    value = math.random(v.min, max[v.name])
                end
                local modelType = 'female'
                if IsPedMale(PlayerPedId()) then
                    modelType = 'male'
                end
                if Config.Blacklisted[modelType][v.name] then
                    local check = true
                    TriggerEvent('skinchanger:getSkin', function(sskin)
                        local isBlacklisted = false
                        for _, item in pairs(Config.Blacklisted[modelType][v.name]) do
                            if item == tonumber(value) then
                                isBlacklisted = true
                            end
                        end
                        while isBlacklisted do
                            Wait(0)
                            if tonumber(v.min) > tonumber(max[v.name]) then
                                value = v.min + 1
                            else
                                value = math.random(v.min, max[v.name])
                            end
                            local blacklisted = false
                            for _, item in pairs(Config.Blacklisted[modelType][v.name]) do
                                if item == tonumber(value) then
                                    blacklisted = true
                                end
                            end
                            isBlacklisted = blacklisted
                        end
                        check = false
                    end)
                    while check do
                        Wait(0)
                    end
                end
                TriggerEvent("skinchanger:change", v.name, tonumber(value))
            end
        end
        local skin = GetSkin()
        NuiMessage("SET_SKIN", skin)
    end)
end)
local textUICache = false

function ShowHelpNotification(text)
    if Config.TextUIHandler == 'default' then
        AddTextEntry('helpNotification', text)
        DisplayHelpTextThisFrame('helpNotification', false)
    end
    if not textUICache then
        if Config.TextUIHandler == 'esx_textui' then
            TriggerEvent('ESX:TextUI', text)
        end
        if Config.TextUIHandler == 'qb_default_textui' then
            TriggerEvent('qb-core:client:DrawText', text, 'left')
        end

        if Config.TextUIHandler == 'custom' then
            -- Your code here
        end
        textUICache = true
    end
end

function HideHelpNotification()
    if textUICache then
        if Config.TextUIHandler == 'esx_textui' then
            TriggerEvent('ESX:HideUI')
        end
        if Config.TextUIHandler == 'qb_default_textui' then
            TriggerEvent('qb-core:client:HideText')
        end
        if Config.TextUIHandler == 'custom' then
            -- Your code here
        end
        textUICache = false
    end
end

function Close()
    SetNuiFocus(false, false)
    DisableCam()
    DisplayRadar(true)
    accessoryCache = {}
    menuOpen = false
    ClearPedTasks(PlayerPedId())
    local defaultHeading = GetEntityHeading(PlayerPedId())
    local c = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0)
    SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 30.0)
    TaskLookAtCoord(PlayerPedId(), c, 1, 2048, 3)
    ResetBasket()
    TriggerServerEvent("codem-appearance:UpdateBucket", false)
    prevSkin = {}
    tattooBasket = {}
    if currentCharacterPage ~= 'job' then
        local skin = TriggerCallback("codem-appearance:GetSkin")
        if Config.Framework == 'qb' or Config.Framework == 'oldqb' then
            skin = FormatQBCoreData(skin)
        end
        TriggerEvent('skinchanger:loadSkin', skin)
    end
    TriggerEvent("codem-appearance:LoadTattoos", currentTattoos)
    currentCharacterPage = false
    FreezeEntityPosition(PlayerPedId(), false)
    Config.OnMenuClose()
end

-- RegisterNetEvent('codem-appearance:syncPed')
-- AddEventHandler('codem-appearance:syncPed', function(ped)
--     if ped then
--         local pedModel = GetHashKey(ped)
--         RequestModel(pedModel)
--         while not HasModelLoaded(pedModel) do
--             Wait(0)
--         end
--         SetPlayerModel(PlayerId(), pedModel)
--         SetModelAsNoLongerNeeded(pedModel)
--     else
--         OpenMenu("charcreator")
--     end
-- end)

-- RegisterCommand(Config.PedReloadCommand, function()
--     TriggerServerEvent('codem-appearance:LoadPeds')
-- end)



RegisterNUICallback('saveSkin', function(data, cb)
    local success = true
    local saveClothing = data and data.saveClothing or false
    local clothingName = data and data.clothingName or false

    if currentCharacterPage == 'barber' then
        local price = GetBasketPrice()
        if price > 0 then
            success = TriggerCallback("codem-appearance:PayBasket", price)
        end
    end
    if currentCharacterPage == 'binco' or currentCharacterPage == 'ponsonbys' or currentCharacterPage == 'suburban' then
        local price = Config.Clothing.price
        if price > 0 then
            success = TriggerCallback("codem-appearance:PayBasket", price)
        end
    end

    if currentCharacterPage == 'surgery' then
        local price = Config.Surgery.price
        if price > 0 then
            success = TriggerCallback("codem-appearance:PayBasket", price)
        end
    end
    if success then
        if currentCharacterPage == 'barber' then
            local skin = TriggerCallback("codem-appearance:GetSkin")
            if Config.Framework == 'qb' or Config.Framework == 'oldqb' then
                skin = FormatQBCoreData(skin)
            end
            for _, v in pairs(accessoryCache) do
                TriggerEvent("skinchanger:change", _, tonumber(skin[_]))
            end
        end
        TriggerEvent('skinchanger:getSkin', function(skin)
            if not Config.ClothesAsItem or (currentCharacterPage == 'charcreator' or currentCharacterPage == 'barber') then
                TriggerCallback("codem-appearance:SaveSkin", { skin = skin, model = GetEntityModel(PlayerPedId()) })
                if saveClothing then
                    TriggerServerEvent("codem-appearance:SaveClothing", clothingName, skin)
                end
                if Config.ClothesAsItem then
                    TriggerEvent('codem-appereance:GetClothingData')
                end
            else
                local outfitData = CreateOutfitData(skin)
                TriggerServerEvent('codem-apperance:GiveOutfit', outfitData)
            end
            NuiMessage("CLOSE_PAGE")
            if currentCharacterPage == 'charcreator' then
                Config.OnCharacterCreated()
            end
        end)
    else
        TriggerEvent("codem-appearance:SendNotification", Config.Locale["noMoney"])
    end
    cb("ok")
end)

-- RegisterNetEvent('codem-appereance:UseOutfit')
-- AddEventHandler('codem-appereance:UseOutfit', function(item)
--     local player = PlayerPedId()
--     if item.name == 'torso_1' then
--         RequestAnimDict('missmic4')
--         TaskPlayAnim(player, 'missmic4', 'michael_tux_fidget', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "torso_2", item.info.texture)
--     end
--     if item.name == 'tshirt_1' then
--         RequestAnimDict('missmic4')
--         TaskPlayAnim(player, 'missmic4', 'michael_tux_fidget', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "tshirt_2", item.info.texture)
--     end
--     if item.name == 'arms' then
--         RequestAnimDict('nmt_3_rcm-10')
--         TaskPlayAnim(player, 'nmt_3_rcm-10', 'cs_nigel_dual-10', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "arms_2", item.info.texture)
--     end
--     if item.name == 'pants_1' then
--         RequestAnimDict('random@domestic')
--         TaskPlayAnim(player, 'random@domestic', 'pickup_low', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "pants_2", item.info.texture)
--     end
--     if item.name == 'shoes_1' then
--         RequestAnimDict('random@domestic')
--         TaskPlayAnim(player, 'random@domestic', 'pickup_low', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "shoes_2", item.info.texture)
--     end
--     if item.name == 'mask_1' then
--         RequestAnimDict('mp_masks@standard_car@ds@')
--         TaskPlayAnim(player, 'mp_masks@standard_car@ds@', 'put_on_mask', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "mask_2", item.info.texture)
--     end
--     if item.name == 'bproof_1' then
--         RequestAnimDict('clothingtie')
--         TaskPlayAnim(player, 'clothingtie', 'try_tie_negative_a', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "bproof_2", item.info.texture)
--     end
--     if item.name == 'chain_1' then
--         RequestAnimDict('clothingtie')
--         TaskPlayAnim(player, 'clothingtie', 'try_tie_positive_a', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "chain_2", item.info.texture)
--     end
--     if item.name == 'helmet_1' then
--         RequestAnimDict('clothingtie')
--         TaskPlayAnim(player, 'clothingtie', 'check_out_a', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "helmet_2", item.info.texture)
--     end
--     if item.name == 'glasses_1' then
--         RequestAnimDict('mp_masks@standard_car@ds@')
--         TaskPlayAnim(player, 'mp_masks@standard_car@ds@', 'put_on_mask', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "glasses_2", item.info.texture)
--     end
--     if item.name == 'watches_1' then
--         RequestAnimDict('nmt_3_rcm-10')
--         TaskPlayAnim(player, 'nmt_3_rcm-10', 'cs_nigel_dual-10', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "watches_2", item.info.texture)
--     end
--     if item.name == 'bracelets_1' then
--         RequestAnimDict('nmt_3_rcm-10')
--         TaskPlayAnim(player, 'nmt_3_rcm-10', 'cs_nigel_dual-10', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "bracelets_2", item.info.texture)
--     end
--     if item.name == 'bags_1' then
--         RequestAnimDict('anim@heists@ornate_bank@grab_cash')
--         TaskPlayAnim(player, 'anim@heists@ornate_bank@grab_cash', 'intro', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
--         Wait(1750)
--         ClearPedTasks(player)
--         TriggerEvent("skinchanger:change", item.name, item.info.skin)
--         TriggerEvent("skinchanger:change", "bags_2", item.info.texture)
--     end
--     TriggerEvent('skinchanger:getSkin', function(skin)
--         TriggerCallback("codem-appearance:SaveSkin", { skin = skin, model = GetEntityModel(PlayerPedId()) })
--     end)
-- end)




-- RegisterNetEvent('codem-inventory:client:takeoffClothing', function(itemname, clotingvalue)
--     local pedModel = GetEntityModel(PlayerPedId())
--     local skinData = {}
--     if pedModel == `mp_m_freemode_01` then
--         skinData.sex = 0
--         skinData[itemname] = clotingvalue
--     else
--         skinData.sex = 1
--         skinData[itemname] = clotingvalue
--     end

--     TriggerEvent('skinchanger:loadSkin', skinData)
-- end)


-- RegisterNetEvent('codem-appereance:GetClothingData')
-- AddEventHandler('codem-appereance:GetClothingData', function()
--     local pedModel = GetEntityModel(PlayerPedId())
--     if pedModel == `mp_m_freemode_01` then
--         TriggerServerEvent('codem-inventory:server:GetPlayerClothing', ClothingData(), 'man')
--     else
--         TriggerServerEvent('codem-inventory:server:GetPlayerClothing', ClothingData(), 'woman')
--     end
-- end)

function ClothingData()
    local ped = PlayerPedId()
    return {
        arms = {
            value = GetPedDrawableVariation(ped, 3),
            texture = GetPedTextureVariation(ped, 3),
        },
        tshirt_1 = {
            value = GetPedDrawableVariation(ped, 8),
            texture = GetPedTextureVariation(ped, 8),
        },
        torso_1 = {
            value = GetPedDrawableVariation(ped, 11),
            texture = GetPedTextureVariation(ped, 11),
        },
        pants_1 = {
            value = GetPedDrawableVariation(ped, 4),
            texture = GetPedTextureVariation(ped, 4),
        },
        shoes_1 = {
            value = GetPedDrawableVariation(ped, 6),
            texture = GetPedTextureVariation(ped, 6),
        },
        mask_1 = {
            value = GetPedDrawableVariation(ped, 1),
            texture = GetPedTextureVariation(ped, 1),
        },
        bproof_1 = {
            value = GetPedDrawableVariation(ped, 9),
            texture = GetPedTextureVariation(ped, 9),
        },
        chain_1 = {
            value = GetPedDrawableVariation(ped, 7),
            texture = GetPedTextureVariation(ped, 7),
        },
        helmet_1 = {
            value = GetPedPropIndex(ped, 0),
            texture = GetPedPropTextureIndex(ped, 0),
        },
        glasses_1 = {
            value = GetPedPropIndex(ped, 1),
            texture = GetPedPropTextureIndex(ped, 1),
        },
        watches_1 = {
            value = GetPedPropIndex(ped, 6),
            texture = GetPedPropTextureIndex(ped, 6),
        },
        bracelets_1 = {
            value = GetPedPropIndex(ped, 7),
            texture = GetPedPropTextureIndex(ped, 7),
        },
        bags_1 = {
            value = GetPedDrawableVariation(ped, 5),
            texture = GetPedTextureVariation(ped, 5),
        },
    }
end
