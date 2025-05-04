SendNUIMessageReal = SendNUIMessage

local xss_blacklist_patterns = {
    "[\"'%s]onerror%s*=",     
    "[\"'%s]onload%s*=",
    "[\"'%s]src%s*=",
    "[\"'%s]href%s*=",
    "javascript%s*:",
    "<%s*script",            
    "<%s*iframe",            
    "document%p",            
    "window%p",              
    "innerHTML",             
    "eval%s*%(",                             
}

local function containsMaliciousContent(str)
    local lowerStr = string.lower(str or "")
    for _, pattern in ipairs(xss_blacklist_patterns) do
        if lowerStr:match(pattern) then
            print(("^1[Security] Blocked NUI XSS attempt - Matched pattern: '%s'^0"):format(pattern))
            print(("^3[Security] Full JSON data: %s^0"):format(lowerStr))
            return true
        end
    end
    return false
end

SendNUIMessage = function(data)
    if not data then return end

    local success, jsonData = pcall(json.encode, data)
    if not success then
        print("^1[Error] Failed to encode JSON data in SendNUIMessage^0")
        return
    end

    if containsMaliciousContent(jsonData) then
        print("^1[Blocked] Malicious NUI message was prevented from being sent.^0")
        return
    end

    SendNUIMessageReal(data)
end