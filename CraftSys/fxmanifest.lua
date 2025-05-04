lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield


fx_version 'adamant'

game 'gta5'

ui_page 'html/form.html'


client_script "@sr_main/client/def.lua"

files {
	'html/form.html',
	'html/css.css',
	'html/water.png',
	'html/script.js',
	'html/jquery-3.4.1.min.js',
	'html/img/*.png',
}

client_scripts{
    'config.lua',
    'client/main.lua',
	"drug/client.lua",
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua',
	"drug/server.lua",
}