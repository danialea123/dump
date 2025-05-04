ESX = nil

xSound = exports.xsound

local Steam
Config.DJPositions = json.decode(LoadResourceFile(GetCurrentResourceName(), 'position.lua'))
if not Config.DJPositions then
    Config.DJPositions = {}
end
for k, v in pairs(Config.DJPositions) do
    v.pos = vector3(v.pos.x, v.pos.y, v.pos.z)
end
if Config.useESX then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end

        Citizen.Wait(100)

        while ESX.GetPlayerData().job == nil do
            Wait(50)
        end
        PlayerData = ESX.GetPlayerData()
        Steam = ESX.GetPlayerData().identifier
        ESX.TriggerServerCallback('myDJ:receiveRunningSongs', function(DJPositions)
            if DJPositions ~= nil then
                for k, v in pairs(DJPositions) do
                    if v.currentData ~= nil then
                        if v.currentData.titleFromPlaylist then
                            playTitleFromPlaylist(v.name, v.pos, v.range, v.currentData.currentLink, v.currentData.currentPlaylist)
                        else
                            playSong(v.name, v.pos, v.range, v.currentData.currentLink)
                            isMusicPaused = false
                        end

                        if xSound:soundExists(v.name) then
                            xSound:setTimeStamp(v.name, v.currentData.currentTime)
                            if not v.currentData.currentlyPlaying then
                                startStopSong(v.name)
                            end
                        end

                    end
                end
            end
    
        end)


    end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local isNearDJ = false
local isAtDJ = false
local currentDJ = Config.DJPositions[1]
local isSongRunning = true
local isMusicPaused = false

--[[
local songs = {
    {id = 1, playlist = 1, link = "https://www.youtube.com/watch?v=L9WRBL19QDE"},
    {id = 2, playlist = 2, link = "https://www.youtube.com/watch?v=W9iUh23Xrsg"},
    {id = 3, playlist = 2, link = "https://www.youtube.com/watch?v=L9WRBL19QDE"},
    {id = 4, playlist = 2, link = "https://www.youtube.com/watch?v=W9iUh23Xrsg"}
}

local playlists = {
    {label = 'LUL', id = 1},
    {label = 'LOL', id = 2},
}
--]]


Citizen.CreateThread(function()

    while true do

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed, true) 

        isAtDJ = false
        isNearDJ = false

        for k, v in pairs(Config.DJPositions) do
            if (not Config.useESX or v.requiredJob == nil or ESX ~= nil and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == v.requiredJob) then
                local distance = Vdist(playerCoords, v.pos.x, v.pos.y, v.pos.z)

                if distance < 2.0 then
                    currentDJ = v
                    isAtDJ = true
                    isNearDJ = true
                elseif distance < 25.0 then
                    isNearDJ = true
                    currentDJ = v
                end
            end
        end

        Citizen.Wait(1000)
    end

end)

-- local examplePlaylist = {
--     {link = "https://www.youtube.com/watch?v=6Dh-RL__uN4", name = "test2"},
--     {link = "https://www.youtube.com/watch?v=Z4lJdnRhyMs&list=LL&index=4", name = "google"},
-- }


-- Citizen.CreateThread(function()

--     Citizen.Wait(1000)
--     local pos = GetEntityCoords(PlayerPedId())
--     --SetNuiFocus(true, true)
--     xSound:PlayUrlPos(currentDJ.name ,"https://www.youtube.com/watch?v=6Dh-RL__uN4", 1 , pos)
--     xSound:Distance(currentDJ.name, 100)
--     -- stopSong()
--     --startSongFromPlaylist(1, examplePlaylist)
-- end)
--]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        local Sleep = true 
        if isAtDJ then
            Sleep = false
            showInfobar(Translation[Config.Locale]['DJ_interact'])
            DrawMarker(27, currentDJ.pos.x, currentDJ.pos.y, currentDJ.pos.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0*1.5, 1.0*1.5, 1.0, 136, 0, 136, 75, false, false, 2, false, false, false, false)
            if IsControlJustReleased(0, 38) then
                if currentDJ.access[Steam] or (currentDJ.name and string.lower(currentDJ.name) == string.lower(PlayerData.job.name) and PlayerData.job.grade >= 4) then
                    SetNuiFocus(true, true)
                    isDjOpen = true
                    SendNUIMessage({type = 'open'})
                    ESX.TriggerServerCallback('myDJ:requestPlaylistsAndSongs', function(playlists, songs)
                        SendNUIMessage({type = 'getPlaylists', playlists = playlists, songs = songs})
                    end)
                else
                    ESX.Alert("Shoma Dastresi Nadarid", "info")
                end
            end
        end 
        if Sleep then Citizen.Wait(750) end 
    end
end)

RegisterNetEvent('myDj:open')
AddEventHandler('myDj:open', function()
    SetNuiFocus(true, true)
    isDjOpen = true
    SendNUIMessage({type = 'open'})
    ESX.TriggerServerCallback('myDJ:requestPlaylistsAndSongs', function(playlists, songs)
        SendNUIMessage({type = 'getPlaylists', playlists = playlists, songs = songs})
    end)
end)

-- sync timestamps
Citizen.CreateThread(function()
    while true do

        if currentDJ ~= nil then
            if xSound ~= nil and xSound:soundExists(currentDJ.name) then
                --print('Sound running: ' .. xSound:getTimeStamp(currentDJ.name) .. ' / ' .. xSound:getMaxDuration(currentDJ.name))
                
                if xSound:isPlaying(currentDJ.name) then
                    --print('Currently playing: ' .. xSound:getLink(currentDJ.name))
                    SendNUIMessage({type = 'updateSeconds', maxDuration = xSound:getMaxDuration(currentDJ.name), secs = xSound:getTimeStamp(currentDJ.name)})
                end
            end
        end

        Citizen.Wait(1000)
    end
end)

function playSong(DJName, DJPos, DJRange, songlink)
    local options =
    {
        onPlayStart = function(event) -- event argument returns getInfo(id)
            --print("oh yeah! PARTY!")
        end,
        onPlayEnd = function(event) 
            --print("oh... already end ? :( Song name ? pls")
            --print(event.url)
        end,
    }   

    xSound:PlayUrlPos(DJName, songlink, 1, DJPos, false, options)
    xSound:Distance(DJName, DJRange)
    SendNUIMessage({type = 'updateSonginfos', link = songlink})
end

function startStopSong(DJName)

    if xSound:soundExists(DJName) and isMusicPaused then
        xSound:Resume(DJName) 
        isMusicPaused = false
    elseif xSound:soundExists(DJName) and not isMusicPaused then
        xSound:Pause(DJName)
        isMusicPaused = true

    end

end

function stopSong(DJName)
    xSound:Destroy(DJName) 
end

function rewindSong(DJName)
    if currentDJ ~= nil then
		if xSound:soundExists(DJName) then
			if xSound:isPlaying(DJName) then
				local currTimestamp = xSound:getTimeStamp(DJName)
				if currTimestamp - 10 < 0 then
					xSound:setTimeStamp(0)
				else
					xSound:setTimeStamp(DJName, currTimestamp - 10)
				end
				
			end
		end
	end
end

function forwardSong(DJName)
    if currentDJ ~= nil then
		if xSound:soundExists(DJName) then
			if xSound:isPlaying(DJName) then
				local currTimestamp = xSound:getTimeStamp(DJName)
				xSound:setTimeStamp(DJName, currTimestamp + 10)
			end
		end
	end
end

function volumeUp(DJName)
    if xSound:soundExists(DJName) then
        if currentDJ.volume + 0.1 >= 1 then
            currentDJ.volume = 1.0
            xSound:setVolume(DJName, 1.0)
            --ShowNotification('~g~Maximum volume reached')
        else
            currentDJ.volume = currentDJ.volume + 0.1
            xSound:setVolume(DJName, currentDJ.volume + 0.1)
            --ShowNotification('~g~Volume set to: ' .. (currentDJ.volume + 0.1) * 100 .. '%')
        end
        
    end
end

function volumeDown(DJName)
    if xSound:soundExists(DJName) then

        local currentVolume = 1.0

        for k,v in pairs(Config.DJPositions) do
            if v.name == DJName then
                currentVolume = v.volume
            end
        end

        if currentDJ.volume - 0.1 <= 0 then
            currentDJ.volume = 0.0
            xSound:setVolume(DJName, 0.0)
            --ShowNotification('~g~Minimum volume reached')
        else
            currentDJ.volume = currentDJ.volume - 0.1
            xSound:setVolume(DJName, currentDJ.volume - 0.1)
            --ShowNotification('~g~Volume set to: ' .. (currentDJ.volume - 0.1) * 100 .. '%')
        end
        
    end
end

function playTitleFromPlaylist(DJName, DJPos, DJRange, link, playlistId)
    ESX.TriggerServerCallback('myDJ:requestPlaylistById', function(playlistSongs)
		if playlistSongs ~= nil then
			for k, v in pairs(playlistSongs) do
				if v.link == link then
					startSongFromPlaylist(DJName, DJPos, DJRange, k, playlistSongs)
				end
			end
		end
	end, playlistId)
end

function startSongFromPlaylist(DJName, DJPos, DJRange, startIndex, playlist)

    --isSongRunning = true

    for i = startIndex, #playlist, 1 do

        --print('started a new song # ' .. i)

        local options =
        {
            onPlayStart = function(event) -- event argument returns getInfo(id)
                --print('Song started')
                isSongRunning = true
            end,
            onPlayEnd = function(event) 
                --print("oh... already end ? :( Song name ? pls")
                isSongRunning = false
            end,
        }   
    
        xSound:PlayUrlPos(DJName, playlist[i].link, 1, DJPos, false, options)
        xSound:Distance(DJName, DJRange)

        while isSongRunning do
            Citizen.Wait(1000)
            --print('Song is running, wait until end')
        end

        --print('now you can start a new song')

    end

end

if Config.enableCommand then
    RegisterCommand('openDJ', function(source, args, rawCommand)
        SetNuiFocus(true, true)
        isDjOpen = true
        SendNUIMessage({type = 'open'})
        ESX.TriggerServerCallback('myDJ:requestPlaylistsAndSongs', function(playlists, songs)
            SendNUIMessage({type = 'getPlaylists', playlists = playlists, songs = songs})
        end)
    end, false)
end

RegisterNUICallback('close', function(data, cb) 
    SetNuiFocus(false, false)
    isDjOpen = false
end)

RegisterNetEvent('myDj:clientStartStop')
AddEventHandler('myDj:clientStartStop', function(DJName)
    startStopSong(DJName)
end)

RegisterNUICallback('togglePlaystate', function(data, cb)
    --print('gotPlaystateTrigger')
    TriggerServerEvent('myDj:syncStartStop', currentDJ.name)
    --print('server triggered')
end)

RegisterNetEvent('myDj:clientPlaySong')
AddEventHandler('myDj:clientPlaySong', function(DJName, DJPos, DJRange, link)
    --print('got server trigger: play ' .. link)
    playSong(DJName, DJPos, DJRange, link)
    isMusicPaused = false
end)

RegisterNUICallback('playNewSong', function(data, cb) 
    --print(data.link) -- der Link zur Musik
    --print('got NUI trigger')
    --print('play now ' .. data.link .. 'at ' .. tostring(currentDJ.pos))
    TriggerServerEvent('myDj:syncPlaySong', currentDJ.name, currentDJ.pos, currentDJ.range, data.link)
end)

RegisterNetEvent('myDj:clientPlaySongFromPlaylist')
AddEventHandler('myDj:clientPlaySongFromPlaylist', function(DJName, DJPos, DJRange, link, playlistId)
    playTitleFromPlaylist(DJName, DJPos, DJRange, link, playlistId)
end)

RegisterNUICallback('playSongFromPlaylist', function(data, cb)
    -- Song ID = data.id
    -- Playlist ID = data.playlistId
    -- Songlink = data.link
	--playTitleFromPlaylist(currentDJ.name, currentDJ.pos, data.link, data.playlistId)
	TriggerServerEvent('myDj:syncPlaySongFromPlaylist', currentDJ.name, currentDJ.pos, currentDJ.range, data.link, data.playlistId)
end)

RegisterNetEvent('myDj:clientRewind')
AddEventHandler('myDj:clientRewind', function(DJName)
    rewindSong(DJName)
end)

RegisterNUICallback('rewind', function(data, cb)
    -- 10 secs zurück 
	-- rewindSong(currentDJ.name)
    TriggerServerEvent('myDj:syncRewind', currentDJ.name)
end)

RegisterNetEvent('myDj:clientForward')
AddEventHandler('myDj:clientForward', function(DJName)
    forwardSong(DJName)
end)

RegisterNUICallback('forward', function(data, cb)
    -- 10 secs vorwärts 
	TriggerServerEvent('myDj:syncForward', currentDJ.name)
end)

RegisterNetEvent('myDj:clientVolumeDown')
AddEventHandler('myDj:clientVolumeDown', function(DJName)
    volumeDown(DJName)
end)

RegisterNUICallback('down', function(data, cb)
    -- leiser machen
    TriggerServerEvent('myDj:syncVolumeDown', currentDJ.name)
    if currentDJ.volume <= 0.0 then
        ShowNotification('~g~Minimum volume reached!')
    end
end)

RegisterNetEvent('myDj:clientVolumeUp')
AddEventHandler('myDj:clientVolumeUp', function(DJName)
    volumeUp(DJName)
end)

RegisterNUICallback('up', function(data, cb)
    -- lauter machen
    TriggerServerEvent('myDj:syncVolumeUp', currentDJ.name)
    if currentDJ.volume >= 1.0 then
        ShowNotification('~g~Maximum volume reached!')
    end
end)

RegisterNUICallback('addPlayList', function(data, cb)
    -- Playlist hinzufügen
    -- label = data.name
    TriggerServerEvent('myDJ:addPlaylist', data.name)
end)

RegisterNUICallback('addSongToPlaylist', function(data, cb)
    -- link = data.link
    -- Playlist ID = data.id
    -- Ich würde das jetzt zum Server senden dort in die DB inserten und dann wieder auslesen und zurück zum Client schicken und dann wieder an das UI schicken
    --print('add song: ' .. data.id .. ' : ' .. data.link)
    TriggerServerEvent('myDJ:addSongToPlaylist', data.id, tostring(data.link))
    --TriggerServerEvent('myDJ:addSongToPlaylist', 1, 'data.link')

    Wait(100)
    ESX.TriggerServerCallback('myDJ:requestPlaylistsAndSongs', function(playlists, songs)
        SendNUIMessage({type = 'getPlaylists', playlists = playlists, songs = songs})
    end)
end)

RegisterNUICallback('deleteSong', function(data, cb)
    -- Song ID = data.id
    -- Playlist ID = data.playlistId
    --print('remove: ' .. data.id)
	TriggerServerEvent('myDJ:removeSongFromPlaylist', data.id)
end)

RegisterNUICallback('deletePlaylist', function(data, cb)
    -- Song ID = data.id
    -- Playlist ID = data.playlistId
    --print('remove playlist: ' .. data.id)
	TriggerServerEvent('myDJ:removePlaylist', data.id)
end)



RegisterNUICallback('noSongtitle', function(data, cb)
    -- gibt keinen Song title oder kann nicht abgerufen werden
	ShowNotification(Translation[Config.Locale]['title_does_not_exist'])
end)


function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showInfobar(msg)

	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end




















-- xSound = exports.xsound
-- Citizen.CreateThread(function()
--     local pos = GetEntityCoords(PlayerPedId())
--     xSound:PlayUrlPos("name","https://www.youtube.com/watch?v=6Dh-RL__uN4",1 , pos)
--     --some links will not work cause to copyright or author did not allow to play video from an iframe.
--     print('start playing')
--     --SetEntityCoords(PlayerPedId(), -1592.275, -3012.131, -78.0)
--     xSound:Distance("name",100)
    
--     Citizen.Wait(1000*30)
--     xSound:Destroy("name")
-- end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(500)
--     SetNuiFocus(true, true)

--     local pos = GetEntityCoords(PlayerPedId())
      
-- end)   

-- xSound = exports.xsound
-- function startPlaylist(playlistSongs, startIndex)
    
--     local pos = GetEntityCoords(PlayerPedId())
    

--     local options =
--     {
--         onPlayStart = function(event) -- event argument returns getInfo(id)
--             print("oh yeah! PARTY!")
--         end,
--         onPlayEnd = function(event) 
--             print("oh... already end ? :( Song name ? pls")
--             print(event.url)
--         end,
--     }

--     xSound:PlayUrlPos("name", playlistSongs[i].link, 1, pos, false, options)

--     for i=startIndex, #playlistSongs, 1 do
--         print('Started song: ' .. playlistSongs[i].label)

--     end

-- end

function IsNearAnyDJ()
    local is = false
    local coord = GetEntityCoords(PlayerPedId())
    for k, v in pairs(Config.DJPositions) do
        if #(coord - v.pos) < 5.0 then
            is = k
            break
        end
    end
    return is
end

RegisterCommand("managedj", function()
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 10 then
            ESX.UI.Menu.CloseAll()
            local element = {
                {label = "Create DJ", value = "jobdj"},
                {label = "Remove Current DJ", value = "removedj"},
                {label = "Manage DJ", value = "getdj"},
            }
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dj',
            {
                title    = "Manage DJ",
                align    = 'center',
                elements = element
            }, function(data, menu)
                local datas = data.current.value
                if datas == "jobdj" then
                    menu.close()
                    local input = lib.inputDialog(data.current.label, {'Esm DJ'})
                    if not input then return end
                    menu.close()
                    table.insert(Config.DJPositions, {
                        name = input[1],
                        pos = GetEntityCoords(PlayerPedId()),
                        requiredJob = nil, 
                        range = 22.0, 
                        volume = 1.0,
                        access = {}
                    })
                    TriggerServerEvent("myDJUpdate", Config.DJPositions)
                end
                if datas == "removedj" then
                    local c = IsNearAnyDJ()
                    if not c then return ESX.Alert("Shoma Nazdik Hich DJ Nistid", "error") end
                    menu.close()
                    Config.DJPositions[c] = nil
                    TriggerServerEvent("myDJUpdate", Config.DJPositions)
                end
                if datas == "getdj" then
                    if #Config.DJPositions == 0 then return ESX.Alert("Hich DJ Sakhte Nashode", "error") end
                    ESX.UI.Menu.CloseAll()
                    local elem = {}
                    for k, v in pairs(Config.DJPositions) do
                        print(v.name)
                        table.insert(elem, {label = "Manage DJ: "..v.name, value = k})
                    end
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mdj',
                    {
                        title    = "Manage DJ",
                        align    = 'center',
                        elements = elem
                    }, function(data2, menu2)
                        local dataq = data2.current.value
                        ESX.UI.Menu.CloseAll()
                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'msdj',
                        {
                            title    = "Manage DJ",
                            align    = 'center',
                            elements = {
                                {label = "Add SteamHex", value = "add"},
                                {label = "Remove SteamHex", value = "remove"},
                                {label = "Change Range", value = "range"},
                            }
                        }, function(data3, menu3)
                            local datax = data3.current.value
                            if datax == "add" then
                                local input = lib.inputDialog(data.current.label, {'Enter Hex'})
                                if not input then return end
                                Config.DJPositions[dataq].access[input[1]] = true
                                TriggerServerEvent("myDJUpdate", Config.DJPositions)
                                ESX.UI.Menu.CloseAll()
                            end
                            if datax == "range" then
                                local input = lib.inputDialog(data.current.label, {'Enter Range'})
                                if not input then return end
                                if not tonumber(input[1]) then return end
                                Config.DJPositions[dataq].range = input[1] + 0.0
                                TriggerServerEvent("myDJUpdate", Config.DJPositions)
                                ESX.UI.Menu.CloseAll()
                            end
                            if datax == "remove" then
                                local el = {}
                                for k, v in pairs(Config.DJPositions[dataq].access) do
                                    table.insert(el, {label = k, value = k})
                                end
                                ESX.UI.Menu.CloseAll()
                                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'msssdj',
                                {
                                    title    = "Manage DJ",
                                    align    = 'center',
                                    elements = el
                                }, function(data4, menu4)
                                    local datag = data4.current.value
                                    Config.DJPositions[dataq].access[datag] = nil
                                    TriggerServerEvent("myDJUpdate", Config.DJPositions)
                                    ESX.UI.Menu.CloseAll()
                                end, function(data4, menu4)
                                    menu4.close()
                                end)
                            end
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                end
            end, function(data, menu)
                menu.close()
            end)
        end
    end)
end)

RegisterNetEvent("updateDJConfig")
AddEventHandler("updateDJConfig", function(code)
    Config.DJPositions = code
    if not Config.DJPositions then
        Config.DJPositions = {}
    end
    for k, v in pairs(Config.DJPositions) do
        v.pos = vector3(v.pos.x, v.pos.y, v.pos.z)
    end
end)