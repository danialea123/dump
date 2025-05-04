local animPrefix = 'cellphone_'
local playerPhones = {}
local playerState = LocalPlayer.state

Animation = {
    OpenPhone = function()
        DoPhoneAnimation(animPrefix .. 'text_in')
    end,
    ClosePhone = function()
        DoPhoneAnimation(animPrefix .. 'text_out')

        Animation.Reset()
    end,
    TextToCall = function()
        DoPhoneAnimation(animPrefix .. 'text_to_call')
    end,
    CallToText = function()
        DoPhoneAnimation(animPrefix .. 'call_to_text')
    end,
    PocketToCall = function()
        PhoneModelSync()

        DoPhoneAnimation(animPrefix .. 'call_listen_base')
    end,
    CallToPocket = function()
        DoPhoneAnimation(animPrefix .. 'call_out')

        Animation.Reset()
    end,
    Selfie = function()
        DoPhoneAnimation('selfie', 'self')
    end,
    SelfieIn = function()
        DoPhoneAnimation('selfie_in', 'self')
    end,
    SelfieOut = function()
        DoPhoneAnimation('selfie_out', 'self')
    end,
    InCar = function()
        DoPhoneAnimation('cellphone_text_read_base')
    end,
    Reset = function(immediately)
        SetTimeout(immediately and 0 or 500, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)

            ClearPedTasks(PlayerPedId())

            DeletePhone()
        end)

        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end,
}

local function checkAnimationLoop()
    CreateThread(function()
        while PhoneData.AnimationData.lib ~= nil and PhoneData.AnimationData.anim ~= nil do
            local ped = PlayerPedId()
            if not IsEntityPlayingAnim(ped, PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 3) then
                lib.playAnim(ped, PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 3.0, 3.0, -1, 50, 0, false,
                    false, false)
            end
            Wait(1250)
        end
    end)
end

local function createPhoneProp(ped, model)
    local coords = GetEntityCoords(ped)
    local phone = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)

    local zRot = (string.find(model, "fold") and not PhoneFolded) and 200.0 or 180.0

    AttachEntityToEntity(phone, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, zRot, true, true, false, true,
        2, true)
    SetModelAsNoLongerNeeded(model)

    return phone
end

local function isEntityAPhone(model)
    return
        model == `prop_y24-black`
        or model == `prop_yflip-gold`
        or model == `prop_yflip-mint`
        or model == `prop_y24-silver`
        or model == `prop_y24-violet`
        or model == `prop_y24-yellow`
        or model == `prop_yphone-blue`
        or model == `prop_yfold-black`
        or model == `prop_yphone-black`
        or model == `prop_yphone-white`
        or model == `prop_yflip-graphite`
        or model == `prop_yflip-lavender`
        or model == `prop_yphone-natural`
        or model == `prop_yfold-black-open`
        or model == `prop_yphone-fold-black`
        or model == `prop_yphone-fold-black-open`
end

local function deletePhoneProp(serverId)
    local playerId = GetPlayerFromServerId(serverId)
    if playerId ~= -1 then
        for _, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(GetPlayerPed(playerId), v) then
                local phoneModel = GetEntityModel(v)
                if isEntityAPhone(phoneModel) then
                    SetEntityAsMissionEntity(v, false, false)
                    DeleteObject(v)
                    DeleteEntity(v)
                end
            end
        end
    end
end

CreateThread(function()
    while true do
        local coords = GetEntityCoords(GetPlayerPed(-1))
        for serverId, v in pairs(playerPhones) do
            local playerId = GetPlayerFromServerId(serverId)
            if v and playerId ~= -1 then
                local distance = #(GetEntityCoords(GetPlayerPed(playerId)) - coords)
                if v.spawn and distance > 150.0 then
                    playerPhones[serverId].spawn = false
                    deletePhoneProp(serverId)
                elseif not v.spawn and distance <= 150.0 then
                    createPhoneProp(GetPlayerPed(playerId), playerPhones[serverId].value)
                    playerPhones[serverId].spawn = true
                end
            end
        end
        Wait(1500)
    end
end)

AddStateBagChangeHandler('phoneProp', '', function(bagName, key, value, reserved, replicated)
    -- if replicated then return end
    local player = GetPlayerFromStateBagName(bagName)
    if player == 0 then return end

    local ped = GetPlayerPed(player)
    local serverId = GetPlayerServerId(player)

    if not value then
        playerPhones[serverId] = nil
        return deletePhoneProp(serverId)
    end

    playerPhones[serverId] = { value = value, spwan = true }
    createPhoneProp(ped, value)
end)

RegisterNetEvent('onPlayerDropped', function(serverId)
    playerPhones[serverId] = nil
    deletePhoneProp(serverId)
end)

-- Prop sync
function PhoneModelSync()
    DeletePhone()

    local hash = GetPhoneModelHash()
    if hash then
        playerState:set('phoneProp', hash, true)
    end
end

function DeletePhone()
    playerState:set('phoneProp', nil, true)
end

function DoPhoneAnimation(anim, extraDict, override)
    debugPrint('DoPhoneAnimation', anim, extraDict, override)

    local ped = PlayerPedId()
    local AnimationLib = 'cellphone@'
    local AnimationStatus = anim

    if IsPedInAnyVehicle(ped, false) then
        AnimationLib = 'anim@cellphone@in_car@ds'
    end

    if extraDict then
        if override then
            AnimationLib = extraDict
        else
            AnimationLib = AnimationLib .. extraDict
        end
    end

    lib.playAnim(ped, AnimationLib, AnimationStatus, 3.0, 3.0, -1, 50, 0, false, false, false)

    PhoneData.AnimationData.lib = AnimationLib
    PhoneData.AnimationData.anim = AnimationStatus

    checkAnimationLoop()
end

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToAnyPed(v) then
                local phoneModel = GetEntityModel(v)
                if isEntityAPhone(phoneModel) then
                    SetEntityAsMissionEntity(v, false, false)
                    DeleteObject(v)
                    DeleteEntity(v)
                end
            end
        end
    end
end)
