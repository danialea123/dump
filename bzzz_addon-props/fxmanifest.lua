lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game { 'gta5' }
author 'BzZz'
description 'Addon props'

ui_page 'catcafe/html/index.html'

files {
    'catcafe/html/*',
}

client_script 'catcafe/client.lua'
shared_script 'catcafe/config.lua'

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_seeds_000.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_props_gardenpack.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_garden_lysohlavky001'
dependency '/assetpacks'