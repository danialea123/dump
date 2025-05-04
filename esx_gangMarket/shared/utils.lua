function Debug(...)
    if not Config.debugMode then return end

    print("[DEBUG] " .. ...)
end