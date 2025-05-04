lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
games { 'gta5' }

author 'mlodygustav <https://github.com/mlodygustav> Join to discord https://discord.gg/rrHFBmf'
description 'Vibeful Notify'
version '1.0'

client_script 'client.lua'
ui_page('html/index.html')

export "Notification"

files {
    'html/index.html',
    'html/ui.css',
    'html/intuition.mp3'
}