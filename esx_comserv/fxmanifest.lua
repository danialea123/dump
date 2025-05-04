lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'Community Service'

version '2.5.0'


shared_script '@ox_lib/init.lua'

client_script "@sr_main/client/def.lua"

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	"vending/server.lua",
}

client_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	"vending/client.lua",
}

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_foodpack_cookies.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_drinkpack_can.ytyp'

dependency 'essentialmode'

server_scripts {
    'news/server/main.lua', 
}
client_scripts {
    'news/client/main.lua',

}
ui_page {
	'news/web/ui.html'
}
files {
	'news/web/css/style.css',
    'news/web/ui.html',
    'news/web/js/script.js',
	'news/web/img/*.png',
}