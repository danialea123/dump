--[[Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('playernames')))
end)]]
ESX = nil
local Jobs = {
    ["police"] = true,
    ["sheriff"] = true,
    ['forces'] = true,
    ["fbi"] = true,
    ["ambulance"] = true,
    ["mechanic"] = true,
    ["justice"] = true,
    ["benny"] = true,
    ["taxi"] = true,
    ["weazel"] = true,
}

local Masks = {
    [2] = true,
    [6] = true,
    [8] = true, 
    [9] = true, 
    [10] = true, 
    [11] = true, 
    [12] = true, 
    [13] = true, 
    [14] = true, 
    [15] = true, 
    [16] = true, 
    [17] = true, 
    [18] = true, 
    [19] = true, 
    [20] = true, 
    [21] = true, 
    [22] = true, 
    [23] = true, 
    [24] = true, 
    [25] = true, 
    [26] = true, 
    [28] = true,
    [29] = true, 
    [31] = true, 
    [32] = true, 
    [33] = true, 
    [34] = true, 
    [35] = true, 
    [36] = true, 
    [37] = true, 
    [38] = true, 
    [39] = true, 
    [40] = true, 
    [43] = true, 
    [44] = true, 
    [45] = true, 
    [48] = true, 
    [49] = true, 
    [51] = true, 
    [52] = true, 
    [54] = true, 
    [55] = true, 
    [56] = true, 
    [57] = true, 
    [58] = true, 
    [59] = true, 
    [60] = true, 
    [61] = true, 
    [62] = true, 
    [63] = true, 
    [68] = true, 
    [69] = true, 
    [71] = true, 
    [84] = true, 
    [85] = true, 
    [93] = true, 
    [108] = true, 
    [130] = true, 
    [147] = true, 
    [158] = true, 
    [164] = true, 
    [166] = true, 
    [168] = true, 
    [171] = true,
    [173] = true,
    [177] = true, 
    [178] = true, 
    [179] = true, 
    [185] = true, 
    [197] = true, 
    [202] = true, 
    [205] = true, 
    [223] = true, 
    [226] = true, 
    [232] = true, 
    [243] = true, 
    [244] = true, 
    [257] = true, 
    [273] = true, 
}
Masks[-1] = true
Masks[0] = true

Citizen.CreateThread(function()
    while ESX == nil do 
        TriggerEvent("esx:getSharedObject", function(HR) ESX = HR end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(5000)
    end

    PlayerData = ESX.GetPlayerData()
    
    --[[Player(GetPlayerServerId(PlayerId())).state:set("identifier", PlayerData.identifier, true)
    Player(GetPlayerServerId(PlayerId())).state:set("job", PlayerData.job.name, true)
    Player(GetPlayerServerId(PlayerId())).state:set("gang", PlayerData.gang.name, true)
    Player(GetPlayerServerId(PlayerId())).state:set("name", MinimizeName(PlayerData.name:match("([^/]+)_")), true)]]

    Jobe = PlayerData.job.name
    Gange = PlayerData.gang.name

    DecorRegister('level', 3)
    DecorSetInt(PlayerPedId(), 'level', 0)
    DecorRegister('typing', 2)
    DecorSetInt(PlayerPedId(), 'typing', 0)
    DecorRegister('speaker', 3)
    DecorSetInt(PlayerPedId(), 'speaker', 0)
    --DeleteResourceKvp("playernames")
    Known = GetResourceKvpString("playernames")
	if Known == nil or Known == "" then
		local Identifier = {}
		local jsone = json.encode(Identifier)
		SetResourceKvp("playernames", jsone)
    else
        local Identifier = json.decode(Known)
        for k, v in pairs(Identifier) do
            if exports.sr_main:GetTimeStampp() > v then
                Identifier[k] = nil
            end
        end
        local jsone = json.encode(Identifier)
		SetResourceKvp("playernames", jsone)
    end
    Known = GetResourceKvpString("playernames")
    Global = json.decode(Known)
end)

AddEventHandler("playernames:AddUser", function(Hex)
    Known = GetResourceKvpString("playernames")
    local Identifier = json.decode(Known)
    Identifier[Hex] = exports.sr_main:GetTimeStampp()+172800
    local jsone = json.encode(Identifier)
    SetResourceKvp("playernames", jsone)
    Known = GetResourceKvpString("playernames")
    Global = json.decode(Known)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    Jobe = job.name
    --Player(GetPlayerServerId(PlayerId())).state:set("job", job.name, true)
end)

RegisterNetEvent("nameUpdate")
AddEventHandler("nameUpdate", function(name)
    ESX.SetPlayerData("name", name)
    PlayerData.name = name
    --Player(GetPlayerServerId(PlayerId())).state:set("name", MinimizeName(PlayerData.name:match("([^/]+)_")), true)
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
    Gange = gang.name
    --Player(GetPlayerServerId(PlayerId())).state:set("gang", gang.name, true)
end)

local mpGamerTags = {}
local mpGamerTagSettings = {}
local ShowPlayersId = false
local Admins = {}
local AdminTags = {}

local gtComponent = {
    GAMER_NAME = 0,
    CREW_TAG = 1,
    healthArmour = 2,
    BIG_TEXT = 3,
    AUDIO_ICON = 4,
    MP_USING_MENU = 5,
    MP_PASSIVE_MODE = 6,
    WANTED_STARS = 7,
    MP_DRIVER = 8,
    MP_CO_DRIVER = 9,
    MP_TAGGED = 10,
    GAMER_NAME_NEARBY = 11,
    ARROW = 12,
    MP_PACKAGES = 13,
    INV_IF_PED_FOLLOWING = 14,
    RANK_TEXT = 15,
    MP_TYPING = 16
}

local function makeSettings()
    return {
        nameTag = nil,
        colors = {},
        toggle = false,
    }
end

function updatePlayerNames()
    -- re-run this function the next frame
    SetTimeout(250, updatePlayerNames)

    -- get local coordinates to compare to
    local localCoords = GetEntityCoords(PlayerPedId())

    -- for each valid player index
    for _, i in ipairs(GetActivePlayers()) do
        -- if the player exists
        --if i ~= PlayerId() then
            -- get their ped
            local ped = GetPlayerPed(i)
            local serverId = GetPlayerServerId(i)
            local pedCoords = GetEntityCoords(ped)
            local myCoord = GetEntityCoords(PlayerPedId())
            local dis = #(myCoord - pedCoords)
            -- make a new settings list if needed
            if not mpGamerTagSettings[serverId] then
                mpGamerTagSettings[serverId] = makeSettings()
            end

            local job = GetData(serverId, "job")
            local gang = GetData(serverId, "gang")
            local name = GetData(serverId, "name")
            local identifier = GetData(serverId, "identifier")
            local mask = GetData(serverId, "mask")
            SetMpGamerTagsUseVehicleBehavior(false)
            -- check the ped, because changing player models may recreate the ped
            -- also check gamer tag activity in case the game deleted the gamer tag
            if not mpGamerTags[serverId] or mpGamerTags[serverId].ped ~= ped or not IsMpGamerTagActive(mpGamerTags[serverId].tag) then
                local nameTag = ('[%s]'):format(serverId)

                -- remove any existing tag
                if mpGamerTags[serverId] then
                    RemoveMpGamerTag(mpGamerTags[serverId].tag)
                end
                
                -- store the new tag
                mpGamerTags[serverId] = {
                    tag = CreateMpGamerTag(GetPlayerPed(i), nameTag, false, false, '', 0),
                    ped = ped
                }
            end
            -- store the tag in a local
            local tag = mpGamerTags[serverId].tag

            -- check distance
            local distance = #(pedCoords - localCoords)
            local speaker = DecorGetInt(ped, 'speaker')

            local isJob= Jobs[job]
            local isGang= gang ~= "nogang"
            -- show/hide based on nearbyness/line-of-sight
            -- nearby checks are primarily to prevent a lot of LOS checks
            if distance < 15 and HasEntityClearLosToEntity(PlayerPedId(), ped, 17) and not mpGamerTagSettings[serverId].toggle and speaker == 0 and i ~= PlayerId() then
                SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, DecorGetInt(ped,'typing'))
                if ShowPlayersId or NetworkIsPlayerTalking(i) then
                    local level = DecorGetInt(ped, 'level') or 0
                    SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, NetworkIsPlayerTalking(i))
                    SetMpGamerTagAlpha(tag, gtComponent.AUDIO_ICON, 255)
                    SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, true)
                    if mpGamerTagSettings[serverId] and mpGamerTagSettings[serverId].nameTag then
                        if mpGamerTagSettings[serverId].nameTag == "[Newbie]" then
                            SetMpGamerTagVisibility(tag, gtComponent.INV_IF_PED_FOLLOWING, NetworkIsPlayerTalking(i))
                            SetMpGamerTagAlpha(tag, gtComponent.INV_IF_PED_FOLLOWING, 255)
                            SetMpGamerTagColour(tag, gtComponent.INV_IF_PED_FOLLOWING, 147)
                        end
                        if mpGamerTagSettings[serverId].nameTag:find(" | lvl :") then
                            SetMpGamerTagVisibility(tag, gtComponent.WANTED_STARS, NetworkIsPlayerTalking(i))
                            SetMpGamerTagAlpha(tag, gtComponent.WANTED_STARS, 255)
                            SetMpGamerTagColour(tag, gtComponent.WANTED_STARS, 208)
                        end
                        if ((Global and Global[identifier]) or (isJob and job == Jobe) or (isGang and gang == Gange)) and (not IsPedInAnyVehicle(ped) or dis <= 2) then
                            if mask and Masks[mask] then
                                SetMpGamerTagName(tag, "["..serverId.."] ["..name.."] ".. mpGamerTagSettings[serverId].nameTag)
                            else
                                SetMpGamerTagName(tag, "["..serverId.."] " .. mpGamerTagSettings[serverId].nameTag)
                            end
                        else
                            SetMpGamerTagName(tag, "["..serverId.."] " .. mpGamerTagSettings[serverId].nameTag)
                        end
                    else
                        SetMpGamerTagName(tag, "["..serverId.."] ".. "| lvl : ".. level)
                    end
                    for k,v in pairs(mpGamerTagSettings[serverId].colors) do
                        if k ~= "INV_IF_PED_FOLLOWING" and k ~= "WANTED_STARS" then
                            SetMpGamerTagColour(tag, gtComponent[k], v)
                        end
                    end
                    if mpGamerTagSettings[serverId].color then
                        SetMpGamerTagColour(tag, gtComponent.GAMER_NAME, mpGamerTagSettings[serverId].color)
                    elseif mpGamerTagSettings[serverId].nameTag then
                        SetMpGamerTagColour(tag, gtComponent.GAMER_NAME, 0)
                    end
                else
                    SetMpGamerTagVisibility(tag, gtComponent.WANTED_STARS, false)
                    SetMpGamerTagVisibility(tag, gtComponent.INV_IF_PED_FOLLOWING, false)
                    SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
                    SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, false)
                end
            elseif speaker == 1 and distance < 30 then
                SetMpGamerTagName(tag, "["..serverId.."] Speaker ")
                SetMpGamerTagColour(tag, 0, 6)
                SetMpGamerTagColour(tag, 4, 0)
                SetMpGamerTagAlpha(tag, gtComponent.AUDIO_ICON, 255)
                SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, true)
                SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, true)
            else
                SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, false)
                SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
                SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, false)
            end
        --end
    end
end

SetTimeout(250, updatePlayerNames)

AddEventHandler('onKeyUP',function(key)
	if key == "numpad7" then
        if not ShowPlayersId then
            ShowPlayersId = true
            ExecuteCommand("me Be ID Ha Negah Kard")
            SetTimeout(5000, function()
                ShowPlayersId = false
            end)
        end
	end
end)

RegisterNetEvent("UpdateAdminTags")
AddEventHandler("UpdateAdminTags", function(Tags)
    Admins = {}
    Admins = Tags
end)

RegisterNetEvent('playernames:setData')
AddEventHandler('playernames:setData', function(names, colors)
    for k, v in pairs(names) do
        TriggerEvent("pname:changePlayerSetting", k, "nameTag", v)
    end
    for k, v in pairs(colors) do
        TriggerEvent("pname:changePlayerSetting", k, "color", v)
    end
end)

RegisterNetEvent('pname:changePlayerSetting')
AddEventHandler('pname:changePlayerSetting', function(id, key, value)
    if not mpGamerTagSettings[id] then
        mpGamerTagSettings[id] = makeSettings()
    end

    if mpGamerTags[id] then
        RemoveMpGamerTag(mpGamerTags[id].tag)
    end

    mpGamerTagSettings[id][key] = value
end)

function UpdateAdminTags()
    SetTimeout(250, UpdateAdminTags)
    for k, v in pairs(GetActivePlayers()) do
        for j, c in pairs(Admins) do
            if c.ID == GetPlayerServerId(v) then
                CreateMpGamerTagForNetPlayer(v, "["..c.Tag.."] "..GetPlayerName(v), false, false, '', 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(v))) < 15.0 and DoesEntityExist(GetPlayerPed(v)) and c.Toggle then
                    if DecorGetInt(GetPlayerPed(v), 'typing') == 1 or NetworkIsPlayerTalking(v) or not IsEntityVisible(GetPlayerPed(v)) or DecorGetInt(GetPlayerPed(v), 'speaker') == 1 then
                        SetMpGamerTagVisibility(v, 0, false)
                    else
                        SetMpGamerTagVisibility(v, 0, true)
                    end
                    SetMpGamerTagColour(v, 0, 10)
                    SetMpGamerTagAlpha(v, 0, 255)
                else
                    SetMpGamerTagVisibility(v, 0, false)
                end
            end
        end
    end
end

SetTimeout(250, UpdateAdminTags)

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        for _, v in pairs(mpGamerTags) do
            RemoveMpGamerTag(v.tag)
        end
        for _, v in pairs(GetActivePlayers()) do
            RemoveMpGamerTag(v)
        end
    end
end)

function GetData(id, key)
    --return Player(id).state[key]
    return 'Unk'
end

--[[local currentMask = 99999

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        if currentMask ~= GetPedDrawableVariation(PlayerPedId(), 1) then
            currentMask = GetPedDrawableVariation(PlayerPedId(), 1)
            Player(GetPlayerServerId(PlayerId())).state:set("mask", currentMask, true)
        else
            Citizen.Wait(150)
        end
    end
end)]]

function MinimizeName(str)
    local str = str
    local count = 0
    local ptr = ""
    if string.len(str) > 10 then
        for c in str:gmatch"." do
            if count <= 10 then
                count = count + 1
                ptr = ptr..c
            end
        end
        ptr = ptr.."..."
    else
        ptr = str
    end
    return ptr
end