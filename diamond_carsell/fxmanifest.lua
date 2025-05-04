lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'


ui_page 'web/dist/index.html'
files {
    'web/dist/*',
	'web/dist/**/*',
}



client_scripts {
    'GetFrameworkObject.lua',
    'client/client.lua',
    'client/clienteditable.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'GetFrameworkObject.lua',
    'server/functions.lua',
    'server/logs.lua',
    'server/sv_config.lua',
    'server/server.lua',
}

shared_scripts {
    'GetFrameworkObject.lua',
    'config.lua',
}

escrow_ignore {
    'config.lua',
    'server/*.lua',
    'client/*.lua',
}

dependency '/assetpacks'

files{
	'**/**/weaponcomponents.meta',
	'**/**/weaponarchetypes.meta',
	'**/**/weaponanimations.meta',
	'**/**/pedpersonality.meta',
	'**/**/weapons.meta',
}

data_file 'WEAPONCOMPONENTSINFO_FILE' '**/**/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' '**/**/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/**/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' '**/**/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/**/weapons.meta'

client_script 'cl_weaponNames.lua'