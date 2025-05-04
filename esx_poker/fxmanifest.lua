lua54 'yes'


client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'

client_scripts {
    '@essentialmode/locale.lua',
	'shared/shared_utils.lua',
    'src/RMenu.lua',
    'src/menu/RageUI.lua',
    'src/menu/Menu.lua',
    'src/menu/MenuController.lua',
    'src/components/*.lua',
    'src/menu/elements/*.lua',
    'src/menu/items/*.lua',
    'src/menu/panels/*.lua',
    'src/menu/panels/*.lua',
    'src/menu/windows/*.lua',
    'config.lua',
    'client/cl_main.lua',
    'translations.lua',
}

server_scripts {
    '@essentialmode/locale.lua',
	'shared/shared_utils.lua',
	'translations.lua',
    'config.lua',
    'server/sv_main.lua',
}