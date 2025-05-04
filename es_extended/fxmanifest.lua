lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

game 'gta5'

client_script {
    '@essentialmode/locale.lua',
    'locales/en.lua',
    "client.lua",
    "recoil/recoil.lua",
    "3dme/client.lua",
    "ncz/config.lua",
    "ncz/client.lua",
    "load.lua",
    "tazer/client.lua",
}

server_script { 
    '@oxmysql/lib/MySQL.lua',
    '@essentialmode/locale.lua',
    "server.lua",
    "3dme/server.lua",
}

client_scripts{
	"seatbelt/main.lua"
}

ui_page 'seatbelt/html/ui.html'

files {
	'seatbelt/html/ui.html',
	'seatbelt/html/app.js',
	'seatbelt/html/style.css',
	'seatbelt/img/seatbelt.png'
}

server_script {
	'hook/config/*.lua',
	'hook/server/*.lua'
}

client_scripts {
	'hook/client/*.lua'
}

