lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield


fx_version 'adamant'

game 'gta5'

ui_page 'html/form.html'

files {
	'html/form.html',
	'html/img/logo.png',
	'html/img/report.jpg',
	'html/css.css',
	'html/script.js',
	'html/jquery-3.4.1.min.js',
}

client_scripts{
    'config.lua',
    'client/main.lua',
}

server_scripts{
    'config.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
}