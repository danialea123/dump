lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

ui_page "html/index.html"


client_script "@sr_main/client/def.lua"

client_scripts {
    "client/main.lua",
    "client/trunk.lua",
    "client/brancard.lua",
	"config.lua",
    "main.lua",
    "textui/client.lua",
}

files {
    'html/index.html',
    'html/css/main.css',
    'html/css/RadialMenu.css',
    'html/js/main.js',
    'html/js/RadialMenu.js',
}

server_script{ 
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
    "textui/server.lua",
}

client_scripts {
	'client.lua'
}