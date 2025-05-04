lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
games { 'gta5' }

ui_page "radioUtils/html/ui.html"

files {
	"radioUtils/html/ui.html",
	"radioUtils/html/audio/*.ogg",
}

client_scripts {
	"radioUtils/client/*.lua",
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	'radioUtils/server/server.lua',
}

data_file 'DLC_ITYP_REQUEST' 'stream/wine_props.ytyp'
dependency '/assetpacks'