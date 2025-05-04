Config = Config or {}

-- Whether the player will be able to upload files from external sources(links) as media.
Config.AllowExternalUpload = {
    Y = true,
    YBuy = true,
    Messages = true,
    Settings = true, -- Includes changing background.
    Instashots = true
}

-- The maximum alowed video to capture with the phone camera. In seconds. *default - 20
Config.MaxVideoDuration = 25

Config.Upload = {}
-- Your upload method. (Discord, Fivemanage, Fivemerr, Custom).
-- We higly advise you to not use Discord as permanent storage as the url will expire after a while.
-- Fivemanage hash a free tier storage that allows you to upload images, videos and audio files. *docs - https://docs.fivemanage.com/
-- Quick installation guide of Fivemanage - https://youtu.be/GL7HBlA9i4s
-- Custom is a custom upload method that you can use to upload files to your own server. If you're not sure how to use it, use *Fivemanage*.
Config.Upload.Method = { -- Options: (Discord, Fivemanage, Fivemerr, Custom).
    Image = "Fivemerr",
    Video = "Fivemerr",
    Audio = "Fivemerr"
}

Config.Upload.Quality = 0.85 -- The quality of the uploaded image. *default - 0.95. *range - 0.0 - 1.0

-- !!! IMPORTANT !!!
-- !!! IMPORTANT !!!
--------------------
-- Set your API KEYS in `server\apiKeys.lua`
--------------------
-- !!! IMPORTANT !!!
-- !!! IMPORTANT !!!

Config.Upload.Methods = {
    Fivemerr = {
        Image = {
            url = "https://api.fivemerr.com/v1/media/images",
            field = "file",
            successPath = "url"
        },
        Video = {
            url = "https://api.fivemerr.com/v1/media/videos",
            field = "file",
            successPath = "url"
        },
        Audio = {
            url = "https://api.fivemerr.com/v1/media/audios",
            field = "file",
            successPath = "url"
        }
    },
    Fivemanage = {
        Image = {
            url = "AUTO_POPULATED_DO_NOT_TOUCH",
            field = "file",
            successPath = "url"
        },
        Video = {
            url = "AUTO_POPULATED_DO_NOT_TOUCH",
            field = "file",
            successPath = "url"
        },
        Audio = {
            url = "AUTO_POPULATED_DO_NOT_TOUCH",
            field = "file",
            successPath = "url"
        }
    },
    Discord = {
        Image = {
            url = 'https://discord.com/api/webhooks/',
            field = "files[]",
            successPath = "attachments.0.url"
        },
        Video = {
            url = 'https://discord.com/api/webhooks/',
            field = "files[]",
            successPath = "attachments.0.url"
        },
        Audio = {
            url = 'https://discord.com/api/webhooks/',
            field = "files[]",
            successPath = "attachments.0.url"
        }
    },
    Custom = {
        Video = {
            url = "https://upload-url.com/",
            field = "file",
            headers = {
                ["Authorization"] = "API_KEY"
            },
            successPath = "url"
        },
        Image = {
            url = "https://upload-url.com/",
            field = "file",
            headers = {
                ["Authorization"] = "API_KEY"
            },
            successPath = "url"
        },
        Audio = {
            url = "https://upload-url.com/",
            field = "file",
            headers = {
                ["Authorization"] = "API_KEY"
            },
            successPath = "url"
        },
    }
}
