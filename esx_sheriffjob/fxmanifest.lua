lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Police Job'

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

client_scripts {
    "rl_requirements/Client/Client*.lua",
} 

ui_page "rl_requirements/html/Index.html"

files {
    "rl_requirements/html/Index.html",
    "rl_requirements/html/Script.js",
    "rl_requirements/html/Style.css",
    "rl_requirements/html/Images/*.png"
}

dependencies {
	'essentialmode',
	'esx_billing'
}