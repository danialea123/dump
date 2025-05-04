
local _wheel = nil
local _lambo = nil
local _isShowCar = false
local _wheelPos = vector3(1109.76, 227.89, -49.64)
local _baseWheelPos = vector3(1111.05, 229.81, -53.38)
local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}
local _isRolling = false

Citizen.CreateThread(function()
        local model = GetHashKey('vw_prop_vw_luckywheel_02a')
        local baseWheelModel = GetHashKey('vw_prop_vw_luckywheel_01a')

        Citizen.CreateThread(function()
            -- Base wheel
            RequestModel(baseWheelModel)
            while not HasModelLoaded(baseWheelModel) do
                Citizen.Wait(0)
            end

            _basewheel = CreateObject(baseWheelModel, _baseWheelPos.x, _baseWheelPos.y, _baseWheelPos.z, false, false, true)
            SetEntityHeading(_basewheel, 0.0)
            SetModelAsNoLongerNeeded(baseWheelModel)

            -- Wheel
            RequestModel(model)

            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
			_wheel = CreateObject(model, 1111.05, 229.81, -50.38, false, false, true)
            SetEntityHeading(_wheel, 0.0)
            SetModelAsNoLongerNeeded(model)
        end)
end)

RegisterNetEvent("casino_luckywheel:doRoll")
AddEventHandler("casino_luckywheel:doRoll", function(_priceIndex) 
    _isRolling = true
    SetEntityHeading(_wheel, -30.0)
    SetEntityRotation(_wheel, 0.0, 0.0, 0.0, 1, true)
    Citizen.CreateThread(function()
        local speedIntCnt = 1
        local rollspeed = 1.0
        local _priceIndex = math.random(1, 20)
        local _winAngle = (_priceIndex - 1) * 18
        local _rollAngle = _winAngle + (360 * 8)
        local _midLength = (_rollAngle / 2)
        local intCnt = 0
        while speedIntCnt > 0 do
            local retval = GetEntityRotation(_wheel, 1)
            if _rollAngle > _midLength then
                speedIntCnt = speedIntCnt + 1
            else
                speedIntCnt = speedIntCnt - 1
                if speedIntCnt < 0 then
                    speedIntCnt = 0
                    
                end
            end
            intCnt = intCnt + 1
            rollspeed = speedIntCnt / 10
            local _y = retval.y - rollspeed
            _rollAngle = _rollAngle - rollspeed
            SetEntityRotation(_wheel, 0.0, _y, 0.0, 1, true)
            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent("casino_luckywheel:rollFinished")
AddEventHandler("casino_luckywheel:rollFinished", function() 
    _isRolling = false
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function doRoll()
    if not _isRolling then
        _isRolling = true
        local playerPed = PlayerPedId()
        loadAnimDict("anim_casino_a@amb@casino@games@lucky7wheel@male")
            local _movePos = vector3(1109.55, 228.88, -49.64)
            TaskGoStraightToCoord(playerPed,  _movePos.x,  _movePos.y,  _movePos.z,  1.0,  -1,  312.2,  0.0)
            local _isMoved = false
            while not _isMoved do
                local coords = GetEntityCoords(PlayerPedId())
                if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
                    _isMoved = true
                end
                Citizen.Wait(0)
            end
            TaskPlayAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            while IsEntityPlayingAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', anim, 3) do
                    Citizen.Wait(0)
                    DisableAllControlActions(0)
            end
            TaskPlayAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
            while IsEntityPlayingAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', 'enter_to_armraisedidle', 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerServerEvent("casino_luckywheel:getLucky")
            TaskPlayAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
    end
end

-- Menu Controls
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        if(GetDistanceBetweenCoords(coords, _wheelPos.x, _wheelPos.y, _wheelPos.z, true) < 1.5) and not _isRolling then
            drawNativeNotification("Press ~INPUT_PICKUP~ To Roll The Wheel")
            if IsControlJustReleased(0, Keys['E']) then
                TriggerEvent("invarte")
				Wait(500)
				PlaySoundFrontend(-1, "Spin_Single_Ticks", "dlc_vw_casino_lucky_wheel_sounds", 1)
            end
        else
            Citizen.Wait(750)
        end		
	end
end)

RegisterNetEvent("invarte")
AddEventHandler("invarte", function()
    doRoll()
end)

function drawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end