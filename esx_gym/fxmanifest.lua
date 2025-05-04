lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'



shared_scripts {
	'config/config.lua',
	'config/config.translation.lua',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua',
}

ui_page 'html/index.html'

files {
	'html/*.*',
	'html/**/*.*',
	'config/*.js'
}