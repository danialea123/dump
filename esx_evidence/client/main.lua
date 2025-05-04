---@diagnostic disable: lowercase-global, missing-parameter
ESX = nil
local PlayerData = {}
local BloodTimeOut = false
local ShotTimeOut = false
local evidence = {}
local shots = {}
local blood = {}
local time = {}
local Organs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["justice"] = true,
    ["forces"] = true,
    ["fbi"] = true,
}
local Capture = false

RegisterNetEvent('capture:CaptureStarted')
AddEventHandler('capture:CaptureStarted', function()
    Capture = true
end)

RegisterNetEvent('capture:CaptureEnded')
AddEventHandler('capture:CaptureEnded', function(k, v)
    Capture = false
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while not ESX.GetPlayerData().gang do
        Citizen.Wait(1000)
    end

    PlayerData = ESX.GetPlayerData()
    OrganThread()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(job)
    PlayerData.job = job
    Citizen.Wait(2000)
    OrganThread()
end)

function OrganThread()
    Citizen.CreateThread(function()
        while PlayerData.job.name == "police" and PlayerData.job.ext == "detective" do
            Citizen.Wait(1)
            local playerid = PlayerId()
            if not IsPlayerFreeAiming(playerid) then
                update = true
                Citizen.Wait(500)
            else
                local playerPed = GetPlayerPed(-1)
                if IsPlayerFreeAiming(playerid) and GetSelectedPedWeapon(playerPed) == GetHashKey("WEAPON_FLASHLIGHT") then
                    if update then
                        ESX.TriggerServerCallback("esx_evidence:getData",function(ans)
                            shots = ans.shots
                            blood = ans.blood
                            time = ans.time
                        end)
                        update = false
                    end

                    for t, s in pairs(blood) do
                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 30 then
                            DrawMarker(
                                1,
                                s.coords[1],
                                s.coords[2],
                                s.coords[3] - 0.9,
                                0.0,
                                0.0,
                                0.0,
                                0,
                                0.0,
                                0.0,
                                0.2,
                                0.2,
                                0.2,
                                255,
                                41,
                                41,
                                100,
                                false,
                                true,
                                2,
                                false,
                                false,
                                false,
                                false
                            )
                        end

                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 5 then
                            DrawText3D(s.coords[1], s.coords[2], s.coords[3] - 0.5, Config.Text["blood_hologram"])

                            local passed = time - t

                            if passed > 300 and passed < 600 then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["blood_after_5_minutes"]
                                )
                            elseif passed > 600 then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["blood_after_10_minutes"]
                                )
                            else
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["blood_after_0_minutes"]
                                )
                            end
                        end

                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 1 then
                            if Organs[PlayerData.job.name] then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.65,
                                    Config.Text["pick_up_evidence_text"]
                                )
                                if IsControlJustReleased(0, 38) then
                                    if #evidence < 3 then
                                        local dict, anim =
                                            "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@",
                                            "plant_floor"
                                        ESX.Streaming.RequestAnimDict(dict)
                                        TaskPlayAnim(
                                            playerPed,
                                            dict,
                                            anim,
                                            8.0,
                                            1.0,
                                            1000,
                                            16,
                                            0.0,
                                            false,
                                            false,
                                            false
                                        )
                                        Citizen.Wait(1000)
                                        blood[t] = nil
                                        evidence[#evidence + 1] = {type = "blood", evidence = s.reportInfo}
                                        TriggerServerEvent("esx_evidence:removeBlood", t)
                                        SendTextMessage(
                                            string.gsub(Config.Text["evidence_colleted"], "{number}", #evidence)
                                        )
                                        PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                    else
                                        SendTextMessage(Config.Text["no_more_space"])
                                    end
                                end
                            end
                        end
                    end

                    for t, s in pairs(shots) do
                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 30 then
                            DrawMarker(
                                3,
                                s.coords[1],
                                s.coords[2],
                                s.coords[3] - 0.9,
                                0.0,
                                0.0,
                                0.0,
                                0,
                                0.0,
                                0.0,
                                0.15,
                                0.15,
                                0.2,
                                66,
                                135,
                                245,
                                100,
                                false,
                                true,
                                2,
                                false,
                                false,
                                false,
                                false
                            )
                        end

                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 5 then
                            DrawText3D(
                                s.coords[1],
                                s.coords[2],
                                s.coords[3] - 0.5,
                                string.gsub(Config.Text["shell_hologram"], "{guncategory}", s.bullet)
                            )

                            local passed = time - t

                            if passed > 300 and passed < 600 then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["shell_after_5_minutes"]
                                )
                            elseif passed > 600 then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["shell_after_10_minutes"]
                                )
                            else
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["shell_after_0_minutes"]
                                )
                            end
                        end

                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 1 then
                            if Organs[PlayerData.job.name] then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.65,
                                    Config.Text["pick_up_evidence_text"]
                                )
                                if IsControlJustReleased(0, 38) then
                                    if #evidence < 3 then
                                        local dict, anim =
                                            "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@",
                                            "plant_floor"
                                        ESX.Streaming.RequestAnimDict(dict)
                                        TaskPlayAnim(
                                            playerPed,
                                            dict,
                                            anim,
                                            8.0,
                                            1.0,
                                            1000,
                                            16,
                                            0.0,
                                            false,
                                            false,
                                            false
                                        )
                                        Citizen.Wait(1000)
                                        shots[t] = nil
                                        evidence[#evidence + 1] = {type = "bullet", evidence = s.reportInfo}
                                        TriggerServerEvent("esx_evidence:removeShot", t)
                                        SendTextMessage(
                                            string.gsub(Config.Text["evidence_colleted"], "{number}", #evidence)
                                        )
                                        PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                    else
                                        SendTextMessage(Config.Text["no_more_space"])
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local Coord = vector3(448.58,-974.99,25.47)

AddEventHandler("esx_evidence:openRecordMenu", function()
    if #evidence == 0 then return ESX.Alert("Hich Evidenci Nadarid", "info") end
    ESX.UI.Menu.CloseAll()
    local elem = {
        {label = "Show All Evidences", value = "show"},
        {label = "Delete Evidence", value = "delete"}
    }
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
		title    = 'Evidence Menu',
		align    = 'top-left',
		elements = elem,
	}, function(data, menu)
        local data = data.current.value
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        ExecuteCommand("e tablet2")
        if data == "show" then
            SendNUIMessage(
                {
                    type = "showReport",
                    evidence = json.encode(evidence)
                }
            )
            menu.close()
        else
            local elea = {}
            for k, v in pairs(evidence) do
                table.insert(elea, {label = " Delete Evidence: "..k, value = k})
            end
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_sactions', {
                title    = 'Evidence Menu',
                align    = 'top-left',
                elements = elea,
            }, function(data2, menu2)
                local data2 = data2.current.value
                evidence[data2] = nil
                local temp = {}
                for k, v in pairs(evidence) do
                    table.insert(temp, v)
                end
                evidence = ESX.CopyTable(temp)
                ESX.Alert("Evidence Paak Shod", "check")
                TriggerEvent("esx_evidence:openRecordMenu")
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end)

AddEventHandler("onKeyUP", function(key)
    if key == "back" then
        SendNUIMessage(
            {
                type = "close"
            }
        )
    end
end)

--[[Citizen.CreateThread(function()
    while true do
            Citizen.Wait(1)

            if job == Config.JobRequired and grade >= Config.JobGradeRequired then
                local ped = GetPlayerPed(-1)
                local veh = GetVehiclePedIsTryingToEnter(ped)
                local seat = GetSeatPedIsTryingToEnter(ped)
                local coords = GetEntityCoords(ped)

                if GetDistanceBetweenCoords(coords, Config.EvidenceStorageLocation) < 1.5 then
                    DrawText3D(
                        Config.EvidenceStorageLocation[1],
                        Config.EvidenceStorageLocation[2],
                        Config.EvidenceStorageLocation[3],
                        Config.Text["open_evidence_archive"]
                    )

                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback(
                            "esx_evidence:getStorageData",
                            function(data)
                                ESX.UI.Menu.CloseAll()

                                local elements = {}

                                for _, v in ipairs(data) do
                                    table.insert(
                                        elements,
                                        {label = Config.Text["report_list"] .. v.id, value = v.data, id = v.id}
                                    )
                                end

                                ESX.UI.Menu.Open(
                                    "default",
                                    GetCurrentResourceName(),
                                    "evidence_storage",
                                    {
                                        title = Config.Text["evidence_archive"],
                                        align = "bottom-right",
                                        elements = elements
                                    },
                                    function(data, menu)
                                        ESX.UI.Menu.Open(
                                            "default",
                                            GetCurrentResourceName(),
                                            "evidence_options",
                                            {
                                                title = data.current.label,
                                                align = "bottom-right",
                                                elements = {
                                                    {label = Config.Text["view"], value = "view"},
                                                    {label = Config.Text["delete"], value = "delete"}
                                                }
                                            },
                                            function(data2, menu2)
                                                if data2.current.value == "view" then
                                                    SendNUIMessage(
                                                        {
                                                            type = "showReport",
                                                            evidence = data.current.value
                                                        }
                                                    )
                                                    open = true
                                                elseif data2.current.value == "delete" then
                                                    TriggerServerEvent(
                                                        "esx_evidence:deleteEvidenceFromStorage",
                                                        data.current.id
                                                    )
                                                    SendTextMessage(Config.Text["evidence_deleted_from_archive"])
                                                end
                                                menu2.close()
                                            end,
                                            function(data2, menu2)
                                                menu2.close()
                                            end
                                        )
                                        menu.close()
                                    end,
                                    function(data, menu)
                                        menu.close()
                                    end
                                )
                            end
                        )
                    end
                elseif GetDistanceBetweenCoords(coords, Config.EvidenceAlanysisLocation) < 1.5 then
                    if not analyzing and not analyzingDone then
                        DrawText3D(
                            Config.EvidenceAlanysisLocation[1],
                            Config.EvidenceAlanysisLocation[2],
                            Config.EvidenceAlanysisLocation[3],
                            Config.Text["analyze_evidence"]
                        )
                    elseif analyzingDone then
                        DrawText3D(
                            Config.EvidenceAlanysisLocation[1],
                            Config.EvidenceAlanysisLocation[2],
                            Config.EvidenceAlanysisLocation[3],
                            Config.Text["read_evidence_report"]
                        )
                    else
                        DrawText3D(
                            Config.EvidenceAlanysisLocation[1],
                            Config.EvidenceAlanysisLocation[2],
                            Config.EvidenceAlanysisLocation[3],
                            Config.Text["evidence_being_analyzed_hologram"]
                        )
                    end
                    if IsControlJustReleased(0, 38) and not analyzing and not analyzingDone then
                        if #evidence > 0 then
                            Citizen.CreateThread(
                                function()
                                    SendTextMessage(Config.Text["evidence_being_analyzed"])

                                    analyzing = true
                                    Citizen.Wait(Config.TimeToAnalyze)

                                    analyzingDone = true
                                    analyzing = false
                                end
                            )
                        else
                            SendTextMessage(Config.Text["no_evidence_to_analyze"])
                        end
                    elseif IsControlJustReleased(0, 38) and not analyzing and analyzingDone then
                        SendNUIMessage(
                            {
                                type = "showReport",
                                evidence = json.encode(evidence)
                            }
                        )
                        TriggerServerEvent("esx_evidence:addEvidenceToStorage", json.encode(evidence))
                        if Config.PlayClipboardAnimation then
                            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
                        end
                        open = true
                        analyzingDone = false
                        evidence = {}
                    end
                end

                if IsControlJustReleased(0, Keys[Config.CloseReportKey]) and open then
                    SendNUIMessage(
                        {
                            type = "close"
                        }
                    )
                    ClearPedTasks(ped)
                    open = false
                end

                if veh ~= 0 then
                    local lastped = GetLastPedInVehicleSeat(veh, seat)
                    local gloves = GetPedDrawableVariation(PlayerPedId(), 3)

                    if gloves > 15 and gloves ~= 112 and gloves ~= 113 and gloves ~= 114 then
                        last = 0
                    else
                        last = lastped
                    end
                end
            end
        end
    end
)]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local playerid = PlayerId()
        if IsPlayerFreeAiming(playerid) then
            if IsPedShooting(ped) and not Organs[PlayerData.job.name] and not ShotTimeOut then
                TriggerServerEvent("esx_evidence:saveShot",coords, getWeaponName(GetSelectedPedWeapon(ped)), GetInteriorFromEntity(ped), ESX.GetWeaponName(GetSelectedPedWeapon(ped)))
                ShotTimeOut = true
                Citizen.SetTimeout(30000, function()
                    ShotTimeOut = false
                end)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

AddEventHandler('gameEventTriggered', function (name, data)
	if name == 'CEventNetworkEntityDamage' then
        local hash = data[7]
		local victim = data[1]
		local attacker = data[2]
        local ped = PlayerPedId()
        local coords = GetEntityCoords(PlayerPedId())
        if victim == PlayerPedId() and GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 and IsPedAPlayer(victim) and IsPedAPlayer(attacker) and not BloodTimeOut and hash ~= `WEAPON_UNARMED` then
            --ClearEntityLastDamageEntity(ped)
            if Capture then return end
            ESX.Game.SpawnObject("p_bloodsplat_s", vector3(coords[1], coords[2], coords[3] - 2.0), function(stain) 
                PlaceObjectOnGroundProperly(stain)
                local stainCoords = GetEntityCoords(stain)
                SetEntityCoords(stain, stainCoords[1], stainCoords[2], stainCoords[3] - 0.25)
                SetEntityAsMissionEntity(stain, false, true)
                SetEntityRotation(stain, -90.0, 0.0, 0.0, 2, false)
                FreezeEntityPosition(stain, true)
                TriggerServerEvent("esx_evidence:saveBlood", coords, GetInteriorFromEntity(ped), ObjToNet(stain))
            end)
            BloodTimeOut = true
            Citizen.SetTimeout(60000, function()
                BloodTimeOut = false
            end)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        if GetRainLevel() > 0.4 then
            TriggerServerEvent("esx_evidence:removeEverything")
            Citizen.Wait(180000)
        end
    end
end)

function getWeaponName(hash)
    local ped = GetPlayerPed(-1)

    if GetWeapontypeGroup(hash) == -957766203 then
        return Config.Text["submachine_category"]
    end
    if GetWeapontypeGroup(hash) == 416676503 then
        return Config.Text["pistol_category"]
    end
    if GetWeapontypeGroup(hash) == 860033945 then
        return Config.Text["shotgun_category"]
    end
    if GetWeapontypeGroup(hash) == 970310034 then
        return Config.Text["assault_category"]
    end
    if GetWeapontypeGroup(hash) == 1159398588 then
        return Config.Text["lightmachine_category"]
    end
    if GetWeapontypeGroup(hash) == -1212426201 then
        return Config.Text["sniper_category"]
    end
    if GetWeapontypeGroup(hash) == -1569042529 then
        return Config.Text["heavy_category"]
    end

    return GetWeapontypeGroup(hash)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)

        SetTextDropshadow(1, 1, 1, 1, 255)

        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55 * scale, 4)
        local width = EndTextCommandGetWidth(4)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end


