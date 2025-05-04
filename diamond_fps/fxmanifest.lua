lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'

game 'gta5'

ui_page 'html/index.html'

client_scripts {
	'shared/config.lua',
	'client.lua',
	'shared/client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'shared/config.lua',
	'server.lua',
	'shared/server.lua',
}

files {
	'html/index.html',
	'html/css/*.css',
	'html/js/*.js',
	'html/imgs/*.png',
}


escrow_ignore {
	'shared/*.lua'
}

this_is_a_map 'yes'