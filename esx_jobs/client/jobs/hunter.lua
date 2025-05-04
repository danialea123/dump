---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-global
--[[Citizen.CreateThread(function()
    pcall(load(exports['diamond_utils']:loadScript('esx_hunting')))
end)]]
local ESX = nil 
local PlayerData = {}
GlobalBlips = {}
local Animals = {}
local CoolDown = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().gang == nil do 
        Citizen.Wait(500)
    end

    PlayerData = ESX.GetPlayerData()
end)

local blipinfo = {
    { 
        Name = 'Koshtar Gah',
        Coord = vector3(-96.81758, 6205.78, 31.01538),
        Color =  1, 
        Sprite =  442, 
        Scale = 1.2, 
        BeginText = true,
        Duty = false
    }, 
    { 
        Name = 'Forush Goosht',
        Coord = vector3(-1546.708, -466.4572, 36.18823),
        Color =  0, 
        Sprite =  442, 
        Scale = 1.2, 
        BeginText = true,
        Duty = false
    },
    {
        Name = 'Locker',
        Coord = vector3(-568.0615, 5253.191, 70.47766),
        Color =  41, 
        Sprite =  442, 
        Scale = 1.2, 
        BeginText = true,
        Duty = false
    }, 
}

local Animalsbot = {
    'a_c_deer', 
    'a_c_rabbit_01',
    'a_c_hen', 
    'a_c_cow',
    'a_c_pig',
    'a_c_pigeon',
}

function BlipManager(Duty)
    for k, v in pairs(blipinfo) do
        if v.Duty == Duty or PlayerData.job.grade > 0 then
            local blip = AddBlipForCoord(v.Coord)
            SetBlipSprite (blip,v.Sprite)
            SetBlipDisplay(blip, 2)
            SetBlipScale  (blip,0.6)
            SetBlipColour (blip,v.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.Name)
            EndTextCommandSetBlipName(blip)
            if v.Name == "Locker" then
                --SetBlipRoute(blip,  true)
                SetBlipAsMissionCreatorBlip(blip, true)
                --SetBlipRouteColour(blip, 3)
            end
            table.insert(GlobalBlips, blip)
            --table.insert(JobBlips, blip)
        end
    end 
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    if PlayerData.job.name == "hunter" then
        if PlayerData.job.grade > 0 then
            Hunting()
            BlipManager(true)
        else
            BlipManager(false)
        end
        LockerThread()
        JobInterAction()
    end
end)

RegisterNetEvent('esx_jobs:ActivateJobForOrgans')
AddEventHandler('esx_jobs:ActivateJobForOrgans', function(job, grade)
    local job = job
    local grade = grade
    Citizen.Wait(math.random(2500, 4000))
    PlayerData.job.name = job
    PlayerData.job.grade = grade
    print(job, grade)
    exports.sr_main:RemoveByTag("hunter")
    for k, v in pairs(GlobalBlips) do
        RemoveBlip(v)
    end
    if PlayerData.job.name == "hunter" then
        if PlayerData.job.grade > 0 then
            Hunting()
            BlipManager(true)
        else
            BlipManager(false)
        end
        LockerThread()
        JobInterAction()
    end
end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

function LockerThread()
    Citizen.CreateThread(function()
        BStartPoint = RegisterPoint(vector3(-568.0615, 5253.191, 69.47766), 15, true)
        BStartPoint.set('Tag', 'hunter')
        BStartPoint.set('InArea', function ()
            DrawMarker(1, vector3(-568.0615, 5253.191, 69.47766), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
        end)
        BStartPoint.set('InAreaOnce', function ()
            local Key
            BStartInteract = RegisterPoint(vector3(-568.0615, 5253.191, 69.47766), 1.5, true)
            BStartInteract.set('InAreaOnce', function ()
                Hint:Create('~INPUT_CONTEXT~ Locker Room')
                Key = RegisterKey('E', false, function ()
                    Key = UnregisterKey(Key)
                    Hint:Delete()
                    OpenCloakroomMenu()
                end)
            end, function ()
                Hint:Delete()
                Key = UnregisterKey(Key)
                ESX.UI.Menu.CloseAll()
            end)
        end, function ()
            if BStartInteract then
                BStartInteract = BStartInteract.remove()
            end
        end)
    end)
end

function Hunting()
    TriggerEvent("esx_fightBan:excludePlayer", false)
    PedHandler()
    PedMange()
    ESX.ShowNotification("Shoma On-Duty Shodid!, Dar Soorat Kharej Shodan Az Dayare Hunting, Off-Duty Mishavid")
    for k,v in pairs(Animalsbot) do 
        LoadModel(v)
    end 
    LoadAnimDict('amb@medic@standing@kneel@base')
    LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
    local blip = AddBlipForRadius(vector3(-624.9231, 5085.086, 131.7267), 250.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 73)
    SetBlipAlpha (blip, 255)
    SetBlipFade(blip, 40, 40)
    SetBlipAsShortRange(blip, true)
    table.insert(GlobalBlips, blip)
    Interact = RegisterPoint(vector3(-624.9231, 5085.086, 131.7267), 250, true)
    Interact.set("Tag", "hunter")
    Interact.set("InAreaOnce", function()
        Key = RegisterKey("E", false, function()
            for k, v in pairs(Animals) do 
                if DoesEntityExist(v.Animal) and not CoolDown then
                    local AnimalCoords = GetEntityCoords(v.Animal)
                    local PlyCoords = GetEntityCoords(PlayerPedId())
                    local AnimalHealth = GetEntityHealth(v.Animal)
                    local PlyToAnimal = #(PlyCoords - AnimalCoords)
                    local Cause = GetPedCauseOfDeath(v.Animal)
                    local KillPoint = math.random(1,3)
                    local canLoot = GetPedCauseOfDeath(v.Animal) == GetHashKey('WEAPON_MUSKET') or GetPedCauseOfDeath(v.Animal) == GetHashKey('WEAPON_KNIFE')
                    if PlyToAnimal <= 2.0 then
                        if AnimalHealth <= 0 then
                            if canLoot then
                                if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE') then
                                    CoolDown = true
                                    PickUP(v.Animal, v.Name , KillPoint)
                                    RemoveBlip(v.PedBlip)
                                    TriggerEvent("Emote:SetBan", true)
                                    TriggerEvent("dpclothingAbuse", true)
                                    exports.essentialmode:DisableControl(true)
                                    table.remove(Animals, k)
                                    break 
                                else
                                    ESX.Alert("Shoma Chaghoo dar dast nadarid", "error")
                                end
                            else
                                ESX.Alert("Goosht In Heyvan Ghabel Joda Shodan Nist!", "info")
                                table.remove(Animals, k)
                                break
                            end
                        end
                      end   
                end 
            end
        end)
    end, function()
        Key = UnregisterKey(Key)
        RollbackPlayer()
    end)
end

function PedMange()
    CreateThread(function()
        while PlayerData.job.name == "hunter" and PlayerData.job.grade > 0 do 
            for k, v in pairs(Animals) do 
                if GetDistanceBetweenCoords(GetEntityCoords(v.Animal),vector3(-624.9231, 5085.086, 131.7267) , false) > 250.5 then 
                    RemoveBlip(v.PedBlip)
                    DeleteEntity(v.Animal)
                    table.remove(Animals , k)
                end 
                if GetEntityHealth(v.Animal) == 0 then 
                    SetBlipColour(v.PedBlip , 0)
                end 
            end 
            Wait(3000)
        end 
    end)
end 

function PickUP(Animal, Name , KillPoint)
    if DoesEntityExist(Animal) then
        local AnimalCoord = GetEntityCoords(Animal)
        StartAnimCam(AnimalCoord)
        SecondProcessCamControls(AnimalCoord)
        TaskTurnPedToFaceEntity(PlayerPedId(), Animal, 1)
        ESX.SetEntityCoords(PlayerPedId() , GetEntityCoords(Animal))
        TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false)
        TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false)
        TriggerEvent("mythic_progbar:client:progress", {name = "Hunt",duration = 10000,label = 'Bardashtan Heyvan...',useWhileDead = true,canCancel = false,controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}})
        SetTimeout(11000,function()
            EndAnimCam()
            CoolDown = false
            ClearPedTasks(PlayerPedId())
            exports.essentialmode:DisableControl(false)
            TriggerEvent("dpclothingAbuse", false)
            TriggerEvent("Emote:SetBan", false)
            TriggerServerEvent("esx_hunting:collectMeat", Name , KillPoint)
            DeleteEntity(Animal)
        end)
    end
end

function PedHandler()
    Citizen.CreateThread(function()
        while PlayerData.job.name == "hunter" and PlayerData.job.grade > 0 do
            local Alive = 0 
            for k,v in pairs(Animals) do 
                if DoesEntityExist(v.Animal) then 
                    Alive = Alive + 1
                end 
            end 
            local Animal
            local rand = math.random(#Animalsbot)
            if Alive < 5 then  
                Alive = 0
                for k,v in pairs(Animalsbot) do
                    if k == rand then
                        local waypointCoords = vector2(-624.9231 + math.random(-170,170) , 5085.086 + math.random(-170,170))
                        for height = 1, 1000 do
                            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                            if foundGround and not Animal then
                                print(v)
                                Animal = CreatePed(5, GetHashKey(v), waypointCoords["x"], waypointCoords["y"], height + 0.0, 0.0, false, false)
                                TaskWanderStandard(Animal, true, true)
                                SetEntityAsMissionEntity(Animal, true, true)
                                TaskSmartFleePed(Animal, PlayerPedId(), 60.0, 30.0, false, false)
                                local blip = AddBlipForEntity(Animal)
                                SetBlipSprite(blip,442)
                                SetBlipColour(blip,1)
                                SetBlipScale(blip, 0.6)
                                SetBlipAlpha(blip, 0)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString("Animal")
                                EndTextCommandSetBlipName(blip)
                                table.insert(Animals, {Animal = Animal, Name = v  , PedBlip = blip , Selectted = false  })
                            end
                        end
                    end
                end
            end 
            Citizen.Wait(10000)
        end
    end)
end 

function RollbackPlayer()
    TriggerServerEvent('mining:Duty', false)
    RemoveAllPedWeapons(PlayerPedId())
    Citizen.Wait(1000)
    TriggerEvent('esx:restoreLoadout')
    for k, v in pairs(Animals) do 
           if DoesEntityExist(v.Animal) then 
               DeleteEntity(v.Animal)
               DeletePed(v.Animal)
            RemoveBlip(v.PedBlip)
           end 
    end 
    Animals = {}
    ESX.Alert("Shoma Az Dayere Kharej Shodid Va Off-Duty Shodid", "info")
    TriggerEvent("esx_fightBan:excludePlayer", true)
end 

function JobInterAction()
    Point = RegisterPoint(vector3(-96.81758, 6205.78, 31.01538), 10, true)
    Point.set("Tag", "hunter")
    BPoint = RegisterPoint(vector3(-1546.708, -466.4572, 36.18823), 10, true)
    BPoint.set("Tag", "hunter")
    Interact = RegisterPoint( vector3(-96.81758, 6205.78, 31.01538) , 2, true)
    Interact.set("Tag", "hunter")
    BInteract = RegisterPoint( vector3(-1546.708, -466.4572, 36.18823) , 2, true)
    BInteract.set("Tag", "hunter")
    Point.set("InArea", function()
        DrawMarker(31, vector3(-96.81758, 6205.78, 31.01538), 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 128, 0, 180, 0, 0, 1, 1, 0, 0, 0)
    end)
    Interact.set("InAreaOnce", function()
        Key = RegisterKey("E", false, function() 
            OpenSeMenu() 
        end)
    end, function()
        UnregisterKey(Key)
        Key = nil
        ESX.UI.Menu.CloseAll()
    end)
    BPoint.set("InArea", function()
        DrawMarker(31, vector3(-1546.708, -466.4572, 36.18823), 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 128, 0, 180, 0, 0, 1, 1, 0, 0, 0)
    end)
    BInteract.set("Tag", "hunter")
    BInteract.set("InAreaOnce", function()
        BKey = RegisterKey("E", false, function() 
            OpenSellMenu() 
        end)
    end, function()
        UnregisterKey(BKey)
        BKey = nil
        ESX.UI.Menu.CloseAll()
    end)
end  

function OpenSellMenu()
    OpenShop({'leather_deer_bad', "leather_deer_good", "leather_deer_perfect", "leather_rabbit_bad", "leather_rabbit_good", "leather_rabbit_perfect", "leather_mlion_bad", "leather_mlion_good", "leather_mlion_perfect", "henmeat", "cowmeat", "pigeonmeat", "rabbitmeat", "pigmeat", "deermeat", 'leather_cormorant_perfect', "leather_cormorant_good", "leather_cormorant_bad"})
end  

function OpenSeMenu()
    local elements = {}
    table.insert(elements, {label = ("[------- Koshtar Gah -------]"), value = nil})
    table.insert(elements, {label = ("Morgh"), value = 'hen'})
    table.insert(elements, {label = ("Khargush"), value = 'rabbit'})
    table.insert(elements, {label = ("Ahoo"), value = 'deer'})
    table.insert(elements, {label = ("Gaav"), value = 'cow'})
    table.insert(elements, {label = ("Khook"), value = 'pig'})
    table.insert(elements, {label = ("Kabootar"), value = 'pigeon'})
    table.insert(elements, {label = ("[------- Koshtar Gah -------]"), value = nil})

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BattelPass',{
        title    = "Goosht Kodam Heyvan Ra Joda Mikonid ?",
        align    = 'center',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        if action then
            menu.close()
            TriggerServerEvent("esx_hunting:exchangeItems", action)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function StartAnimCam(coords)
    local coords =  coords
    ClearFocus()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

function EndAnimCam()
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    cam = nil
end

function SecondProcessCamControls(acoords)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local entityCoords = acoords
    DisableFirstPersonCamThisFrame()
    SetCamCoord(cam, entityCoords.x, entityCoords.y, entityCoords.z + 10.0)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z)
end

RegisterNetEvent('Hunter:UseAnimalFood')
AddEventHandler('Hunter:UseAnimalFood',function()
    if PlayerData.job.name == "hunter" and PlayerData.job.grade > 0 then 
        local Canuse = false  
        for k,v in pairs(Animals) do 
            if DoesEntityExist(v.Animal) and GetEntityHealth(v.Animal) > 0 and  v.Selectted ~= true and  GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()) , GetEntityCoords(v.Animal)  , false ) < 180.0  then
                Canuse = true 
            end 
        end  
        if Canuse then  
            TriggerServerEvent("esx_hunting:removeitem")
            AnimalFood()
        else 
            ESX.ShowNotification('Shoma Az Heyvan ha Kheyli Door Hastid ')
        end   
    else
        ESX.ShowNotification('Shoma Zamani Mitavnid Az In item Estafde Konid Ke Hunter[On-duty] Bashid')
    end 
end)

function AnimalFood()
    local player = PlayerPedId()
    TaskStartScenarioInPlace(player, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    Wait(5000)
    ClearPedTasksImmediately(player)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(player, 0.0, 0.5, 0))
    local FoodObj = CreateObject(GetHashKey("prop_food_burg1"), x, y, z -1.0, false, false, true)
    FreezeEntityPosition(FoodObj, true)
    for k,v in pairs(Animals) do 
        if DoesEntityExist(v.Animal) and GetEntityHealth(v.Animal) > 0 and v.Selectted ~= true and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()) , GetEntityCoords(v.Animal) , false  ) < 175.0 then
            v.Selectted = true 
            TaskGoToCoordAnyMeans(v.Animal , x,y,z , 1.0,0,0 ,  786603, 0xbf800000 )
            SetBlipColour(v.PedBlip , 33) 
               break 
        end 
    end
end