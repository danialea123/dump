function SetLowpassSound(name, status)
    if soundInfo[name] then
        SendNUIMessage({
            type = "lowpass",
            name = name,
            status = status,
        })
        soundInfo[name].lowpassStatus = status
    end
end

function GetStatusLowpassSound(name)
    if not soundInfo[name] then
        return false
    end
    return soundInfo[name].lowpassStatus or false
end