function PlayUrl(name_, url_, volume_, loop_, options)
    if not IsMusicWhitelisted(url_) then
        return
    end

    if Config.MXSurround then
        local response = exports[Config.xSoundName]:Prepare(url_)
        if not response.success then
            print("Error: " .. response.error, "Code:", response.errorCode)
            return
        end

        if options then
            if options.onPlayStart then
                exports[Config.xSoundName]:onPlayStart(name_, options.onPlayStart)
            end

            if options.onPlayEnd then
                exports[Config.xSoundName]:onPlayEnd(name_, options.onPlayEnd)
            end

            if options.onLoading then
                exports[Config.xSoundName]:onLoading(name_, options.onLoading)
            end

            if options.onPlayPause then
                exports[Config.xSoundName]:onPlayPause(name_, options.onPlayPause)
            end

            if options.onPlayResume then
                exports[Config.xSoundName]:onPlayResume(name_, options.onPlayResume)
            end
        end

        exports[Config.xSoundName]:Play(name_, url_, nil, loop_, volume_)
        return
    end

    if Config.UseHighSound then
        name_ = ConvertIdentifierToNumber(name_)
    end
    if Config.UseExternalxSound then
        exports[Config.xSoundName]:PlayUrl(name_, url_, volume_, loop_, options)
        return
    end
    if disableMusic then
        return
    end
    SendNUIMessage({
        type = "url",
        name = name_,
        url = url_,
        x = 0,
        y = 0,
        z = 0,
        dynamic = false,
        volume = volume_,
        loop = loop_ or false,
    })

    if soundInfo[name_] == nil then
        soundInfo[name_] = getDefaultInfo()
    end

    soundInfo[name_].volume = volume_
    soundInfo[name_].url = url_
    soundInfo[name_].id = name_
    soundInfo[name_].playing = false
    soundInfo[name_].loop = loop_ or false
    soundInfo[name_].isDynamic = false

    globalOptionsCache[name_] = options or {}
end

function PlayUrlPos(name_, url_, volume_, pos, loop_, options)
    if not IsMusicWhitelisted(url_) then
        return
    end

    if Config.MXSurround then
        local response = exports[Config.xSoundName]:Prepare(url_)
        if not response.success then
            print("Error: " .. response.error, "Code:", response.errorCode)
            return
        end

        local netEntity = ConvertIdentifierToNumber(name_)

        if options then
            if options.onPlayStart then
                exports[Config.xSoundName]:onPlayStart(name_, options.onPlayStart)
            end

            if options.onPlayEnd then
                exports[Config.xSoundName]:onPlayEnd(name_, options.onPlayEnd)
            end

            if options.onLoading then
                exports[Config.xSoundName]:onLoading(name_, options.onLoading)
            end

            if options.onPlayPause then
                exports[Config.xSoundName]:onPlayPause(name_, options.onPlayPause)
            end

            if options.onPlayResume then
                exports[Config.xSoundName]:onPlayResume(name_, options.onPlayResume)
            end
        end

        exports[Config.xSoundName]:Play(name_, url_, pos, loop_, volume_)
        exports[Config.xSoundName]:attachEntity(name_, netEntity)
        return
    end

    if Config.UseHighSound then
        local netEntity = ConvertIdentifierToNumber(name_)

        if soundExists(name_) then
            Destroy(name_)
        end

        exports[Config.xSoundName]:Play3DEntity(
                netEntity,
                Config.DistancePlayingWindowsOpen,
                url_,
                volume_,
                false
        )
        return
    end
    if Config.UseExternalxSound then
        exports[Config.xSoundName]:PlayUrlPos(name_, url_, volume_, pos, loop_, options)
        return
    end
    if disableMusic then
        return
    end

    if soundInfo[name_] == nil then
        soundInfo[name_] = getDefaultInfo()
    end

    if #(pos - GetEntityCoords(PlayerPedId())) < ((soundInfo[name_].distance or 10) + Config.distanceBeforeUpdatingPos) then
        SendNUIMessage({
            type = "url",
            name = name_,
            url = url_,
            x = pos.x,
            y = pos.y,
            z = pos.z,
            dynamic = true,
            volume = volume_,
            loop = loop_ or false,
        })
    end

    soundInfo[name_].volume = volume_
    soundInfo[name_].url = url_
    soundInfo[name_].position = pos
    soundInfo[name_].id = name_
    soundInfo[name_].playing = false
    soundInfo[name_].loop = loop_ or false
    soundInfo[name_].isDynamic = true

    globalOptionsCache[name_] = options or {}

    local playerPos = GetEntityCoords(PlayerPedId())
    if #(pos - playerPos) < Config.distanceBeforeUpdatingPos then
        isPlayerCloseToMusic = true
    end

    UpdatePlayerPositionInNUI()
end