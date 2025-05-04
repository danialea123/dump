---@diagnostic disable: undefined-field
local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

---@diagnostic disable: undefined-global
RegisterNetEvent('yseries:client:toggle-phone', function(state)
    -- debugPrint('RegisterNetEvent: yseries:client:toggle-phone', state)
    -- * A callback function that you can use as you want when the phone focus is toggled.
end)

RegisterNetEvent('yseries:use-phone-with-item', function(usedPhoneItem)
    local _phoneModel = MapItemToPhoneModel(usedPhoneItem)

    UsePhoneItem(_phoneModel)
end)

--- Uses the phone item if it exists and initializes the phone device if it doesn't exist.
--- If the phone device is already initialized, it loads the phone data and toggles the phone open/closed.
function UsePhoneItem(_phoneModel)
    if CameraActive or PhoneDisabled or IsDead or (PhoneOpen and not SoftOpen) then return end

    if Config.Item.Require then
        if HasPhoneItem and not HasPhoneItem() then
            return
        end
    end

    local phoneImei = CurrentPhoneImei or
        lib.callback.await('yseries:server:get-primary-phone', false, PlayerData.identifier)
    if not phoneImei and not Config.Item.UniquePhones then
        SetupPhoneDevice(_phoneModel)
    elseif phoneImei then
        if not DataLoaded then
            LoadPhoneData(phoneImei)

            while not DataLoaded do
                Wait(100)
            end
        end

        HasPrimaryPhone = true

        ToggleOpen(true)
    elseif Config.Item.UniquePhones then
        Notify({
            title = "Phone",
            description =
            'Upon the first use of the phone, it must assign the metadata to the item to be initialized. Please USE the phone item from your inventory to proceed with the setup.',
            type = 'warning',
            duration = 5000
        })
    end
end

-- Just a small cooldown to prevent spamming the phone action.
local PhoneCooldown = false
local PhoneCooldownTime = 2000 -- number in ms. 1000ms = 1 second

RegisterKeyMapping('iphone', "chejooboodam", 'keyboard', "F1")
RegisterCommand('iphone', function()
    if PhoneCooldown then
        Notify({
            title = "Phone",
            description = "Open Phone action is on cooldown, please wait.",
            type = 'info',
            duration = 1500
        })
        return
    end

    if PhoneOpen and not SoftOpen and not IsAccountLive() then
        ToggleOpen(false)
        -- Set the cooldown when the phone is closed
        PhoneCooldown = true
        SetTimeout(PhoneCooldownTime, function()
            PhoneCooldown = false
        end)
    else
        ESX.TriggerServerCallback('esx:doesHavePhone', function(has)
            if has then
                UsePhoneItem()
            end
        end)
    end
end, false)

RegisterNetEvent('yseries:client:setup-complete', function(phoneImei)
    -- * A callback function that you can use as you want when the phone is setup.
    debugPrint('Callback after setup complete: client/misc.lua ', phoneImei)

    if Config.UpdateUserPhoneNumber and (Config.Framework == 'qb' or Config.Framework == 'esx' or Config.Framework == 'qbox') then
        local phoneNumber = lib.callback.await('yseries:server:get-phone-number-by-imei', false, phoneImei)

        TriggerServerEvent('yseries:server:update-users-phone-number', phoneNumber)
    end
end)

RegisterNetEvent('yseries:client:cell-broadcast', function(title, content, iconUrl)
    if not HasPrimaryPhone or not Device.isSetup or PhoneDisabled or IsDead then return end

    local data = {
        title = title,
        content = content,
        iconUrl = iconUrl
    }

    SendUIAction('cell-broadcast:send', data)
end)

RegisterNetEvent("qb-phone:client:CustomNotification", function(title, text, _, _, timeout)
    TriggerServerEvent('yseries:server:qb-phone-bridge:send-notification', title, text, timeout, GetPlayerServerId(PlayerId()))
end)

-- Function to handle when the phone is dropped.
function PhoneDropped()
    if OnRadio then
        LeaveRadioChannel()
    end
end

-- Used to capture the player's voice while recording a video fro example.
function IsPlayerTalking()
    return NetworkIsPlayerTalking(PlayerId()) -- If you are using an external VoIP you will need to update the function here to one that returns when the player is talking.
end

-- Calculates the current time and returns an object containing the hour and minute in a formatted string.
-- @return {table} obj - An object containing the formatted hour and minute.
local function CalculateTimeToDisplay()
    local hour = GetClockHours()
    local minute = GetClockMinutes()

    local obj = {}

    if minute <= 9 then
        minute = "0" .. minute
    end

    if hour <= 9 then
        hour = "0" .. hour
    end

    obj.hour = hour
    obj.minute = minute

    return obj
end

RegisterNUICallback('misc:get-game-time', function(_, cb)
    cb(CalculateTimeToDisplay())
end)

if not Config.RealTime then
    CreateThread(function()
        while true do
            if PhoneOpen then
                local gameTime = CalculateTimeToDisplay()

                SendUIAction('clock:update-time', gameTime)
            end
            Wait(2000)
        end
    end)
end
