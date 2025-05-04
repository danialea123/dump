lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
game 'gta5'


author 'A-Dev'
description 'Gang Zone Capture'
version '1.0'
ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config/sh_*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}

files {
    "html/index.html",
    'html/js/*.js',
    'html/css/*.css',
    'html/img/*.webp',
    'html/img/*.png',
    
    '**/vehicles.meta',
    '**/carvariations.meta',
    '**/carcols.meta',
    '**/handling.meta',
    '**/dlctext.meta',
    '**/contentunlocks.meta',
    '**/vehiclelayouts.meta',
    '**/shop_vehicle.meta',

    '**/**/vehicles.meta',
    '**/**/carvariations.meta',
    '**/**/carcols.meta',
    '**/**/handling.meta',
    '**/**/dlctext.meta',
    '**/**/contentunlocks.meta',
    '**/**/vehiclelayouts.meta',
    '**/**/shop_vehicle.meta',

    '**/**/**/vehicles.meta',
    '**/**/**/carvariations.meta',
    '**/**/**/carcols.meta',
    '**/**/**/handling.meta',
    '**/**/**/dlctext.meta',
    '**/**/**/contentunlocks.meta',
    '**/**/**/vehiclelayouts.meta',
    '**/**/**/shop_vehicle.meta',
}

data_file 'HANDLING_FILE' '**/handling.meta'
data_file 'VEHICLE_METADATA_FILE' '**/vehicles.meta'
data_file 'CARCOLS_FILE' '**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' '**/carvariations.meta'
data_file 'DLCTEXT_FILE' '**/dlctext.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' '**/contentunlocks.meta'
data_file 'VEHICLE_LAYOUTS_FILE' '**/vehiclelayouts.meta'
data_file 'VEHICLE_SHOP_DLC_FILE' '**/shop_vehicle.meta'

data_file 'HANDLING_FILE' '**/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE' '**/**/vehicles.meta'
data_file 'CARCOLS_FILE' '**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' '**/**/carvariations.meta'
data_file 'DLCTEXT_FILE' '**/**/dlctext.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' '**/**/contentunlocks.meta'
data_file 'VEHICLE_LAYOUTS_FILE' '**/**/vehiclelayouts.meta'
data_file 'VEHICLE_SHOP_DLC_FILE' '**/**/shop_vehicle.meta'

data_file 'HANDLING_FILE' '**/**/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE' '**/**/**/vehicles.meta'
data_file 'CARCOLS_FILE' '**/**/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' '**/**/**/carvariations.meta'
data_file 'DLCTEXT_FILE' '**/**/**/dlctext.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' '**/**/**/contentunlocks.meta'
data_file 'VEHICLE_LAYOUTS_FILE' '**/**/**/vehiclelayouts.meta'
data_file 'VEHICLE_SHOP_DLC_FILE' '**/**/**/shop_vehicle.meta'