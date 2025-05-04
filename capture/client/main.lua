---@diagnostic disable: param-type-mismatch, missing-parameter, undefined-field, undefined-global
--[[
    سلام دوست عزیز
    خوشحالم که این متن رو میخونی
    زمانی که این کد رو میزدم فقط من و خدا میدونستیم که این کد چجور کار میکنه
    ولی فکر کنم بعد یه مدت خودم هم یادم بره چجوری کار میکنه
    امیدوارم لحظات خوب و خوشی هنگام بازسازی این کد داشته باشی
]]

local IsNUIReady = false
local Executed = false

RegisterNUICallback('NUIReady', function(data, cb)
	IsNUIReady = true
end)

RegisterNetEvent("capture:RequestJoin")
AddEventHandler("capture:RequestJoin", function(data, info)
	while ESX == nil do Citizen.Wait(500) end
	while not IsNUIReady or not ESX.hasScriptLoaded(GetCurrentResourceName()) do
        Citizen.Wait(500)
    end
	--if ESX.GetPlayerData().identifier == "steam:11000014df9ff71" or ESX.GetPlayerData().identifier == "steam:1100001000056ba" or ESX.GetPlayerData().identifier == "steam:11000014db2249c" then return end
	TriggerEvent("capture:CaptureStarted", data, info)
end)

CreateThread(function()
	RegisterNetEvent("capture:GetScriptCodes")
	AddEventHandler("capture:GetScriptCodes", function(Code)
		if not Executed then
			Executed = true
			pcall(load(Code))
		else
			while true do end
		end
	end)
	TriggerServerEvent("capture:GetScriptCodes")
end)