local cooldown = 60
local tick = 0
local checkRaceStatus = false
local insideTrackLocation = vector3(1096.55, 260.75, -51.24)

local function OpenInsideTrack()
    if Utils.InsideTrackActive then
        return
    end

    Utils.InsideTrackActive = true

    -- Scaleform
    Utils.Scaleform = RequestScaleformMovie('HORSE_RACING_CONSOLE')

    while not HasScaleformMovieLoaded(Utils.Scaleform) do
        Wait(0)
    end

    DisplayHud(false)
    SetPlayerControl(PlayerId(), false, 0)
    
    if IsNamedRendertargetRegistered('casinoscreen_02') then
        ReleaseNamedRendertarget('casinoscreen_02')
    end

    while not RequestScriptAudioBank('DLC_VINEWOOD/CASINO_GENERAL') do
        Wait(0)
    end

    Utils:ShowMainScreen()
    Utils:SetMainScreenCooldown(cooldown)

    -- Add horses
    Utils.AddHorses(Utils.Scaleform)

    Utils:DrawInsideTrack()
    Utils:HandleControls()
end

local function LeaveInsideTrack()
    Utils.InsideTrackActive = false

    DisplayHud(true)
    SetPlayerControl(PlayerId(), true, 0)
    SetScaleformMovieAsNoLongerNeeded(Utils.Scaleform)

    Utils.Scaleform = -1
end

function Utils:DrawInsideTrack()
    Citizen.CreateThread(function()
        while self.InsideTrackActive do
            Wait(0)

            local xMouse, yMouse = GetDisabledControlNormal(2, 239), GetDisabledControlNormal(2, 240)

            -- Fake cooldown
            tick = (tick + 10)

            if (tick == 1000) then
                if (cooldown == 1) then
                    cooldown = 60
                end
                
                cooldown = (cooldown - 1)
                tick = 0

                self:SetMainScreenCooldown(cooldown)
            end
            
            -- Mouse control
            BeginScaleformMovieMethod(self.Scaleform, 'SET_MOUSE_INPUT')
            ScaleformMovieMethodAddParamFloat(xMouse)
            ScaleformMovieMethodAddParamFloat(yMouse)
            EndScaleformMovieMethod()

            -- Draw
            DrawScaleformMovieFullscreen(self.Scaleform, 255, 255, 255, 255)
        end
    end)
end

function Utils:HandleControls()
    Citizen.CreateThread(function()
        while self.InsideTrackActive do
            Wait(0)

            if IsControlJustPressed(2, 194) then
                LeaveInsideTrack()

                self:HandleBigScreen()
            end

            -- Left click
            if IsControlJustPressed(2, 237) then
                local clickedButton = self:GetMouseClickedButton()

                if self.ChooseHorseVisible then
                    if (clickedButton ~= 12) and (clickedButton ~= -1) then
                        self.CurrentHorse = (clickedButton - 1)
                        self:ShowBetScreen(self.CurrentHorse)
                        self.ChooseHorseVisible = false
                    end
                end

                -- Rules button
                if (clickedButton == 15) then
                    self:ShowRules()
                end

                -- Close buttons
                if (clickedButton == 12) then
                    if self.ChooseHorseVisible then
                        self.ChooseHorseVisible = false
                    end
                    
                    if self.BetVisible then
                        self:ShowHorseSelection()
                        self.BetVisible = false
                        self.CurrentHorse = -1
                    else
                        self:ShowMainScreen()
                    end
                end

                -- Start bet
                if (clickedButton == 1) then
                    self:ShowHorseSelection()
                end

                -- Start race
                if (clickedButton == 10) then
                    if self.CurrentBet <= self.PlayerBalance and self.CurrentBet <= 5 then
                        self.CurrentSoundId = GetSoundId()
                        PlaySoundFrontend(self.CurrentSoundId, 'race_loop', 'dlc_vw_casino_inside_track_betting_single_event_sounds')
                        TriggerServerEvent("insidetrack:server:placebet", self.CurrentBet)
                        self:StartRace()
                        checkRaceStatus = true
                    end
                end

                -- Change bet
                if (clickedButton == 8) then
                    if (self.CurrentBet < self.PlayerBalance) then
                        self.CurrentBet = (self.CurrentBet + 100)
                        self.CurrentGain = (self.CurrentBet * 2)
                        self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                    end
                end

                if (clickedButton == 9) then
                    if (self.CurrentBet > 100) then
                        self.CurrentBet = (self.CurrentBet - 100)
                        self.CurrentGain = (self.CurrentBet * 2)
                        self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                    end
                end

                if (clickedButton == 13) then
                    self:ShowMainScreen()
                end

                -- Check race
                while checkRaceStatus do
                    Wait(0)

                    local raceFinished = self:IsRaceFinished()

                    if (raceFinished) then
                        StopSound(self.CurrentSoundId)
                        ReleaseSoundId(self.CurrentSoundId)

                        self.CurrentSoundId = -1

                        if (self.CurrentHorse == self.CurrentWinner) then
                            TriggerServerEvent("insidetrack:server:winnings", self.CurrentGain)
                            self.PlayerBalance = (self.PlayerBalance + self.CurrentGain)
                        end
						
						--self.PlayerBalance = (self.PlayerBalance + self.CurrentGain)
                        self:UpdateBetValues(self.CurrentHorse, self.CurrentBet, self.PlayerBalance, self.CurrentGain)
                        
						self:ShowResults()

                        self.CurrentHorse = -1
                        self.CurrentWinner = -1
                        self.HorsesPositions = {}

                        checkRaceStatus = false
                    end
                end
            end
        end
    end)
end

local insideMarker = false

Citizen.CreateThread(function()
    while true do
	local sleep = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist = #(insideTrackLocation - coords)

        if dist <= 5.0 then
		    sleep = 4
			DrawMarker(27, insideTrackLocation.x, insideTrackLocation.y, insideTrackLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.00, 1.00, 255, 0, 0, 0, false, true, 2, true, false, false, false)
            if dist <= 100.0 and not Utils.InsideTrackActive then
				drawNativeNotification("Press ~INPUT_PICKUP~ to open and ~INPUT_CELLPHONE_CANCEL~ to close")
                insideMarker = true
				
            end
        else
            insideMarker = false
        end
		Citizen.Wait(sleep)
    end
end)

RegisterCommand("+InsideTrack", function()
        if insideMarker then
			OpenInsideTrack()
        end
end, false)

RegisterCommand("-InsideTrack", function()
end,false)

TriggerEvent("chat:removeSuggestion", "/+InsideTrack")
TriggerEvent("chat:removeSuggestion", "/-InsideTrack")

RegisterKeyMapping("+InsideTrack", "Interact with inside track at the casino", "keyboard" ,"E")

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end