lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

game 'gta5'

description 'ESX Sit'

version '1.0.3'

server_scripts {
	'config.lua',
	'lists/seat.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'lists/seat.lua',
	'client.lua'
}

client_scripts {
    "Arena/client/system/*.lua",
    "Arena/client/exports/*.lua",
    "Arena/client/*.lua",
}

server_script {
    "Arena/server/main.lua",
    "Arena/server/default_events.lua",
    "Arena/server/exports/*.lua",
    "Arena/server/module/*.lua",
    "Arena/server/system/*.lua",
}

shared_scripts {
    "Arena/config.lua",
}

files {
    "Arena/html/*.html",
    "Arena/html/css/*.css",
    "Arena/html/scripts/*.js",
}

ui_page "Arena/html/index.html"