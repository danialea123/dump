---@diagnostic disable: undefined-global, undefined-field, need-check-nil, lowercase-global, redundant-parameter, missing-parameter
local ESX = nil
OpenReports = 0
local ShowReports = true
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	if PlayerData.permission_level >= 2 then
		RunReportsThread()
	end
end)

local result = ""

local function IsMenuOpen()
	return (JayMenu.IsMenuOpened('report') or string.find(tostring(JayMenu.CurrentMenu() or ""), "REPORT_"))
end

local function Display()
	if JayMenu.IsMenuOpened('report') then
		for k, v in ipairs(Config_RPS.ReportCats) do
			JayMenu.MenuButton(v[2], v[1])
		end
		for k, v in ipairs(Config_RPS.NonRPCats) do
			JayMenu.MenuButton(v[2], v[1])
		end
		JayMenu.Display()
	end

	for k, v in ipairs(Config_RPS.ReportCats) do
		if JayMenu.IsMenuOpened(v[1]) then
			if v[1] == "REPORT_NONRP" then
				if not currentSelection then
					for j, p in pairs(Config_RPS.NonRPCats) do
						local clicked, hovered = JayMenu.Button(p[2], ">")
						if clicked then
							currentSelection = p[2]
						end
					end
				else
					local clicked2, hovered2 = JayMenu.Button("Report Reason", "~HUD_COLOUR_RED~"..currentSelection)
					local clicked3, hovered3 = JayMenu.Button("~HUD_COLOUR_GREEN~Send Report")
					if clicked3 then
						TriggerServerEvent('esx_Report:CreateReport', currentSelection)
						JayMenu.CloseMenu()
						TriggerEvent('sr_chat:toggleChat', true)
						Citizen.Wait(1000)
						result = ""
						TriggerEvent('chat:addMessage', {
							template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(3, 207, 216, 0.4); border-radius: 3px; font-weight: bold;"><i class="fas fa-exclamation-triangle"></i> [REPORT SYSTEM]<br>  {0}</div>',
							args = {'گزارش شما ارسال شد تا دریافت پاسخ صبور باشید و اگر در ارپی هستید تحت هر شرایطی به ارپی خود ادامه دهید، در صورت عدم رسیدگی به ریپورت میتوانید مشکل خود را از طریق تیکت در دیسکورد مطرح کنید'}
						})
						ESX.ShowNotification("~g~ریپورت خود را کنسل کنید /cr در نظر داشته باشید که می توانید با")
					end
				end
			else
				local clicked, hovered = JayMenu.Button("Report Reason", "~HUD_COLOUR_RED~"..v[2])
				if v[1] == "REPORT_Question" then
					local clicked, hovered = JayMenu.Button("Type Your Report")
					if clicked then
						DisplayOnscreenKeyboard(1, "", "", result, "", "", "", 128)
						while (UpdateOnscreenKeyboard() == 0) do
							DisableAllControlActions(0);
							Wait(0);
						end
						if (GetOnscreenKeyboardResult()) then
							result = GetOnscreenKeyboardResult()
						end
					end
				end
				local clicked, hovered = JayMenu.Button("~HUD_COLOUR_GREEN~Send Report")
				if clicked and v[1] == "REPORT_Question" then
					if #result < 10 then
						ESX.Alert("Lotfan hadaghal 10 character darbare soal khod benevisid!", "info")
					else
						TriggerServerEvent('esx_Report:CreateReport', v[2], result)
						JayMenu.CloseMenu()
						TriggerEvent('sr_chat:toggleChat', true)
						Citizen.Wait(1000)
						result = ""
						TriggerEvent('chat:addMessage', {
							template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(3, 207, 216, 0.4); border-radius: 3px; font-weight: bold;"><i class="fas fa-exclamation-triangle"></i> [REPORT SYSTEM]<br>  {0}</div>',
							args = {'گزارش شما ارسال شد تا دریافت پاسخ صبور باشید و اگر در ارپی هستید تحت هر شرایطی به ارپی خود ادامه دهید، در صورت عدم رسیدگی به ریپورت میتوانید مشکل خود را از طریق تیکت در دیسکورد مطرح کنید'}
						})
						ESX.ShowNotification("~g~ریپورت خود را کنسل کنید /cr در نظر داشته باشید که می توانید با")
					end
				elseif clicked then
					TriggerServerEvent('esx_Report:CreateReport', v[2])
					JayMenu.CloseMenu()
					TriggerEvent('sr_chat:toggleChat', true)
					Citizen.Wait(1000)
					result = ""
					TriggerEvent('chat:addMessage', {
						template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(3, 207, 216, 0.4); border-radius: 3px; font-weight: bold;"><i class="fas fa-exclamation-triangle"></i> [REPORT SYSTEM]<br>  {0}</div>',
						args = {'گزارش شما ارسال شد تا دریافت پاسخ صبور باشید و اگر در ارپی هستید تحت هر شرایطی به ارپی خود ادامه دهید، در صورت عدم رسیدگی به ریپورت میتوانید مشکل خود را از طریق تیکت در دیسکورد مطرح کنید'}
					})
					ESX.ShowNotification("~g~ریپورت خود را کنسل کنید /cr در نظر داشته باشید که می توانید با")
				end
			end
			JayMenu.Display()
		end
	end
	if IsMenuOpen() then
		SetTimeout(0, Display)
	end
end

local function OpenMenu()
	if not IsMenuOpen() then
		currentSelection = nil
		JayMenu.OpenMenu('report')
		Display()
	end
end

function onEvent(event, ...)
	RegisterNetEvent(event)
	AddEventHandler(event, ...)
end

onEvent('sr_reportsystem:openMenu', OpenMenu)

Citizen.CreateThread(function()
	JayMenu.CreateMenu("report", "Diamond Report Menu", function()
		result = ""
		return true
	end)
	JayMenu.SetTitleColor('report', 255, 113, 0, 255)
	JayMenu.SetSubTitle('report', 'Choose Your Report')
	for k, v in ipairs(Config_RPS.ReportCats) do
		JayMenu.CreateSubMenu(v[1], 'report', v[2])
		JayMenu.SetSubTitle(v[1], v[2])
	end
end)

RegisterKey("BACK", function()
	currentSelection = nil
end)

--man khode khodam

RegisterNetEvent("esx_Report:ManageReports")
AddEventHandler("esx_Report:ManageReports", function(data)
	OpenMenu(data)
end)

RegisterNetEvent("esx_Report:ShowReports")
AddEventHandler("esx_Report:ShowReports", function(data)
	OpenReports = data
end)

RegisterCommand("sr", function()
	ShowReports = not ShowReports
end)

function RunReportsThread()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			if ShowReports then
				Draw('Open Reports : '..OpenReports, 255, 0, 0, 0.01, 0.35)
			end
		end
	end)
end

function Draw(text,r,g,b,x,y)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.50, 0.50)
	SetTextColour( r,g,b, 255 )
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function OpenMenu(info)
	local elem = {}
	for k, v in pairs(info) do
		table.insert(elem, {Time = v.Time, label = " [/ar "..v.ID.."] [Type: "..v.Type.."]", value = v.ID})
	end
	if #elem == 0 then 
		ESX.Alert("~y~Report e Fa`ali Vojud Nadarad", "info")
		return
	end
	table.sort(elem, function(a,b)
		return a.Time < b.Time
	end)
	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'report_show', {
		title = "Report Menu",
		align = 'center',
		elements = elem
	}, function(data, menu)

		GiveInformation(function(infos)
			TriggerEvent('chat:addMessage', { args = { " ^3Matn Report: ^0"..infos } })
			ExecuteCommand("ar "..data.current.value)
			menu.close()
		end, info, data.current.value)
		
    end, function(data, menu)
        menu.close()
    end)
end

function GiveInformation(cb, data, id)
	for k, v in pairs(data) do
		if v.ID == id then
			if v.Detail == nil then
				cb(" ^1In Report Matni Nadarad")
				break
			else
				cb(v.Detail)
				break
			end
		end
	end
end

local acceptedReports = 0
local timer = 0
local warned = false
local offtimer = 0
local number1
local number2
local result
local dutyCommand
local fail = 0
local whitelist = {
	["steam:11000014359e357"] = true,
}

RegisterNetEvent("esx_admin:dutyType")
AddEventHandler("esx_admin:dutyType", function(data)
	if data ~= "admin" and data ~= "admin2" then return end 
	dutyCommand = data 
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if ESX.GetPlayerData().admin == 1 and not whitelist[ESX.GetPlayerData().identifier] then
			if acceptedReports < 1 then
				timer = timer + 5
				if timer >= 900 then
					if not warned then
						warned = true
						offtimer = 120
						number1 = math.random(1, 10)
						number2 = math.random(1, 10)
						result = number1 + number2
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ^2" .. offtimer .. " ^0saniye digar be elaat ^1AFK ^0bodan Off-Duty mishavid, lotfan be soal robero javab dahid ^3/aafk ^2" .. number1 .. "^0+^4" .. number2 .. "^0")
					else
						offtimer = offtimer - 5
						if offtimer <= 0 and warned then
							ExecuteCommand(dutyCommand)
							acceptedReports = 0
							timer = 0
							warned = false
							offtimer = 0
							number1 = nil
							number2 = nil
							result = nil
							fail = 0
						end

						if offtimer == 60 or offtimer == 30 or offtimer == 10 then
							TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ^2" .. offtimer .. " ^0saniye digar be elaat ^1AFK ^0bodan Off-Duty mishavid, lotfan be soal robero javab dahid ^3/aafk ^2" .. number1 .. "^0+^4" .. number2 .. "^0")
						end
					end
				end
			else
				if warned then
					resetAFK()
				else
					acceptedReports = 0
					timer = 0
					warned = false
					offtimer = 0
					number1 = nil
					number2 = nil
					result = nil
					fail = 0
				end
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

local failLimit = 3
RegisterCommand("aafk", function(source, args)
	if warned then
		if not args[1] then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat javab chizi vared nakardid!")
		end

		if not tonumber(args[1]) then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat javab faghat mitavanid adad vared konid!")
		end

		local input = tonumber(args[1])

		if input == result then
			resetAFK()
		else
			fail = fail + 1
			if fail > 3 then
				ExecuteCommand(dutyCommand)
				return
			end
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Javab vared shode eshtebah bod, shoma ^2" .. failLimit - fail .. "^0 bar digar ^3forsat^0 javab darid!")
		end
	else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma hich afk math acitivi nadarid!")
	end
end, false)

function resetAFK()
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma digar be onvan admin ^1AFK ^0hesab ^2nemishavid^0!")
	acceptedReports = 0
	timer = 0
	warned = false
	offtimer = 0
	number1 = nil
	number2 = nil
	result = nil
	fail = 0
end

RegisterNetEvent("esx_admin:reportAccepted")
AddEventHandler("esx_admin:reportAccepted", function()
	acceptedReports = acceptedReports + 1
end)