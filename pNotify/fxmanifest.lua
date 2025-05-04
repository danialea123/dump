lua54 'yes'
client_script 'validation.lua'

fx_version 'bodacious'
games { 'gta5' }
author 'author'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

description "Simple Notification Script using https://notifyjs.com/"

ui_page "html/index.html"

client_script "cl_notify.lua"

export "SetQueueMax"
export "SendNotification"

files {
    "html/index.html",
    "html/pNotify.js",
    "html/noty.js",
    "html/noty.css",
    "html/themes.css",
    "html/sound-example.wav"
}





