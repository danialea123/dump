--  ESX Service
local RouletteWords = {
    "@MYTHIC@",
    
}

cachedScaleform = nil
function ScaleformLabel(a)
    BeginTextCommandScaleformString(a)
    EndTextCommandScaleformString()
end
local b = 3
local c
local d = false
local e = false
local f = false


StartComputer = function()
   CreateThread(
        function()
            InitializeBruteForce = function(g)
                local g = RequestScaleformMovieInteractive(g)
                while not HasScaleformMovieLoaded(g) do
                   Wait(0)
                end
                local h = "hack"
                local i = 0
                while HasAdditionalTextLoaded(i) and not HasThisAdditionalTextLoaded(h, i) do
                   Wait(100)
                    i = i + 1
                end
                if not HasThisAdditionalTextLoaded(h, i) then
                    ClearAdditionalText(i, true)
                    RequestAdditionalText(h, i)
                    while not HasThisAdditionalTextLoaded(h, i) do
                       Wait(1000)
                    end
                end
                PushScaleformMovieFunction(g, "SET_LABELS")
                PushScaleformMovieFunctionParameterString("Local Disk (C)")
                PushScaleformMovieFunctionParameterString("Network")
                PushScaleformMovieFunctionParameterString("Phone Device (J)")
                PushScaleformMovieFunctionParameterString("UnLock.exe")
                PushScaleformMovieFunctionParameterString("Virus.exe")
                ScaleformLabel("H_ICON_6")
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_BACKGROUND")
                PushScaleformMovieFunctionParameterInt(5)
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "ADD_PROGRAM")
                PushScaleformMovieFunctionParameterFloat(1.0)
                PushScaleformMovieFunctionParameterFloat(4.0)
                PushScaleformMovieFunctionParameterString("My Computer")
                PopScaleformMovieFunctionVoid()
                --PushScaleformMovieFunction(g, "ADD_PROGRAM")
                --PushScaleformMovieFunctionParameterFloat(6.0)
                --PushScaleformMovieFunctionParameterFloat(6.0)
                --PushScaleformMovieFunctionParameterString("Power Off")
                --PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_LIVES")
                PushScaleformMovieFunctionParameterInt(b)
                PushScaleformMovieFunctionParameterInt(5)
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_LIVES")
                PushScaleformMovieFunctionParameterInt(b)
                PushScaleformMovieFunctionParameterInt(5)
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_COLUMN_SPEED")
                PushScaleformMovieFunctionParameterInt(0)
                PushScaleformMovieFunctionParameterInt(math.random(220, 240))
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_COLUMN_SPEED")
                PushScaleformMovieFunctionParameterInt(1)
                PushScaleformMovieFunctionParameterInt(math.random(220, 240))
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_COLUMN_SPEED")
                PushScaleformMovieFunctionParameterInt(2)
                PushScaleformMovieFunctionParameterInt(math.random(220, 240))
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_COLUMN_SPEED")
                PushScaleformMovieFunctionParameterInt(3)
                PushScaleformMovieFunctionParameterInt(math.random(220, 240))
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_COLUMN_SPEED")
                PushScaleformMovieFunctionParameterInt(4)
                PushScaleformMovieFunctionParameterInt(math.random(220, 240))
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_COLUMN_SPEED")
                PushScaleformMovieFunctionParameterInt(5)
                PushScaleformMovieFunctionParameterInt(math.random(220, 240))
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_COLUMN_SPEED")
                PushScaleformMovieFunctionParameterInt(6)
                PushScaleformMovieFunctionParameterInt(math.random(220, 240))
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(g, "SET_COLUMN_SPEED")
                PushScaleformMovieFunctionParameterInt(7)
                PushScaleformMovieFunctionParameterInt(math.random(220, 240))
                PopScaleformMovieFunctionVoid()
                return g
            end
            cachedScaleform = InitializeBruteForce("HACKING_PC")
            f = true
            while f do
               Wait(0)
                DisableControlAction(0, 1, true)
                DisableControlAction(0, 2, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 257, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 263, true)
                DisableControlAction(0, 31, true)
                DisableControlAction(0, 30, true)
                DisableControlAction(0, 59, true)
                DisableControlAction(0, 71, true)
                DisableControlAction(0, 72, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 264, true)
                DisableControlAction(0, 257, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true)
                DisableControlAction(0, 143, true)
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
                if f then
                    DrawScaleformMovieFullscreen(cachedScaleform, 255, 255, 255, 255, 0)
                    PushScaleformMovieFunction(cachedScaleform, "SET_CURSOR")
                    PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239))
                    PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
                    PopScaleformMovieFunctionVoid()
                    if IsDisabledControlJustPressed(0, 24) and not d then
                        PushScaleformMovieFunction(cachedScaleform, "SET_INPUT_EVENT_SELECT")
                        c = PopScaleformMovieFunction()
                        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                    elseif IsDisabledControlJustPressed(0, 25) and not e and not d then
                        PushScaleformMovieFunction(cachedScaleform, "SET_INPUT_EVENT_BACK")
                        PopScaleformMovieFunctionVoid()
                        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
                    end
                end
            end
        end
    )
end
Citizen.CreateThread(
    function()
        while true do
            local j = 500
            if HasScaleformMovieLoaded(cachedScaleform) and f then
                j = 5
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                if GetScaleformMovieFunctionReturnBool(c) then
                    ProgramID = GetScaleformMovieFunctionReturnInt(c)
                    if ProgramID == 83 and not e then
                        b = Config.MaxLives
                        PushScaleformMovieFunction(cachedScaleform, "SET_LIVES")
                        PushScaleformMovieFunctionParameterInt(b)
                        PushScaleformMovieFunctionParameterInt(5)
                        PopScaleformMovieFunctionVoid()
                        PushScaleformMovieFunction(cachedScaleform, "OPEN_APP")
                        PushScaleformMovieFunctionParameterFloat(1.0)
                        PopScaleformMovieFunctionVoid()
                        PushScaleformMovieFunction(cachedScaleform, "SET_ROULETTE_WORD")
                        PushScaleformMovieFunctionParameterString(RouletteWords[math.random(#RouletteWords)])
                        PopScaleformMovieFunctionVoid()
                        e = true
                    elseif e and ProgramID == 87 then
                        
                        PushScaleformMovieFunction(cachedScaleform, "SET_LIVES")
                        PushScaleformMovieFunctionParameterInt(b)
                        PushScaleformMovieFunctionParameterInt(5)
                        PopScaleformMovieFunctionVoid()
                        PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                    elseif e and ProgramID == 92 then
                        PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
                    elseif e and ProgramID == 86 then
                        d = true
                        PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                        PushScaleformMovieFunction(cachedScaleform, "SET_ROULETTE_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(true)
                        ScaleformLabel("WINBRUTE")
                        PopScaleformMovieFunctionVoid()
                        Wait(5000)
                        PushScaleformMovieFunction(cachedScaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        SetScaleformMovieAsNoLongerNeeded(cachedScaleform)
                        f = false
                        e = false
                        d = false
                        RobberyDevice()
                        ---HACK Complated
                        DisableControlAction(0, 24, false)
                        DisableControlAction(0, 25, false)
                  
                    elseif ProgramID == 6 then
                        f = false
                        SetScaleformMovieAsNoLongerNeeded(cachedScaleform)
                        --HackingCompleted(false)
                        DisableControlAction(0, 24, false)
                        DisableControlAction(0, 25, false)
                    end
                    if e then
                        PushScaleformMovieFunction(cachedScaleform, "SHOW_LIVES")
                        PushScaleformMovieFunctionParameterBool(true)
                        PopScaleformMovieFunctionVoid()
                        if 3 <= 0 then
                            d = true
                            PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                            PushScaleformMovieFunction(cachedScaleform, "SET_ROULETTE_OUTCOME")
                            PushScaleformMovieFunctionParameterBool(false)
                            ScaleformLabel("LOSEBRUTE")
                            PopScaleformMovieFunctionVoid()
                            Wait(5000)
                            PushScaleformMovieFunction(cachedScaleform, "CLOSE_APP")
                            PopScaleformMovieFunctionVoid()
                            SetScaleformMovieAsNoLongerNeeded(cachedScaleform)
                            e = false
                            d = false
                            f = false
                            --HackingCompleted(false)
                         
                            DisableControlAction(0, 24, false)
                            DisableControlAction(0, 25, false)
                        end
                    end
                end
            end
           Wait(j)
        end
    end
)

