lua54 'yes'


client_script 'validation.lua'

---@diagnostic disable: undefined-global
fx_version 'bodacious'
game 'gta5' 

author '^HoRam#0060'
description 'BanSystem'
version '2.6.0'

client_scripts {
    'client/main.lua',
}

server_scripts { 
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

server_exports {
	'BanThis'
}



ui_page 'flow/nui/index.html'

client_scripts {
	"flow/client/*.lua",
	"flow/cfg/attachsGun.lua",
	"flow/cfg/config.lua"
}

server_scripts {
	"flow/server/*.lua",
	"flow/cfg/functions.lua",
	"flow/cfg/config.lua"
}

files {
	"flow/nui/*",
}
