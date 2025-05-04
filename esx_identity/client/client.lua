---@diagnostic disable: undefined-field, missing-parameter, undefined-global, lowercase-global, param-type-mismatch
ESX = nil

CreateThread(function()
	while ESX == nil do 
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

local loadingScreenFinished = false
local ready = false
local guiEnabled = false
local timecycleModifier = "hud_def_blur"
local RefCode = ''
local Datas = nil
local RefActive = false
local UsedSteamRefCode = nil
local ClaimData = nil
local MyInvite = 0
local Camera = 0
local playerCoordsCam = nil

function generateRandomString(length)
    local p = promise.new()
    ESX.TriggerServerCallback('esx_identity:getreward', function(data)
        if data and data.MyRefCode then
            p:resolve(data.MyRefCode)
        end
    end)
    return Citizen.Await(p)
end

RegisterNUICallback('hideFrame', function(_, cb)
    SendNUIMessage({ action = "hide_reward" })
    SetNuiFocus(false, false)
    cb({})
end)

function StartFade()
    DoScreenFadeOut(500)
end

function EndFade()
    DoScreenFadeIn(500)
end

RegisterCommand("reward", function()
    local InviteNumbers = {}
    ESX.TriggerServerCallback('esx_identity:getreward', function(data)
        local NewTable = {}
        for k, v in pairs(Config.Rewards) do
            table.insert(NewTable, v)
        end
        table.sort(NewTable, function(a, b)
            return a.Inveites < b.Inveites
        end)
        for i = 1, #NewTable, 1 do
            table.insert(InviteNumbers,
                {
                    id = NewTable[i].id,
                    Inveites = NewTable[i].Inveites,
                    Type = NewTable[i].Type,
                    Name = NewTable[i].Name,
                    Count = NewTable[i].Count,
                    Image = NewTable[i].Image,
                    title = NewTable[i].Title
                })
        end

        local rewards = {}
        for i = 1, #InviteNumbers, 1 do
            table.insert(rewards, {
                code = data.MyRefCode,
                id = InviteNumbers[i].id,
                inviteCount = data.MyInvites .. "/" .. InviteNumbers[i].Inveites,
                rewardReady = data.MyInvites >= InviteNumbers[i].Inveites,
                rewardImage = InviteNumbers[i].Image,
                title = InviteNumbers[i].title
            })
        end
        if data.MyInvites ~= nil then
            SendNUIMessage({
                action = "show_reward",
                data = rewards
            })
            ClaimData = InviteNumbers
            MyInvite = data.MyInvites
            SetNuiFocus(true, true)
        end
    end)
end)

RegisterNUICallback('claim', function(data, cb)
    for k, v in pairs(ClaimData) do
        if v.id == data.id then
            local NewData = {
                id = v.id,
                Inveites = v.Inveites,
                Type = v.Type,
                Name = v.Name,
                Count = v.Count,
                Image = v.Image,

            }
            if MyInvite >= NewData.Inveites then
                ESX.TriggerServerCallback('esx_identity:getreward', function(data)
                    local Allowed = isAllowedToClaim(NewData.id, data.collected)
                    if Allowed then
                        Notif('You already claimed this reward', 4000)
                    else
                        SendNUIMessage({ action = "hide_reward" })
                        SetNuiFocus(false, false)
                        TriggerServerEvent('SendData:ClaimReward', NewData.id)
                    end
                end)
            else
                Notif('Invite Haye Shoma Kafi Nist', 4000)
            end
        end
    end
end)

function isAllowedToClaim(data, table)
    local allowed = false
    for i, id in ipairs(table) do
        if data == id then
            allowed = true
        end
    end
    return allowed
end

RegisterNetEvent('esx_identity:notif', function(text, time)
    SendNUIMessage({
        action = "show_notif",
        data = {
            text = text,
            time = time
        }
    })
end)

function Notif(text, time)
    SendNUIMessage({
        action = "show_notif",
        data = {
            text = text,
            time = time
        }
    })
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    LoadedESX = true
end)

RegisterNuiCallback("ready", function(data, cb)
    while not LoadedESX do
        Citizen.Wait(1000)
    end
    ready = true
    RefCode = generateRandomString(8)
    SendNuiMessage(json.encode(
        {
            action = "setConfig",
            Config =
            {
                theme = Config.themes[Config.UI.theme],
                socials = Config.UI.socials,
                locale = Config.UILocale,
                badNames = Config.BadNames,
                userRefCode = RefCode,
                MinNameLength = Config.MinNameLength,
                MaxNameLength = Config.MaxNameLength,
                minBrithDay = Config.LowestYear,
                maxBrithDay = Config.HighestYear,
                MinHeight = Config.MinHeight,
                MaxHeight = Config.MaxHeight
            }
        }
    ))
    cb({})
end)

RegisterNuiCallback("checkref", function(data, cb)
    local data = data
    ESX.TriggerServerCallback("esx_identity:CheckRefCode", function(success, hex)
        if success then
            Wait(1000)
            cb({ status = true })
            RefActive = true
            UsedSteamRefCode = hex
            UsedCodeRef = data.ref
        else
            cb({ status = false })
            RefActive = false
        end
    end, data.ref)

end)

function setGuiState(state)
    SetNuiFocus(state, state)
    guiEnabled = state

    if state then
        SetTimecycleModifier(timecycleModifier)
        SendNUIMessage({ action = "show_register" })
    else
        ClearTimecycleModifier()
        SendNUIMessage({ action = "hide_register" })
    end
end

RegisterNetEvent('esx_identity:showRegisterIdentity', function()
    TriggerEvent('esx_skin:resetFirstSpawn')
    while not (ready) do
        Wait(100)
    end
    setGuiState(true)
end)

RegisterNUICallback('register', function(data, cb)
    if not guiEnabled then
        return
    end
    setGuiState(false)
    ESX.TriggerServerCallback('esx_identity:registerIdentity', function(callback)
        if not callback then
            return
        end
        Notif(TranslateCap('thank_you_for_registering'), 4000)
        local playerNames = firstToUpper(data.firstname) ..'_'.. firstToUpper(data.lastname)
        TriggerServerEvent('db:updateUser', { playerName = playerNames })
        TriggerServerEvent('es:newName', playerNames)
        TriggerEvent("loading:nameRegistered")
        GetNaked()
        TriggerServerEvent("esx_skin:WaitingForCreation")
        Citizen.Wait(2000)
        TriggerEvent("esx_skin:openSaveableMenu", function(done)
            TriggerEvent("loading:setupEveything")
        end)
    end, data, RefCode, RefActive, UsedSteamRefCode, UsedCodeRef)
    cb({})
end)

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
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
            helmet_1  = -1,
            hair_1    = 0,
            chain_1   = 0,
            watches_1 = -1,
            bracelets_1 = -1,
            decals_1   = 0,
            bags_1     = 0,
            makeup_1   = 0,
            makeup_2   = 0,
            makeup_3   = 0,
            makeup_4   = 0,
            blush_1   = 0,
            blush_2   = 0,
            blush_3   = 0,
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
            helmet_1  = -1,
            hair_1    = 0,
            chain_1   = 0,
            watches_1 = -1,
            bracelets_1 = -1,
            decals_1   = 0,
            bags_1     = 0,
            makeup_1   = 0,
            makeup_2   = 0,
            makeup_3   = 0,
            makeup_4   = 0,
            blush_1   = 0,
            blush_2   = 0,
            blush_3   = 0,
        })
    end
end