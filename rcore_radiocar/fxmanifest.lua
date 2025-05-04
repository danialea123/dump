lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'gta5' }

version "1.9.13"

client_scripts {
    "config.lua",
    "shared.lua",
    "locales/*.lua",
    "utils/locales_backup.lua",
    "utils/VIP.lua",
    "utils/client.lua",
    "client/*.lua",
    "client/exports/*.lua",
    "client/effects/*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "shared.lua",
    "locales/*.lua",
    "utils/locales_backup.lua",
    "server_config.lua",
    "utils/mysql.lua",
    "utils/server.lua",
    "server/*.lua",
}

shared_scripts {
    "shared/*.lua",
}

ui_page "html/index.html"

files {
	"html/*.html",
	"html/scripts/*.js",
	"html/css/*.css",
    "html/css/second/*.css",
	"html/css/img/*.png",
}

dependencies {
    '/server:4752',
    '/onesync',
}



escrow_ignore {
    "config.lua",
    "locales/*.lua",
	"server_config.lua",	
    "utils/*.lua",
    "client/exports/*.lua",
    "client/effects/*.lua",
    "client/commands.lua",
    "client/events.lua",
    "client/main.lua",
    "client/notif.lua",
    "shared.lua",

    "server/timers.lua",
    "server/savingQue.lua",
}
dependency '/assetpacks'