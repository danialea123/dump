lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'


client_script "@sr_main/client/def.lua"

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'server/*.lua',
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	-- 'client/npc_drop-client.lua',
	'client/pointfinger-client.lua',
	'client/speed_limit-client.lua',
	'client/cfg.lua',
	'client/RealisticVehicleFailure_client.lua',
	'client/handsup-client.lua',
	'client/gpstools-client.lua',
	'client/no_vehicle_rewards-client.lua',
	'client/disable_dispatch-client.lua',
	'client/no_drive_by.lua',
	'client/shuffle.lua',
	"client/weapback.lua",
	-- 'crouch/client/*.lua',
	-- 'crouch/config.lua',
	'client/crouchold.lua',
	"client/announce.lua",
}