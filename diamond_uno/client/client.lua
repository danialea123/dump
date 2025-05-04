---@diagnostic disable: param-type-mismatch, missing-parameter, lowercase-global, undefined-field, undefined-global
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

local currentId = GetPlayerServerId(PlayerId())
local currentGame = nil
local gameStart = false

function spawnTable()
	local model = Config.UnoTable
    loadModel(model)
    currentArt = CreateObject(model, GetEntityCoords(PlayerPedId()), 1, 1, 1)
    SetEntityCollision(currentArt, false)
    CreateTablePlacer()
end

function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
end

function FindRaycastedSprayCoords()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)

    local rayStart = cameraCoord
    local rayDirection = direction

    if not LastRayStart or not LastRayDirection or ((not LastComputedRayEndCoords or not LastComputedRayNormal) and not LastError) or rayStart ~= LastRayStart or rayDirection ~= LastRayDirection then
        LastRayStart = rayStart
        LastRayDirection = rayDirection

        local result, error, rayEndCoords, rayNormal = FindRaycastedSprayCoordsNotCached(ped, coords, rayStart, rayDirection)

        if result then
            if LastSubtitleText then
                LastSubtitleText = nil
                ClearPrints()
            end

            LastComputedRayEndCoords = rayEndCoords
            LastComputedRayNormal = rayNormal
            LastError = nil

            return LastComputedRayEndCoords, LastComputedRayNormal, LastComputedRayNormal
        else
            LastComputedRayEndCoords = nil
            LastComputedRayNormal = nil
            LastError = error
            DrawSubtitleText(error)
        end
    else
        return LastComputedRayEndCoords, LastComputedRayNormal, LastComputedRayNormal
    end

end

function FindRaycastedSprayCoordsNotCached(ped, coords, rayStart, rayDirection)
    local rayHit, rayEndCoords, rayNormal, materialHash = CheckRay(ped, rayStart, rayDirection)
    local ray2Hit, ray2EndCoords, ray2Normal, _ = CheckRay(ped, rayStart + vector3(0.0, 0.0, 0.2), rayDirection)
    local isOnGround = ray2Normal.z > 0.9
	return true, '', rayEndCoords, rayNormal, rayNormal
end

function RotationToDirection(rotation)
	local adjustedRotation = { x = (math.pi / 180) * rotation.x, y = (math.pi / 180) * rotation.y, z = (math.pi / 180) * rotation.z }
	return vector3(-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.sin(adjustedRotation.x))
end

function CheckRay(ped, coords, direction)
    local rayEndPoint = coords + direction * 1000.0
    local rayHandle = StartShapeTestRay(coords.x,coords.y,coords.z,rayEndPoint.x,rayEndPoint.y,rayEndPoint.z,1, ped)
	local retval,hit, endCoords, surfaceNormal, materialHash,entityHit = GetShapeTestResultEx(rayHandle)
    return hit == 1, endCoords, surfaceNormal, materialHash
end

function CreateTablePlacer()
    Citizen.CreateThread(function()
        while currentArt do
            Citizen.Wait(1)
            ESX.ShowHelpNotification(_U("place_table_help"))
            local rayEndCoords, rayNormal, fwdVector = FindRaycastedSprayCoords()
            SetEntityCoords(currentArt, rayEndCoords, 1, 1, 1, 1)
            FreezeEntityPosition(currentArt, true)
            DisableControlAction(0, 24, true)
            if IsControlPressed(0, 175) then
                local rotate = GetEntityRotation(currentArt)
                SetEntityRotation(currentArt, rotate.x, rotate.y, rotate.z+1, false, true)
            end
            if IsControlPressed(0, 174) then
                local rotate = GetEntityRotation(currentArt)
                SetEntityRotation(currentArt, rotate.x, rotate.y, rotate.z-1, false, true)
            end
            if IsDisabledControlJustPressed(0, 24) then
                local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(currentArt))
    
                if distance <= 5 then
                    selectPlayer()
                else
                    ESX.ShowNotification(_U("place_distance_error"))
                end
            end
        end
    end)
end

local playerAmount = 4

local cards = {
    [1] = {
        value = "b"
    },
    [2] = {
        value = "r"
    },
    [3] = {
        value = "g"
    },
    [4] = {
        value = "y"
    },
    [5] = {
        value = "x"
    }
}

RegisterNUICallback('createGame', function(data)
    createGame(data.player)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('giveMeCard', function()
    TriggerServerEvent('D-uno:giveMeCard', currentGame)
end)

RegisterNUICallback('updateCard', function(data)
    TriggerServerEvent('D-uno:updateCard', currentGame)
end)

RegisterNUICallback('putCard', function(data)
    TriggerServerEvent('D-uno:asdasdasdas', tonumber(data.id), currentGame)
end)

RegisterNUICallback('giveFirstCard', function(data)
    createGame(data.player)
    SetNuiFocus(false, false)
end)

function selectPlayer()
    SendNUIMessage({
        type = "selectPlayer"
    })
    SetNuiFocus(true, true)
end

function createGame(player)
    TriggerServerEvent('D-uno:createGame', GetEntityCoords(currentArt), GetEntityHeading(currentArt), player)
    DeleteObject(currentArt)
    currentArt = nil
end

local games = {}

RegisterNetEvent('D-uno:addGame')
AddEventHandler('D-uno:addGame', function (coord, id, player)
    local model = Config.UnoTable
    loadModel(model)
    local unoModel = CreateObject(model, coord, false, true, true)
    games[id] = {owner = false, players = {}, coord = coord, maxPlayer = player, model = unoModel, started = false}
    uno = unoModel
end)

RegisterNetEvent('D-uno:putCard')
AddEventHandler('D-uno:putCard', function (card, chair, image)
    SendNUIMessage({
        type = "putCard",
        card = card,
        mine = chair == currentId,
        image = image
    })
end)

RegisterNetEvent('D-uno:setOwner')
AddEventHandler('D-uno:setOwner', function (id)
    games[id]["owner"] = true
end)

RegisterNetEvent('D-uno:updateCard')
AddEventHandler('D-uno:updateCard', function (data)
    for k,v in pairs(data) do
        local chair = findChair(k)
        SendNUIMessage({
            type = "updateCard",
            number = v,
            chair = chair
        })
        if games[currentGame]["owner"] then
            if tonumber(v) == 0 then
                TriggerServerEvent('D-uno:win', k, currentGame)
            end
        end
    end
end)

RegisterNetEvent('D-uno:win')
AddEventHandler('D-uno:win', function (info)
    SendNUIMessage({
        type = "win",
        image = info.image,
        nick = info.nick
    })
end)

local sleep = 1000
local targetShop = nil

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(games) do
            local myCoord = GetEntityCoords(PlayerPedId())
            if (GetDistanceBetweenCoords(myCoord, v.coord, true) < 5.0) then
                sleep = 0
                targetShop = k
                break
            end
            sleep = 1000
            targetShop = nil
        end
        Citizen.Wait(1000)
    end
end)

function updateMarker()
    if not HasStreamedTextureDictLoaded("unoMarker") then
        RequestStreamedTextureDict("unoMarker", true)
        while not HasStreamedTextureDictLoaded("unoMarker") do
            Wait(1)
        end
    end
end

RegisterNetEvent('D-uno:deleteGame')
AddEventHandler('D-uno:deleteGame', function (id)
    DeleteObject(games[id]["model"])
    games[id] = nil
end)

Citizen.CreateThread(function()
    while true do
        if targetShop and games[targetShop] then
            local info = games[targetShop].coord
            updateMarker()
            DrawMarker(9, info.x, info.y, info.z+0.5, 0.0, 0.0, 0.0, 90.0, 90.0, 0.0, 0.7, 0.7, 0.7, 255, 255, 255, 255,false, false, 2, true, "unoMarker", "uno", false)
            if not games[targetShop]["owner"] then
                ESX.ShowHelpNotification(getJoinMessage().."\n".._U('players')..": "..getPlayerCount().."/"..games[targetShop].maxPlayer, Config.Beep, false, 2000)
            else
                ESX.ShowHelpNotification(getJoinMessage().."\n".._U("delete").."\n".._U('players')..": "..getPlayerCount().."/"..games[targetShop].maxPlayer, Config.Beep, false, 2000)
            end
            if IsControlJustPressed(0, 323) then
                deleteGame(targetShop)
                Citizen.Wait(1000)
            end
            if IsControlJustPressed(0, 38) then
                join(targetShop)
            end
        end
        Citizen.Wait(sleep)
    end
end)

function backGame()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "back"
    })
end

function join(id)
    if games[id]["owner"] then
        if not gameStart then
            if getPlayerCount() == games[id].maxPlayer then
                TriggerServerEvent('D-uno:startGame', id, games[id].maxPlayer)
                currentGame = id
            end
        else
            backGame()
        end
    else
        if imIn(id) then
            if not gameStart then
                TriggerServerEvent('D-uno:leaveGame', id)
                currentGame = nil
            else
                backGame()  
            end
        else
            if not games[targetShop]["started"] then
                TriggerServerEvent('D-uno:joinGame', id)
                currentGame = id
            else
                ESX.ShowNotification(_U('started'))
            end
        end
    end
end

function imIn(id)
    for k,v in pairs(games[id]["players"]) do
        if currentId == v then
            return true
        end
    end
    return false
end

RegisterNetEvent('D-uno:joinGame')
AddEventHandler('D-uno:joinGame', function (game, id)
    local queqe = getPlayerCount()+1
    games[game]["players"][queqe] = id
end)

RegisterNetEvent('D-uno:startGame')
AddEventHandler('D-uno:startGame', function (game, max)
    games[game]["started"] = true
    if imIn(game) then
        SendNUIMessage({
            type = "openGame",
            max = max
        })
        gameStart = true
        SetNuiFocus(true, true)
    else
        if games[game]["owner"] then
            SendNUIMessage({
                type = "openGame",
                max = max
            })
            gameStart = true
            SetNuiFocus(true, true)
            TriggerServerEvent('D-uno:giveFirstCard', games[game], game)
        end
    end
end)

RegisterNetEvent('D-uno:updateProfil')
AddEventHandler('D-uno:updateProfil', function (profiles)
    for k,v in pairs(profiles) do
        local chair = findChair(k)
        SendNUIMessage({
            type = "updateProfil",
            chair = chair,
            image = v.image,
            nick = v.nick
        })
    end
end)

RegisterNetEvent('D-uno:leaveGame')
AddEventHandler('D-uno:leaveGame', function (game, id)
    for k,v in pairs(games[game]["players"]) do
        if id == v then
            games[game]["players"][k] = nil
        end
    end
end)

function getJoinMessage()
    if games[targetShop]["owner"] then
        if getPlayerCount() == games[targetShop].maxPlayer then
            if not gameStart then
                return _U("start")
            else
                return _U("back")
            end
        else
            return _U('waiting')
        end
    else
        if not gameStart then
            if currentGame then
                return _U('leave')
            else
                return _U('join')
            end
        else
            return _U("back")
        end
    end
end

function deleteGame(id)
    if games[id]["owner"] then
        if games[id]["started"] then
            TriggerServerEvent('D-uno:closeGame', id)
        end
        TriggerServerEvent('D-uno:deleteGame', id)
    end
end

function checkOwner()
    if games[targetShop]["owner"] then
        return _U('waiting')
    else
        return _U('join')
    end
end

function getPlayerCount()
    local number = 0
    for k,v in pairs(games[targetShop]["players"]) do
        number = number+1
    end
    return number+1
end

local line = nil

RegisterNetEvent('D-uno:updateLine')
AddEventHandler('D-uno:updateLine', function (l, myChair, id)
    SendNUIMessage({type = "resetChair"})
    line = l
    local maxPlayer = games[id]["maxPlayer"]
    line[myChair]["chair"] = "me"
    if maxPlayer == 2 then
        if myChair == 1 then
            line[2]["chair"] = "top"
        else
            line[1]["chair"] = "top"
        end
    elseif maxPlayer == 3 then
        local myLine = findMyChair()
        if myLine == 3 then
            line[2]["chair"] = "left"
            line[1]["chair"] = "top"
        elseif myLine == 2 then
            line[1]["chair"] = "left"
            line[3]["chair"] = "right"
        elseif myLine == 1 then
            line[2]["chair"] = "left"
            line[3]["chair"] = "top"
        end
    end
    openChairs()
end)

function openChairs()
    for k,v in pairs(line) do
        if v.chair ~= "me" then
            SendNUIMessage({
                type = "openChair",
                chair = v.chair
            })
        end
    end
end

function findMyChair()
    for k,v in pairs(line) do
        if currentId == v.id then
            return k
        end
    end
end
local number = 0

RegisterNetEvent('D-uno:addCard')
AddEventHandler('D-uno:addCard', function (card, player, id)
    local chair = findChair(player)
    SendNUIMessage({
        type = "addCard",
        chair = chair,
        cardImage = card.image,
        id = id,
    })
    number = number+1
end)

RegisterNetEvent('D-uno:updateColor')
AddEventHandler('D-uno:updateColor', function (color)
    SendNUIMessage({
        type = "updateColor",
        color = color
    })
end)

RegisterNetEvent('D-uno:randomCard')
AddEventHandler('D-uno:randomCard', function (card)
    SendNUIMessage({
        type = "randomCard",
        card = card
    })
end)

RegisterNetEvent('D-uno:canPlay')
AddEventHandler('D-uno:canPlay', function (player)
    if player == currentId then
        SendNUIMessage({
            type = "canPlay"
        })
    end
end)

function findChair(player)
    for k,v in pairs(line) do
        if v.id == player then
            return v.chair
        end
    end
end

RegisterNetEvent('D-uno:openColor')
AddEventHandler('D-uno:openColor', function ()
    SendNUIMessage({
        type = "color"
    })
end)

RegisterNetEvent('D-uno:closeGame')
AddEventHandler('D-uno:closeGame', function ()
    SendNUIMessage({
        type = "close"
    })
    SetNuiFocus(false, false)
    currentGame = nil
    ESX.ShowNotification(_U('closed'))
    gameStart = false
end)

RegisterNUICallback('selectColor', function(data)
    TriggerServerEvent('D-uno:selectColor', data.color, currentGame)
end)

RegisterNUICallback('tab', function(data)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('D-uno:closeGameAfterWin')
AddEventHandler('D-uno:closeGameAfterWin', function(game)
    Citizen.Wait(5000)
    if currentGame then
        if games[game] then
            if games[game]["owner"] then
                deleteGame(currentGame)
            end
        end
    end
end)

RegisterNetEvent('D-uno:use')
AddEventHandler('D-uno:use', function ()
    spawnTable()
end)