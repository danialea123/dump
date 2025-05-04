lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield


fx_version 'adamant'

game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.css',
	'html/index.js',
	'html/jquery-3.4.1.min.js',
	'html/img/*.png',
	'html/img/skillpoints/*.png',
	'html/sounds/*.mp4',
  'html/fonts/**',
	'html/sounds/*.wav',
}

data_file('DLC_ITYP_REQUEST')('stream/diamond_shield.ytyp')

client_scripts{
  'config.lua',
  'client/main.lua',
}

server_scripts{
  'config.lua',
  'server/main.lua',
}




dependency '/assetpacks'