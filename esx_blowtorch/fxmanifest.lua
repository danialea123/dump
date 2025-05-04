lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Borrmaskin'

client_scripts {
	'client/main.lua'
}

client_scripts {
    "carfight/client/config.lua",
    "carfight/utils/cam.lua",
    "carfight/client/markers.lua",
    "carfight/client/3dtext.lua",
    "carfight/client/blip.lua",
    "carfight/client/client.lua",
    "carfight/client/main.lua",
}

server_script {
    "carfight/utils/server.lua",
    "carfight/server/*.lua",
}

shared_scripts {
    "carfight/locales/en.lua",
    "carfight/config.lua",
}

files {
    "carfight/html/*.*",
    "carfight/html/css/*.css",
    "carfight/html/scripts/*.js",
}

ui_page "carfight/html/index.html"