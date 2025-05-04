local CurrentMenuId = ''
local CurrentMenu = nil
local SavedIndexes = {}
local CancelMenu = {}
local ClickCB = nil
local ClickArgs = nil
local GUITimer = 0

RequestScaleformMovie('MP_MENU_GLARE')
RequestScaleformMovie('INSTRUCTIONAL_BUTTONS')
RequestStreamedTextureDict('commonmenu', true)

function CreateDialog(id, title, subtitles, items, closeCB, image, restoreIndex, instructionalButtons)
	Citizen.CreateThreadNow(function()
        -- If open the same menu id, just refresh the items
		if CurrentMenuId == id and RageUI.Visible(RMenu:Get('rageui', 'sunset_dialog')) then
			CurrentMenu.items = items
			return
		end

		TriggerEvent('KorioZ-PersonalMenu:Close')
		if CurrentMenu then
			DestroyMenu()
		end
		
		local canSelect = true
		if IsControlPressed(0, 201) then
			canSelect = false
		end
		
		GUITimer = GetGameTimer()
		CurrentMenuId = id
		CancelMenu[id] = nil
		ClickCB = nil
		ClickArgs = nil

		image = (image and image ~= '') and image or nil
		CurrentMenu = RageUI.CreateMenu(title, subtitles, nil, nil, image, image)
		RMenu.Add('rageui', 'sunset_dialog', CurrentMenu)

		CurrentMenu.EnableMouse = false
		for _, button in pairs(instructionalButtons or {}) do
			CurrentMenu:AddInstructionButton({GetControlInstructionalButton(0, button.key, 1), button.text})
		end
		CurrentMenu.items = items

		RageUI.Visible(CurrentMenu, true)

		CurrentMenu.onIndexChange = function(Index)
			SavedIndexes[CurrentMenuId] = Index
		end
		
		if not restoreIndex then
			SavedIndexes[CurrentMenuId] = 1
		end

		local canceled = true
		local itemActive = nil
		local lastItemActive = nil
		while canceled and id == CurrentMenuId and RageUI.Visible(CurrentMenu) do
			
			if not canSelect and IsControlReleased(0, 201) then
				canSelect = true
			end

			RageUI.IsVisible(CurrentMenu, function()
				--- Items
				for i, item in pairs(CurrentMenu.items) do
					local selectedActive = nil
					if restoreIndex then
						selectedActive = (i == (SavedIndexes[id] or 1))
					end
                    
                    if item.style then
                        -- RightBadge
                        item.style.RightBadge = RageUI.BadgeStyle[item.style.RightBadge] or item.style.RightBadge
                        -- Checkbox
                        if item.style.Checked ~= nil then
                            if item.style.Checked then
                                item.style.RightBadge = function(Selected) return { BadgeTexture = Selected and "shop_box_tickb" or "shop_box_tick" } end
                            else
                                item.style.RightBadge = function(Selected) return { BadgeTexture = Selected and "shop_box_blankb" or "shop_box_blank" } end
                            end
                        end
                    end
                    
					RageUI.Button(item.label, item.description, item.style or {}, true, {
						onSelected = function()
							if canSelect and (GetGameTimer() - GUITimer) > 150 and id == CurrentMenuId then
								GUITimer = GetGameTimer()
								canSelect = false
								ClickCB = item.callback
								ClickArgs = item.args
								if item.close == nil or item.close then
									canceled = false
								else
									Click()
								end
							end
						end,
						onActive = function()
							itemActive = item
							if not lastItemActive or itemActive ~= lastItemActive then
								lastItemActive = itemActive 
								if item.activecb and id == CurrentMenuId then
									Citizen.CreateThreadNow(function()
										if item.args then
											item.activecb(table.unpack(item.args))
										else
											item.activecb()
										end
									end)
								end
							end
						end
					}, nil, item.noSound or not (canSelect and (GetGameTimer() - GUITimer) > 150 and id == CurrentMenuId), selectedActive)
				end
			end)
			
			Citizen.CreateThreadNow(function()
				local timeout = GetGameTimer() + 250
				while GetGameTimer() < timeout do
					HideHelpTextThisFrame()
					Citizen.Wait(0)
				end
			end)

			if restoreIndex then
				CurrentMenu.Index = SavedIndexes[id] or 1
				restoreIndex = false
			end
			
			if canceled and id == CurrentMenuId then
				Citizen.Wait(0)
			end
		end

		if id ~= CurrentMenuId then
			if CancelMenu[id] ~= nil then
				canceled = CancelMenu[id]
			end
			if closeCB then
				Citizen.CreateThreadNow(function()
					closeCB(canceled)
				end)
			end
			return
		end
		
		DestroyMenu()

		if not canceled then
			Click()
		end

		if CancelMenu[id] ~= nil then
            canceled = CancelMenu[id]
        end

		if closeCB then
			Citizen.CreateThreadNow(function()
				closeCB(canceled)
			end)
		end
	end)
end

function Click()
	if ClickCB then
		Citizen.CreateThreadNow(function()
			if ClickArgs then
				ClickCB(table.unpack(ClickArgs))
			else
				ClickCB()
			end
		end)
	end
end

function DestroyMenu()
	if CurrentMenu then
		RageUI.Visible(CurrentMenu, false)
		RMenu:Delete('rageui', 'sunset_dialog')
		CurrentMenu = nil
		CurrentMenuId = ''
	end
end

function CloseDialog(id, nocancel)
	if CurrentMenuId == id then
		if nocancel then
			CancelMenu[id] = false
		end
		DestroyMenu()
	end
end

function IsDialogOpened(id)
	if id then
		return CurrentMenuId == id
	else
		return CurrentMenuId ~= ''
	end
end

function CloseAll()
	if CurrentMenu then
		CancelMenu[CurrentMenuId] = false
		DestroyMenu()
	end
end

-- Basic confirmation dialog
-- Usage: exports['sunset_dialog']:ConfirmationDialog('Question?', function(result)
-- end)
function ConfirmationDialog(text, cb)
    local dialog = {
		{label = 'Non', callback = function()
			cb(false)
		end},
		{label = 'Oui', callback = function()
			cb(true)
		end}
    }
    CreateDialog('sunset_dialog:confirmation', 'Confirmation', text, dialog, function(canceled) -- TODO
		if canceled then
			cb(false)
		end
    end)
end
