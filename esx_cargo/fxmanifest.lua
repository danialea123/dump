lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games {'gta5'}

ui_page "html/index.html"
files {
	"html/*",
}

client_scripts {
    "shared/*.lua",
    "client/*.lua"
}

server_scripts {
    "shared/*.lua",
    "server/*.lua"
}