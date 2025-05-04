lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

description 'ESX Police Job'

version '1.2.0'

client_script "@sr_main/client/def.lua"

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'badge/badge_sv.lua',
	'rack/rack_sv.lua',
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	'badge/badge_cl.lua',
	'rack/rack_cl.lua',
}

dependencies {
	'essentialmode',
	'esx_billing'
}

ui_page "rack/html/index.html"

files {
	'rack/html/index.html',
	'rack/html/script.js',
	'rack/html/images/*.png',
	'rack/html/css/*.css',
}



shared_script 'speedtrap/config.lua'
shared_script '@ox_lib/init.lua'

client_script 'speedtrap/client/main.lua'

server_script 'speedtrap/server/main.lua'

-- server_scripts {
--     'zone/config.lua',
--     'zone/server/*.lua',
-- }

-- client_scripts {
--     'zone/config.lua',
--     'zone/client/*.lua',
-- }