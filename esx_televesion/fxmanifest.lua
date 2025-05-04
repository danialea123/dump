lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'

game 'gta5'

description 'RTX TV'

version '15.0'

server_scripts {
	--'@mysql-async/lib/MySQL.lua',  -- enable this and remove oxmysql line (line 11) if you use mysql-async (only enable this for qbcore/esx framework)
	--'@oxmysql/lib/MySQL.lua', -- enable this and remove mysql async line (line 10) if you use oxmysql (only enable this for qbcore/esx framework)
	'config.lua',
	'language/main.lua',
	'server/main.lua',
	'server/other.lua'
}

client_scripts {
	'config.lua',
	'language/main.lua',
	'client/main.lua'
}

files {
	'html/ui.html',
	'html/video.html',
	'html/styles.css',
	'html/video.css',
	'html/scripts.js',
	'html/video.js',
	'html/BebasNeueBold.ttf',
	'html/tv/index.html',
	'html/tv/style.css',
	'html/tv/img/background.png',
	'html/img/*.png'
}

ui_page 'html/ui.html'

exports {
	'HasVehicleTV',
}



escrow_ignore {
  'config.lua',
  'language/main.lua',
  'server/other.lua'
}
dependency '/assetpacks'