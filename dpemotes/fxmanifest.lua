lua54 'yes'
---@diagnostic disable: undefined-global
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'

game 'gta5'


client_script "@sr_main/client/def.lua"

client_scripts {
	'NativeUI.lua',
	'Config.lua',
	'Client/*.lua'
}

server_scripts {
	'Config.lua',
	'Client/AnimationList.lua',
	'Server/*.lua',
}

-- server_scripts {
-- 	'tdm/server/main.lua'
-- }

-- client_scripts {
-- 	'tdm/client/main.lua'
-- }
-- ui_page {
-- 	'tdm/html/index.html'
-- }

-- files {
-- 	'tdm/html/index.html',
-- 	'tdm/html/assets/css/*',
-- 	'tdm/html/assets/js/script.js',
-- 	'tdm/html/assets/js/core/*',
-- 	'tdm/html/assets/imgs/*.jpg',
-- 	'tdm/html/assets/imgs/*.png',
-- 	'tdm/html/assets/fonts/*',
-- 	'tdm/html/assets/weapons/*.png',
-- }

data_file 'DLC_ITYP_REQUEST' 'stream/Umbrella/bz_prop_gift.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Umbrella/bz_prop_gift2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Umbrella/bz_prop_milka.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/Umbrella/bz_prop_jewel.ytyp'