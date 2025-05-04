lua54 'yes'
---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Forces'

version '1.2.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'badge/badge_sv.lua',
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	'badge/badge_cl.lua',
}

dependencies {
	'essentialmode',
	'esx_billing'
}

client_scripts {
    'uiz/client/main.lua',
}

shared_script {
	'@ox_lib/init.lua'
}

ui_page "uiz/ui/index.html"

files {
	"uiz/ui/index.html",
	"uiz/ui/assets/css/fonts.css",
	"uiz/ui/assets/css/style.css",
	"uiz/ui/assets/fonts/font-awesome/**.*",
	"uiz/ui/assets/fonts/Proxima/**.*",
	"uiz/ui/assets/images/**.*",
	"uiz/ui/script.js"
}

