lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

---@diagnostic disable: undefined-global
fx_version 'cerulean'
game 'gta5'
version '2.0'

shared_scripts {
	'shared/*.lua',
	'shared/*.json',
}

client_scripts {
	'client/*.lua',
}
server_scripts {
	-- '@mysql-async/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'mysql-async'.:warning:
	'@oxmysql/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'oxmysql'.:warning:
	'server/*.lua',
}

ui_page "html/index.html"
files {
	'html/index.html',
	'html/css/*.css',
	'html/fonts/*.TTF',
	'html/fonts/*.*',
	'html/images/**/*.png',
	'html/images/**/**/*.png',
	'html/js/*.js',
	'html/js/**/*.js',
	'html/images/**/*.png',
	'html/pages/**/*.js',
	'html/pages/**/*.html',
}



escrow_ignore {
	'client/barber.lua',
	'client/clothing.lua',
	'client/editable.lua',
	'client/joboutfits.lua',
	'client/surgery.lua',
	'client/tattoo.lua',
	'client/wardrobe.lua',
	'shared/*.lua',
	'server/botToken.lua',
	'server/editable.lua',
	'server/tattoo.lua',
}


dependencies {
	'skinchanger',
}

dependency '/assetpacks'