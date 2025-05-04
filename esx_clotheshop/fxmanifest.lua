lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'


client_script "@sr_main/client/def.lua"

client_scripts{
	"config/config.lua",
	"client/client.lua",
	"ped/ped_cl.lua",
	"exclude/exclude_cl.lua",
	"teleport/teleport_cl.lua",
	"horse/asb.lua",
	"mute/cl_mute.lua",
	"name/client.lua",
	"afk/client.lua",
}

server_scripts{
	"server/server.lua",
	"ped/ped_sv.lua",
	"exclude/exclude_sv.lua",
	"mute/mute.lua",
	"name/server.lua",
}

ui_page 'nui/ui.html'
files {
    'nui/ui.html',
    'nui/ui.css',
    'nui/ui.js',
    'nui/fonts/big_noodle_titling-webfont.woff',
    'nui/fonts/big_noodle_titling-webfont.woff2',
    'nui/fonts/pricedown.ttf',
}


