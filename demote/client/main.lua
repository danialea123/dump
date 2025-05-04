CreateThread(function()
    IsInAnimation = false
    local loaded = false

    CreateThread(function()
        while not loaded do 
            Wait(5000)
        end
        while not NetworkIsSessionStarted() do 
            Wait(1000)
        end
        while not IsNUIReady do
            Citizen.Wait(5000)
        end
        Citizen.Wait(45000)
        SendNUIMessage({
            action = "setData",
            animations = Config.animations
        })
    end)

    RegisterNUICallback("callAnim", function(data, cb)
        local anim = data.anim
        local ped = PlayerPedId()
        if not anim then return end
        if not anim.animName then return end
        if DP.Shared[anim.animName] then
            ExecuteCommand("nearby "..anim.animName)
        elseif DP.Walks[anim.animName] then
            ExecuteCommand("walk "..anim.animName)
        else
            ExecuteCommand("e "..anim.animName)
        end
    end)

    RegisterNUICallback("callShared", function(data, cb)
        local anim = data.anim
        if not anim then return end
        if not anim.animName then return end
        ExecuteCommand("nearby "..anim.animName)
    end)

    RegisterNUICallback("close", function(data, cb)
        OpenEmoteMenu(false)
    end)

    RegisterNUICallback("stopAnim", function(data, cb)
        exports.dpemotes:cancelEmote()
    end)

    CreateThread(function()
        if not Config.SharedEmotes then
            DP['Shared'] = nil
        end
        if not Config.WalkingStyles then 
            DP['Walks'] = nil
        else
            for k, v in pairs(DP['Walks']) do 
                v[2] = k:lower()
            end
        end
        for categ, va in pairs(DP) do 
            if not Config.animations[categ] then 
                Config.animations[categ] = {}
            end
            for animTag, v in pairs(va) do 
                -- print(json.encode(v))
                local animDict = v[1]
                local animName = v[2] or animTag
                local label = v[3] or animTag
                local options = v.AnimationOptions
    
                -- Config.animations[categ][animTag] = {
                --     dict = animDict,
                --     name = animName,
                --     label = label,
                --     AnimationOptions = options
                -- }
             

                local id = #Config.animations[categ]+1
                Config.animations[categ][id] = {
                    dict = animDict,
                    name = animName,
                    label = label,
                    AnimationOptions = options,
    

                    sharedAnim = v[4],
                    id = id,
                    categ = categ,
                    animName = animTag,
                }
            end
        end

        for categ, va in pairs(Config.animations) do 
            for animTag, v in pairs(va) do 
                if DoesAnimDictExist(v.dict) then
                    if not v.id then
                        v.id = animTag
                    end
                    if not v.animName then
                        v.animName = animTag
                    end
                    if not v.categ then
                        v.categ = categ
                    end
                else
                    if categ ~= "Walks" and not v.dict:match("Scenario") and categ ~= "Expressions" then
                        print(v.dict, DoesAnimDictExist(v.dict))
                        v = nil
                    end
                end
            end
        end
        loaded = true
    end)
end)

local state = false

function OpenEmoteMenu(bool)
    state = bool or (not state)
    SetNuiFocus(state, state)
    -- SetNuiFocusKeepInput(state)
    SetNuiFocusKeepInput(true)
    SendNUIMessage({
        action = "open",
        bool = state
    })
    if state then
        Pedare()
    end
end

function Pedare()
    Citizen.CreateThread(function()
        while state do
            Citizen.Wait(5)
            DisableControlAction(0, 37, true)
            DisableControlAction(1, 37, true)
            DisableControlAction(2, 37, true)
            SetPedCanSwitchWeapon(PlayerPedId(), false)
            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
        end
        EnableControlAction(0, 37, true)
        EnableControlAction(1, 37, true)
        EnableControlAction(2, 37, true)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 106, true)
        SetPedCanSwitchWeapon(PlayerPedId(), true)
        --EnableAllControlActions(0)
    end)
end

exports("OpenEmoteMenu", OpenEmoteMenu)

RegisterNUICallback('NUIReady', function(data, cb)
	IsNUIReady = true
end)

Citizen.CreateThread(function()
    StartAudioScene('DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE')
end)