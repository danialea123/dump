lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'

game 'gta5'

ui_page 'html/form.html'

files {
	'html/form.html',
	'html/css.css',
	'html/water.png',
	'html/script.js',
	'html/jquery-3.4.1.min.js',
	'html/odometer.js',
	'html/img/*.png',
	'html/img/*.jpg',
}



client_script "@sr_main/client/def.lua"

client_scripts {
    'hookah/config.lua',
    'hookah/client.lua',
}

server_scripts {
    'hookah/config.lua',
    'hookah/server.lua',
}

client_scripts{
    'config.lua',
    'client/main.lua',
	'client/Tasks.lua',
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua',
}