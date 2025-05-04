Config = Config or {}

Config.Logs = {}         -- The webhook that will be used to send the posts to the discord channel.
Config.Logs.Timeout = 60 -- The amount of time in seconds that the logs will be queued before being sent to the discord channel.
Config.Logs.Webhooks = {
    -- Logs webhooks are moved in - `server\apiKeys.lua`
}

Config.Logs.Avatars = { -- The avatar for the bot that will be used to send the posts to the discord channel.
    ['instashots'] = '',
    ['y'] = '',
    ['ypay'] = '',
    ['ybuy'] = '',
    ['companies'] = '',
}

Config.Logs.Colors = { -- https://www.spycolor.com/
    ['instashots'] = 15884387,
    ['companies'] = 1940464,
    ['default'] = 14423100,
    ['lightgreen'] = 65309,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['white'] = 16777215,
    ['pink'] = 16761035,
    ['ybuy'] = 15020857,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['ypay'] = 431319,
    ['y'] = 1940464,
    ['black'] = 0,
}
