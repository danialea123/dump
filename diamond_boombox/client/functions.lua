---@diagnostic disable: lowercase-global, missing-parameter, undefined-global
loadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

leftNotify = function(msg, thisFrame, beep, duration)
    AddTextEntry('diamond', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('diamond', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('diamond')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end

end

hasBoomBox = function(radio)
    local equipRadio = true
    ESX.disableKey("x", true)
    CreateThread(function()
        while equipRadio do
            Wait(0)
            leftNotify('Press ~INPUT_PICKUP~ to drop boombox'..'\n'..'Press ~INPUT_VEH_DUCK~ to get back boombox', false, false, 2000)
            if IsControlJustReleased(0, 38) then
                equipRadio = false
				DetachEntity(radio)
				PlaceObjectOnGroundProperly(radio)
                FreezeEntityPosition(radio, true)
                boomboxPlaced(radio)
            elseif IsControlJustReleased(0, 73) then 
                DetachEntity(radio)
                equipRadio = false
                TriggerServerEvent("wasabi_boombox:deleteObj", ObjToNet(radio))
                break
            end
        end
        ESX.disableKey("x", false)
    end)
end

if Framework == "ESX" then
    boomboxPlaced = function(obj)
        local coords = GetEntityCoords(obj)
        local heading = GetEntityHeading(obj)
        local targetPlaced = false
        CreateThread(function()
            while true do
                if DoesEntityExist(obj) and not targetPlaced then
                    exports['diamond_target']:AddBoxZone("boomboxzone", coords, 1, 1, {
                        name="boomboxzone",
                        heading=heading,
                        debugPoly=false,
                        minZ=coords.z-0.9,
                        maxZ=coords.z+0.9
                    }, {
                        options = {
                            {
                                action = function()
                                    TriggerEvent("wasabi_boombox:interact")
                                end,
                                icon = 'fas fa-hand-paper',
                                label = 'Interact',
                            },
                            {
                                action = function()
                                    TriggerEvent("wasabi_boombox:pickup")
                                end,
                                icon = 'fas fa-volume-up',
                                label = 'Pick Up'
                            }
                    
                        },
                        distance = 1.5
                    })                    
                    targetPlaced = true
                elseif not DoesEntityExist(obj) then
                    exports['diamond_target']:RemoveZone('boomboxzone')
                    targetPlaced = false
                    break
                end
                Wait(1000)
            end
        end)
    end
elseif Framework == "qb" then
    boomboxPlaced = function(obj)
        local coords = GetEntityCoords(obj)
        local heading = GetEntityHeading(obj)
        local targetPlaced = false
        CreateThread(function()
            while true do
                if DoesEntityExist(obj) and not targetPlaced then
                    exports['diamond_target']:AddBoxZone("boomboxzone", coords, 1, 1, {
                        name="boomboxzone",
                        heading=heading,
                        debugPoly=false,
                        minZ=coords.z-0.9,
                        maxZ=coords.z+0.9
                    }, {
                        options = {
                            {
                                event = 'wasabi_boombox:interact',
                                icon = 'fas fa-hand-paper',
                                label = 'Interact',
                            },
                            {
                                event = 'wasabi_boombox:pickup',
                                icon = 'fas fa-volume-up',
                                label = 'Pick Up'
                            }

                        },
                        job = 'all',
                        distance = 1.5
                    })
                    targetPlaced = true
                elseif not DoesEntityExist(obj) then
                    exports['diamond_target']:RemoveZone('boomboxzone')
                    targetPlaced = false
                    break
                end
                Wait(1000)
            end
        end)
    end
end

interactBoombox = function(radio, radioCoords)
    if not activeRadios[radio] then
        activeRadios[radio] = {
            pos = radioCoords,
            data = {
                playing = false
            }
        }
    else
        activeRadios[radio].pos = radioCoords
    end
    TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
    if not activeRadios[radio].data.playing then
        lib.registerContext({
            id = 'boomboxFirst',
            title = 'Boombox',
            options = {
                {
                    title = 'Play Music',
                    description = 'Play Music On Speaker',
                    arrow = true,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'play', id = radio}
                },
                {
                    title = 'Saved Songs',
                    description = 'Songs you previously saved',
                    arrow = true,
                    event = 'wasabi_boombox:savedSongs',
                    args = {id = radio}
                }
            }
        })
        lib.showContext('boomboxFirst')
    else
        lib.registerContext({
            id = 'boomboxSecond',
            title = 'Boombox',
            options = {
                {
                    title = 'Change Music',
                    description = 'Change music on speaker',
                    arrow = true,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'play', id = radio}
                },
                {
                    title = 'Saved Songs',
                    description = 'Songs you previously saved',
                    arrow = true,
                    event = 'wasabi_boombox:savedSongs',
                    args = {id = radio}
                },
                {
                    title = 'Stop Music',
                    description = 'Stop music on speaker',
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'stop', id = radio}
                },
                {
                    title = 'Adjust Volume',
                    description = 'Change volume on speaker',
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'volume', id = radio}
                },
                {
                    title = 'Change Distance',
                    description = 'Change distance on speaker',
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'distance', id = radio}
                }
            }
        })
        lib.showContext('boomboxSecond')
    end
end

selectSavedSong = function(data)
    lib.registerContext({
        id = 'selectSavedSong',
        title = 'Manage Song',
        options = {
            {
                title = 'Play Song',
                description = 'Play this song',
                arrow = false,
                event = 'wasabi_boombox:playSavedSong',
                args = data
            },
            {
                title = 'Delete Song',
                description = 'Delete this song',
                arrow = true,
                event = 'wasabi_boombox:deleteSong',
                args = data
            }
        }
    })
    lib.showContext('selectSavedSong')
end

if Framework == "ESX" then
    savedSongsMenu = function(radio)
        ESX.TriggerServerCallback('wasabi_boombox:getSavedSongs', function(cb)
            local radio = radio.id
            local Options = {
                {
                    title = 'Save A Song',
                    description = 'Save a song to play later',
                    arrow = true,
                    event = 'wasabi_boombox:saveSong',
                    args = {id = radio}
                }
            }
            if cb then
                for i=1, #cb do
                    print(radio)
                    table.insert(Options, {
                        title = cb[i].label,
                        description = '',
                        arrow = true,
                        event = 'wasabi_boombox:selectSavedSong',
                        args = {id = radio, link = cb[i].link, label = cb[i].label}
                    })
                end
            end
            lib.registerContext({
                id = 'boomboxSaved',
                title = 'Boombox',
                options = Options
            })
            lib.showContext('boomboxSaved')
        end)
    end
elseif Framework == "qb" then
    savedSongsMenu = function(radio)
        QBCore.Functions.TriggerCallback('wasabi_boombox:getSavedSongs', function(cb)
            local radio = radio.id
            local Options = {
                {
                    title = 'Save A Song',
                    description = 'Save a song to play later',
                    arrow = true,
                    event = 'wasabi_boombox:saveSong',
                    args = {id = radio}
                }
            }
            if cb then
                for i=1, #cb do
                    print(radio)
                    table.insert(Options, {
                        title = cb[i].label,
                        description = '',
                        arrow = true,
                        event = 'wasabi_boombox:selectSavedSong',
                        args = {id = radio, link = cb[i].link, label = cb[i].label}
                    })
                end
            end
            lib.registerContext({
                id = 'boomboxSaved',
                title = 'Boombox',
                options = Options
            })
            lib.showContext('boomboxSaved')
        end)
    end
end
