lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

description 'ESX License'

version '1.0.1'

server_scripts {
	'@chat/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

client_scripts {
	'password/client/main.lua',
	"watertank.lua",
}

ui_page 'password/ui/ui.html'

files {
    'password/ui/ui.html',
    'password/ui/numField.css',
	'password/ui/numField.js',
	'password/ui/numField.mp3',
	'password/ui/numField.png',
}
