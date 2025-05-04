lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

client_script 'client.lua'
client_script 'config.lua'


client_script "@sr_main/client/def.lua"

server_scripts { 
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
	'config.lua'
}

ui_page "html/ui.html"

files {
	'html/ui.html',
	'html/ui.js',
	'html/countdown.js',
	'html/script.js',
	'html/css/main.css',
	'html/imgs/*',
}



