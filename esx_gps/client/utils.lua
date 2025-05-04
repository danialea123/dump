local currentResourceName = GetCurrentResourceName()
local debugIsEnabled = false

--- A simple wrapper around SendNUIMessage that you can use to
--- dispatch actions to the React frame.
---
---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
end

--- A simple debug print function that is dependent on a convar
--- will output a nice prettfied message if debugMode is on
function debugPrint(...)
  if not Config.DebugPrint then return end
  local args = { ... }

  local appendStr = ""
  for _, v in ipairs(args) do
    appendStr = appendStr .. " " .. tostring(v)
  end
  local msgTemplate = "^3[%s]^0%s"
  local finalMsg = msgTemplate:format(currentResourceName, appendStr)
  print(finalMsg)
end

--- Prints the contents of a table with optional indentation.
---
--- @param tbl (table) The table to be printed.
--- @param indent (number, optional) The level of indentation for formatting.
function printTable(tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      printTable(v, indent + 1)
    elseif type(v) == "boolean" then
      print(formatting .. tostring(v))
    else
      print(formatting .. v)
    end
  end
end

---@param dict string
function loadAnimDict(dict)
  if not HasAnimDictLoaded(dict) then
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
      Wait(0)
    end
  end
end

---@param ped number
---@return string dict
function getGpsPanelDict(ped)
  return IsPedInAnyVehicle(ped, false) and "cellphone@in_car@ds" or "cellphone@"
end

---@param model number | string
function loadModel(model)
  if HasModelLoaded(model) then
    return
  end
  RequestModel(model)
  while not HasModelLoaded(model) do
    Wait(0)
  end
end

--- Checks if a player has a "item" in their inventory.
---
---@param item string
---@return boolean boolean Returns true if the player has item false otherwise.
function DoesPlayerHaveItem(itemName)
  return ESX.DoesHaveItem2(itemName, 1)
end

---@param type string inform / success / error
---@param text string Notification text
---@param duration? number (optional) Duration in miliseconds, custom notify.
---@param icon? string (optional) icon name, custom notify.
function notify(text, type, duration, icon)
  ESX.Alert(text, "info")
end

---Retrieves the category of a vehicle based on its class.
---
---@param class - The class of the vehicle for which the category is to be determined.
---@return table table The category of the provided vehicle class, if available in the VehicleCategory table. Returns nil if the class is not found.
function GetVehicleCategory(class)
  return VehicleCategory[class]
end
