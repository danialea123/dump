lua54 'yes'
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'

game 'gta5'

name         'pickle_wheel'
version      '1.0.0'
description  'Wheel & Pedal Support for FiveM.'
author       'Pickle Mods'

ui_page "nui/index.html"

files {
    "nui/index.html",
    "nui/assets/**/*.*",
}

client_scripts {
    'client.lua',
}