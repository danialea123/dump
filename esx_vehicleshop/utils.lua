Config.PlateLetters  = 3
Config.PlateNumbers  = 4
Config.PlateUseSpace = true

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate

	repeat
		Wait(2)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))
		end

		if not IsPlateTaken(generatedPlate) then
			break
		end
	until true

	return generatedPlate
end

function GenerateDefaultPlate()
	math.randomseed(GetGameTimer())
	local generatedPlate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))
	return generatedPlate
end

if IsDuplicityVersion() then
	function IsPlateTaken(plate)
		MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
			['@plate'] = plate
		}, function (result)
			return result[1] ~= nil
		end)
	end
else
	function IsPlateTaken(plate)
		ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
			return isPlateTaken
		end, plate)
	end
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end