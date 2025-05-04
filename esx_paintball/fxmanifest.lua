lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'rdr3', 'gta5' }

this_is_a_map 'yes'
server_script '@oxmysql/lib/MySQL.lua'
server_scripts {
	'server/main.lua'
}


client_scripts {
	'client/main.lua'
}
ui_page {
	'html/index.html'
}

files {
	'html/index.html',
	'html/assets/css/*',
	'html/assets/js/script.js',
	'html/assets/js/core/*',
	'html/assets/imgs/*.jpg',
	'html/assets/fonts/*',
	'html/assets/weapons/*.png',
}