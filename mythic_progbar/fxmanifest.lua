lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: param-type-mismatch, missing-parameter
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'
game 'gta5'

ui_page('html/index.html') 

client_scripts {
    'client/main.lua'
}

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/script.js'
}

exports {
    'Progress',
    'ProgressWithStartEvent',
    'ProgressWithTickEvent',
    'ProgressWithStartAndTick',
    'getAction'
}

