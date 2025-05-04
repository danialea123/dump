lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'

game 'gta5'

ui_page 'html/ui.html'

files {
	'html/*.*',
	'html/icons/*.png'
}

shared_script 'config.lua'

client_scripts {
	'client/client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua'
}