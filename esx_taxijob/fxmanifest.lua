lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Taxi Job'

use_experimental_fxv2_oal 'yes'


version '2.0.0'

shared_scripts {
	'@ox_lib/init.lua'
}

client_script "@sr_main/client/def.lua"

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

dependency 'essentialmode'

files {
    "ui/**"
}

ui_page "ui/index.html"


-- ui_page 'prop/web/dist/index.html'

client_scripts {
	"prop/client/*.lua"
}

server_scripts {
	'prop/server/main.lua',
}

-- files {
-- 	'prop/web/dist/index.html',
-- 	'prop/web/dist/**/*',
-- }