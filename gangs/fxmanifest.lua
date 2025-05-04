lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'


client_script "@sr_main/client/def.lua"

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua',
	--"BeanCafe/beancafe_sv.lua",
	--"hotdog/hotdog.lua",
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua',
	--"BeanCafe/beancafe.lua",
	--"hotdog/hotdog_cl.lua",
}

dependencies {
	'essentialmode',
}