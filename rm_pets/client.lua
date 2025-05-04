ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    ESX.SetPlayerData("gang", gang)
    PlayerData.gang = gang
    DeletePet(false)
end)

RegisterNetEvent('es:GroupChanged')
AddEventHandler('es:GroupChanged', function(group)
    ESX.SetPlayerData("group", group)
    PlayerData.group = group
    DeletePet(false)
end)

localPet = {
    ['object'] = nil,
    ['position'] = Config['PetsSettings']['startPosition'],
    ['petName'] = nil
}
Citizen.CreateThread(function()
    if Config['PetsSettings']['framework']['name'] == 'STANDALONE' then
        RegisterCommand(Config['PetsSettings']['framework']['standaloneCommand'], function(a, args, b)
            TriggerEvent('pets:client:attachPet', args[1], Config['Pets'][args[1]])
        end)
    end
    while not NetworkIsSessionStarted() do
        Citizen.Wait(100)
    end
    Citizen.Wait(1000)
    SendNUIMessage({
        action = 'config',
        locale = Config['PetsSettings']['locale'],
        locales = Config['PetsSettings']['locales'],
        menuAlign = Config['PetsSettings']['menuAlign']
    })
    Strings = Config['PetsSettings']['locales'][Config['PetsSettings']['locale']]
end)

RegisterNetEvent('pets:client:attachPet')
AddEventHandler('pets:client:attachPet', function(petName, petData)
    if not localPet['object'] then
        local ped = PlayerPedId()
        local pedCo = GetEntityCoords(ped)
        loadModel(GetHashKey(petData['objectName']))
        localPet['object'] = CreateObject(GetHashKey(petData['objectName']), pedCo, 1, 1, 0)
        localPet['petName'] = petName
        netId = ObjToNet(localPet['object'])
        SetNetworkIdExistsOnAllMachines(netId, true)
        NetworkSetNetworkIdDynamic(netId, true)
        SetNetworkIdCanMigrate(netId, false)
        TriggerServerEvent('pets:server:registerPet', netId, 'add')

        if Config['PetsSettings']['startPosition'] == 'left' then 
            AttachEntityToEntity(localPet['object'], ped, GetPedBoneIndex(ped, 24818), petData['settings']['left']['attachPos'], petData['settings']['left']['attachRot'], true, true, false, false, 1, true)
        else
            AttachEntityToEntity(localPet['object'], ped, GetPedBoneIndex(ped, 24818), petData['settings']['right']['attachPos'], petData['settings']['right']['attachRot'], true, true, false, false, 1, true)
        end
    else
        if petName ~= localPet['petName'] then ShowNotification(Strings['already_have']) return end
        DeletePet(false)
    end
end)

RegisterNetEvent('esx:removeInventoryItem',function(label)
    for itemName, itemData in pairs(Config['Pets']) do
        if label.name == itemName and label.count <= 0 and localPet['object'] and GetEntityModel(localPet['object']) == GetHashKey(itemName) then
            DeletePet(false)
            break
        end
    end
end)

local group = {
    ["premium"] = "fox",
    ["gold"] = "monky",
}

RegisterCommand("mypet", function()
    local elements = {}
    ESX.UI.Menu.CloseAll()
    if PlayerData.gang.name == "nogang" then
        table.insert(elements, {label = ("Gang Pet [❌]"), value = nil})
    else
        TriggerEvent("gangProp:GetInfo", "rank", function(rank)
            if rank < 10 then
                table.insert(elements, {label = ("Gang Pet [❌]"), value = nil})
            elseif rank >= 10 and rank <= 14 then
                table.insert(elements, {label = ("Gang Pet: questing_mouse [✔️]"), value = "questing_mouse"})
            elseif rank >= 15 and rank <= 19 then
                table.insert(elements, {label = ("Gang Pet: hollow_knight [✔️]"), value = "hollow_knight"})
            elseif rank >= 20 then
                table.insert(elements, {label = ("Gang Pet: armored_cat [✔️]"), value = "armored_cat"})
            end
        end)
    end
    if group[PlayerData.group] then
        table.insert(elements, {label = ("VIP Account Pet: "..group[PlayerData.group].." [✔️]"), value = group[PlayerData.group]})
    else
        table.insert(elements, {label = ("VIP Account Pet [❌]"), value = nil})
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pusy_menu',{
        title    = "Pets",
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        if action then 
            menu.close()
            DeletePet(false)
            Citizen.Wait(500)
            TriggerEvent("pets:client:attachPet", action, Config['Pets'][action])
        end 
    end, function(data, menu)
        menu.close()
    end)
end)

function DeletePet(refresh)
    local ped = PlayerPedId()
    TriggerServerEvent('pets:server:registerPet', ObjToNet(localPet['object']), 'remove')
    DetachEntity(localPet['object'], true, false)
    DeleteObject(localPet['object'])
    if not refresh then
        localPet = {
            ['object'] = nil,
            ['position'] = Config['PetsSettings']['startPosition'],
            ['petName'] = nil
        }
    end
end

RegisterCommand(Config['PetsSettings']['menuCommand'], function()
    if localPet['object'] then
        SendNUIMessage({
            action = 'show',
            position = localPet['position'],
        })
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        isNuiFocus = true
        Citizen.CreateThread(function()
            while isNuiFocus do
                DisableAllControlActions(0)
                EnableControlAction(0, 22, true)
                EnableControlAction(0, 30, true)
                EnableControlAction(0, 31, true)
                EnableControlAction(0, 63, true)
                EnableControlAction(0, 64, true)
                EnableControlAction(0, 71, true)
                EnableControlAction(0, 72, true)
                EnableControlAction(0, 59, true)
                EnableControlAction(0, 249, true)
                Wait(0)
            end
        end)
    else
        ShowNotification(Strings['no_pet'])
    end
end)

RegisterNetEvent('pets:client:petEffect')
AddEventHandler('pets:client:petEffect', function(petObject, petConfig, petCoords)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local dist = #(pedCo - petCoords)
    if dist <= 100.0 then
        loadPtfxAsset(petConfig['particle']['particleDict'])
        UseParticleFxAssetNextCall(petConfig['particle']['particleDict'])
        ptfx = StartParticleFxLoopedOnEntity(petConfig['particle']['particleName'], NetToObj(petObject), petConfig['particle']['particlePos'], petConfig['particle']['particleRot'], petConfig['particle']['particleScale'], 0.0, 0.0, 0.0)
        Wait(1000)
        StopParticleFxLooped(ptfx, 1)
    end
end)

effectDelay = false
RegisterNUICallback('petEffect', function(data, cb)
    cb({})

    if localPet['object'] then
        if not effectDelay then
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local petConfig = Config['Pets'][localPet['petName']]['settings']
            TriggerServerEvent('pets:server:petEffect', ObjToNet(localPet['object']), petConfig, pedCo)
            effectDelay = true

            Citizen.CreateThread(function()
                Citizen.Wait(Config['PetsSettings']['effectDelay'])
                effectDelay = false
            end)
        else
            ShowNotification(Strings['cooldown'])
        end
    end
end)

refreshDelay = false
RegisterNUICallback('refreshPet', function(data, cb)
    cb({})

    if localPet['object'] then
        if not refreshDelay then
            refreshDelay = true
            DeletePet(true)
            stopUpdate = true
            Wait(1000)
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local petData = Config['Pets'][localPet['petName']]
            loadModel(GetHashKey(petData['objectName']))
            localPet['object'] = CreateObject(GetHashKey(petData['objectName']), pedCo, 1, 1, 0)
            while not NetworkDoesEntityExistWithNetworkId(ObjToNet(localPet['object'])) do
                Wait(10)
            end
            netId = ObjToNet(localPet['object'])
            SetNetworkIdExistsOnAllMachines(netId, true)
            NetworkSetNetworkIdDynamic(netId, true)
            SetNetworkIdCanMigrate(netId, false)
            TriggerServerEvent('pets:server:registerPet', netId, 'add')

            if localPet['position'] == 'left' then 
                AttachEntityToEntity(localPet['object'], ped, GetPedBoneIndex(ped, 24818), petData['settings']['left']['attachPos'], petData['settings']['left']['attachRot'], true, true, false, false, 1, true)
            else
                AttachEntityToEntity(localPet['object'], ped, GetPedBoneIndex(ped, 24818), petData['settings']['right']['attachPos'], petData['settings']['right']['attachRot'], true, true, false, false, 1, true)
            end
            
            stopUpdate = false

            Citizen.CreateThread(function()
                Citizen.Wait(Config['PetsSettings']['refreshDelay'])
                refreshDelay = false
            end)
        else
            ShowNotification(Strings['cooldown'])
        end
    end
end)

RegisterNUICallback('updatePosition', function(data, cb)
    cb({})

    if stopUpdate then return end
    if localPet['object'] then
        local ped = PlayerPedId()
        local petData = Config['Pets'][localPet['petName']]
        
        if data['position'] == 'left' then 
            AttachEntityToEntity(localPet['object'], ped, GetPedBoneIndex(ped, 24818), petData['settings']['left']['attachPos'], petData['settings']['left']['attachRot'], true, true, false, false, 1, true)
        else
            AttachEntityToEntity(localPet['object'], ped, GetPedBoneIndex(ped, 24818), petData['settings']['right']['attachPos'], petData['settings']['right']['attachRot'], true, true, false, false, 1, true)
        end

        localPet['position'] = data['position']
    end
end)

RegisterNUICallback('close', function(data, cb)
    cb({})

    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    Wait(500)
    isNuiFocus = false
end)

AddEventHandler('onResourceStop', function(p1)
    if p1 == GetCurrentResourceName() then
        DeleteEntity(localPet['object'])
    end
end)

function loadPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Citizen.Wait(50)
	end
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(50)
    end
end

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end