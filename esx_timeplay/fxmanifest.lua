lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield
shared_script "@sr_main/shared/interference.lua"
fx_version 'bodacious'
game 'gta5'

client_scripts {
	'config.lua',
	'client/main.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	-- '@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server_config.lua',
	'server/main.lua',
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/font/*.ttf',
	'html/font/*.otf',
	'html/css/*.css',
	'html/images/*.jpg',
	'html/images/*.png',
	'html/js/*.js',
}