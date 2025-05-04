lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'
author 'AlaviOne#0327'

client_script "@sr_main/client/def.lua"

server_scripts {
    'server/main.lua',
    "shoti/sv.lua",
}

client_scripts {
    'client/main.lua',
    'client/lock.lua',
    "shoti/cl.lua",
}

ui_page {
	'web/UI.html'
}

files {
	'web/style.css',
    'web/UI.html',
    'web/main.js',
	'web/*.png',
}