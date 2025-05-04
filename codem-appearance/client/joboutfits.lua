my_job = "unemployed"

function CheckJobOutfitIsAllowed(jobs)
    for _,v in pairs(jobs) do
        if v == my_job then
            return true
        end
    end
    return false
end

CreateThread(function()
    Wait(3000)
    WaitCore()
    WaitPlayer()
    my_job = GetPlayerJob()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    my_job = job.name
end)

RegisterNetEvent("QBCore:Player:SetPlayerData")
AddEventHandler("QBCore:Player:SetPlayerData", function(data)
    my_job = data.job.name
end)
local isTextUiOpen = false
-- CreateThread(function()
--     while true do
 
--         local cooldown = 1500
--         local coords = GetEntityCoords(PlayerPedId())
--         local near = false
--         local isInZone = false

--         for _,v in pairs(Config.JobOutfitsInteraction.data) do
--             for _,pos in pairs(v.coords) do
--                 local dist = #(coords - pos)
--                 if dist < 3.0 and not menuOpen and CheckJobOutfitIsAllowed(v.allowedJobs) then
--                     cooldown = 0
--                     isInZone = true
--                     near = true
--                     if Config.JobOutfitsInteraction.marker.enable then
--                         local rgba = Config.JobOutfitsInteraction.marker.rgba
--                         local size = Config.JobOutfitsInteraction.marker.size
--                         local type = Config.JobOutfitsInteraction.marker.type
    
--                         DrawMarker(type, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size, size, size, rgba[1] or 255, rgba[2] or 255, rgba[3] or 0, rgba[4] or 255, false, false, 0, true, false, false, false)
--                     end    
--                     if Config.JobOutfitsInteraction.drawText.enable then
--                         DrawText3D(pos.x, pos.y, pos.z, Config.JobOutfitsInteraction.drawText.text)
--                     end
--                     if Config.JobOutfitsInteraction.textui.enable then                    
--                         ShowHelpNotification(Config.JobOutfitsInteraction.textui.text)
--                     end
--                     if not isTextUiOpen and Config.JobOutfitsInteraction.codemtextui.enable then
--                         isTextUiOpen = true
--                         exports["codem-textui"]:OpenTextUI(Config.JobOutfitsInteraction.codemtextui.text, Config.JobOutfitsInteraction.codemtextui.keytext, Config.JobOutfitsInteraction.codemtextui.theme)
--                     end
--                     if not isTextUiOpen and Config.JobOutfitsInteraction.okoktextui.enable then
--                         isTextUiOpen = true
--                         exports['okokTextUI']:Open(Config.JobOutfitsInteraction.okoktextui.text, Config.JobOutfitsInteraction.okoktextui.color,Config.JobOutfitsInteraction.okoktextui.position)
--                     end
--                     if not isTextUiOpen and Config.JobOutfitsInteraction.ethTextUI.enable then
--                         isTextUiOpen = true
--                         exports['eth-textUi']:Show(Config.JobOutfitsInteraction.ethTextUI.header, Config.JobOutfitsInteraction.ethTextUI.text)
--                     end
--                     if IsControlJustPressed(0, Config.JobOutfitsInteraction.openKey) then
--                         OpenMenu("job")
--                         local gender = 'male'
--                         if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
--                             local Female = GetHashKey("mp_f_freemode_01")
--                             local CurrentModel = GetEntityModel(PlayerPedId())                          
--                             if CurrentModel == Female then
--                                 gender = 'female'
--                             end
--                         else
--                             local Female = GetHashKey("mp_f_freemode_01")
--                             local CurrentModel = GetEntityModel(PlayerPedId())                            
--                             if CurrentModel == Female then
--                                 gender = 'female'
--                             end
--                         end
--                         if Config.JobOutfits[GetPlayerJob()] and Config.JobOutfits[GetPlayerJob()][gender] and Config.JobOutfits[GetPlayerJob()][gender][GetPlayerJobGrade()] then
--                             NuiMessage("SET_JOB_OUTFIT_DATA", Config.JobOutfits[GetPlayerJob()][gender][GetPlayerJobGrade()])
--                         else
--                             NuiMessage("SET_JOB_OUTFIT_DATA", {})
--                         end
--                     end
--                 end
--             end
--         end
--         if isTextUiOpen and not isInZone and Config.JobOutfitsInteraction.codemtextui.enable then
--             exports["codem-textui"]:CloseTextUI()
--             isTextUiOpen = false
--         end
--         if isTextUiOpen and not isInZone and Config.JobOutfitsInteraction.okoktextui.enable then
--             exports['okokTextUI']:Close()
--             isTextUiOpen = false
--         end
--         if isTextUiOpen and not isInZone and Config.JobOutfitsInteraction.ethTextUI.enable then
--             exports['eth-textUi']:Close()
--             isTextUiOpen = false
--         end
--         if not near then
--             HideHelpNotification()
--         end
--         Wait(cooldown)
--     end
-- end)

RegisterNUICallback("wearJobClothing", function(data, cb)
    TriggerEvent('skinchanger:loadPedSkin', data.skin, PlayerPedId())
end)