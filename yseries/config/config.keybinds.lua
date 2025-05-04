Config          = Config or {}
Config.KeyBinds = {
    -- If you previously was using `F1`*default key* to open the phone it will be cached.
    -- After changing the keybind you need to clear your cache to apply the new keybind
    --  or change the keybind manually through GTA's keybind settings.
    -- Any new player that joins the server will have the new keybind applied.
    Open = {
        Bind = "F1",
        Description = "Open your phone"
    },
    FlipOrFoldPhone = {
        Bind = "SLASH", -- RIGHT / - https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        Description = "Toggle flip/fold(close/open) phone"
    },
    Focus = {
        Bind = 'LMENU',                 -- Left alt - https://docs.fivem.net/docs/game-references/controls/#controls -- use control index
        DisplayValue = "Left ALT", -- Used in the phone app info popup
        Description = "Toggle cursor focus"
    },
    AnswerCall = {
        Bind = "RETURN", -- Enter - https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        Description = "Answer call"
    },
    CancelCall = {
        Bind = "BACK", -- Backspace - https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        Description = "Cancel call"
    },

    TakePhoto = {
        Bind = "RETURN",        -- Enter - https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        DisplayValue = "Enter", -- Used in the camera app info popup
        Description = "Take a photo"
    },
    RotateCamera = {
        Bind = "UP",               -- ArrowUp - https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        DisplayValue = "Arrow Up", -- Used in the camera app info popup
        Description = "Rotate camera"
    },
    MoveCamera = {
        -- This is not used as a keybind after version 0.99.0.
        -- Use the `Focus` keybind above to toggle camera focus instead.
        Bind = "",
        DisplayValue = "Left Alt",          -- Used in the camera app info popup
        Description = "Toggle camera focus" -- Used in the camera app info popup
    },
    CloseCamera = {
        Bind = "BACK",              -- Backspace - https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        DisplayValue = "Backspace", -- Used in the camera app info popup
        Description = "Close camera"
    },

    UnlockPhone = { -- https://www.toptal.com/developers/keycode -- get `event.code`
        Bind = "Space",
        Description = "Unlock phone",
    }
}
