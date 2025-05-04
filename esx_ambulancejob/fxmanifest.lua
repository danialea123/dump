lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Ambulance Job'

version '1.2.0'

ui_page 'bodydamage/html/index.html'


client_script "@sr_main/client/def.lua"

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'badge/badge_sv.lua',
	"server/req.lua"
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	'client/job.lua',
	"client/jafari.lua",
	'bodydamage/client/*.lua',
	'badge/badge_cl.lua',
	"client/item.lua",
}

files {
	'bodydamage/html/index.html',
	'bodydamage/html/css/*.css',
	'bodydamage/html/js/*.js',

	'bodydamage/html/img/*.png',

	'bodydamage/html/img/f/*.png',
	'bodydamage/html/img/f/bruises/*.png',
	'bodydamage/html/img/f/cuts/*.png',
	'bodydamage/html/img/f/punchs/*.png',
	'bodydamage/html/img/f/shots/*.png',

	'bodydamage/html/img/m/*.png',
	'bodydamage/html/img/m/bruises/*.png',
	'bodydamage/html/img/m/cuts/*.png',
	'bodydamage/html/img/m/punchs/*.png',
	'bodydamage/html/img/m/shots/*.png',
}

dependencies {
	'essentialmode',
}