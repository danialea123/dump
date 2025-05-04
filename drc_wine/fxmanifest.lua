lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'

game 'gta5'

author 'DRC Scripts'
description 'DRC WINEMAKER'

version '1.0.0'



shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'server/*.lua',
}

files {
	'locales/*.json'
}

escrow_ignore {
	'shared/*.lua',
	'client/cl_Utils.lua',
	'server/sv_Utils.lua',
}

dependency '/assetpacks'