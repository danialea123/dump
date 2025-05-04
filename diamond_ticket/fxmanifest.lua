lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'
description 'Ticket Manager'


client_script 'client/main.lua'

server_script {
    "server/*.lua"
}

shared_script { 
    "@ox_lib/init.lua",
    "shared/config.lua",
}

ui_page {
    'html/index.html',
}

files {
	'html/index.html',
	'html/js/script.js', 
	'html/css/style.css'
}