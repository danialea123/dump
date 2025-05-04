lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

-- polat
fx_version 'cerulean'
game 'gta5'
name 'plt Planting System'
version '1.14'
description 'Fivem Planting System'
author 'p0lat'
contact 'pltrdgms@hotmail.com'
discord 'https://discord.gg/3h8tebmBeD'
website 'https://polat.tebex.io/'
tutorial'https://polat.gitbook.io/'


ui_page "html/ui.html"

files {
    "html/ui.html",
    "html/ui.css",
    "html/ui.js",
	'html/img/*.png',
	'html/img/*.svg',
}

server_scripts {
	'locale.lua',
	'config.lua',
	'server.lua',
	'lockedserver.lua'
}

client_scripts {
	'locale.lua',
	'config.lua',
	'client.lua',
	'lockedclient.lua',
}

escrow_ignore {
	'locale.lua',
	'config.lua',
	'client.lua',
	'server.lua',
  }


dependency '/assetpacks'