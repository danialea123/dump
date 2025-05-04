Config = Config or {}

Config.YBuy = Config.YBuy or {}
-- Whether you want to send a notification to all players when a new ad is created.
Config.YBuy.GlobalNotifications = true

Config.Y = {}
-- Whether you want to send a notification to all players when a new post is created.
Config.Y.GlobalNotifications = true

Config.Instashots = {}
-- Whether you want to send a notification to all players when a new post is created.
Config.Instashots.GlobalNotifications = true

-- The default posts that will be shown when you open the app.
-- *foryou - Shows all posts in the server.
-- *following - Shows only the posts of the people you follow.
Config.Instashots.DefaultLoadPreference = 'foryou' -- 'foryou' or 'following'

-- The default stories that will be shown when you open the app.
-- *foryou - Shows all stories in the server.
-- *following - Shows only the stories of the people you follow.
Config.Instashots.DefaultStoryLoadPreference = 'foryou' -- 'foryou' or 'following'

-- Whether you want to allow users to go live.
Config.Instashots.AllowLive = true

Config.YouToo = {}

-- Object that holds the trending(landing) videos that will appear in the home screen of YouToo app.
Config.YouToo.TrendingVideos = {
    {
        title = "Drake ft. Sexyy Red & SZA - Rich Baby Daddy (Official Music Video)",
        videoId = "UcsSdIXHCWM",
        videoThumbnail = "https://vid.puffyan.us/vi/UcsSdIXHCWM/maxres.jpg"
    },
    {
        title = "KAROL G, Tiësto - CONTIGO (Official Video)",
        videoId = "NCmp7AV8O9s",
        videoThumbnail = "https://vid.puffyan.us/vi/NCmp7AV8O9s/maxres.jpg"
    },
    {
        title = "BossMan Dlow - Get In With Me (Official Video)",
        videoId = "KmhAQJqOaIY",
        videoThumbnail = "https://vid.puffyan.us/vi/KmhAQJqOaIY/maxres.jpg"
    },
    {
        title = "GloRilla - Yeah Glo! (Official Music Video)",
        videoId = "voT9hOs6FZc",
        videoThumbnail = "https://vid.puffyan.us/vi/voT9hOs6FZc/maxres.jpg"
    },
    {
        title = "Latto - Sunday Service (Official Video)",
        videoId = "skTA4ZkRlyQ",
        videoThumbnail = "https://vid.puffyan.us/vi/skTA4ZkRlyQ/maxres.jpg"
    },
    {
        title = "Beyoncé - TEXAS HOLD 'EM (Official Lyric Video)",
        videoId = "jCOX8dT9q8M",
        videoThumbnail = "https://vid.puffyan.us/vi/jCOX8dT9q8M/maxres.jpg"
    },
    {
        title = "G Herbo  - Get In Wit Me (Freestyle)  🎥: @DiamondVisuals",
        videoId = "JnlQ-eh6JOQ",
        videoThumbnail = "https://vid.puffyan.us/vi/JnlQ-eh6JOQ/maxres.jpg"
    },
    {
        title = "Miley Cyrus - Flowers (LIVE at the 66th Grammys)",
        videoId = "PSC4TcLJfAg",
        videoThumbnail = "https://vid.puffyan.us/vi/PSC4TcLJfAg/maxres.jpg"
    },
    {
        title = "Chris Brown - Angel Numbers / Ten Toes (Official Video)",
        videoId = "wWR0VD6qgt8",
        videoThumbnail = "https://vid.puffyan.us/vi/wWR0VD6qgt8/maxres.jpg"
    },
    {
        title = "¥$, Ye, Ty Dolla $ign - Talking / Once Again (feat. North West)",
        videoId = "Tqlw87XV4kU",
        videoThumbnail = "https://vid.puffyan.us/vi/Tqlw87XV4kU/maxres.jpg"
    }
}

Config.DarkChat = {}

-- Whether you want to insert every new member to the general chat(DarkChat).
Config.DarkChat.GeneralInsertNewMembers = false

Config.PromoHub = Config.PromoHub or {}

Config.PromoHub.GlobalNotifications = true

Config.PromoHub.Tags = {
    {
        label = 'Vehicle',
        color = '#ffea2f',
    },
    {
        label = 'Service',
        color = '#ffbd2f',
    },
    {
        label = 'Rent',
        color = '#30ad4b',
    },
    {
        label = 'Sale',
        color = '#52ff2f',
    },
    {
        label = 'Job',
        color = '#ff7b2f',
    },
    {
        label = 'House',
        color = '#dc2fff',
    },
    {
        label = 'Electronics',
        color = '#ff2f2f',
    },
    {
        label = 'Promo',
        color = '#10b180',
    },
    {
        label = 'Deal',
        color = '#2fc4ff',
    },
    {
        label = 'Other',
        color = '#4e1966',
    },
}

