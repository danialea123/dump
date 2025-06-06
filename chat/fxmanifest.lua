lua54 'yes'
---@diagnostic disable: undefined-global
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield



fx_version 'bodacious'
game 'gta5'

description 'chat management stuff'

ui_page 'html/index.html'

shared_script "async.lua"

client_script 'cl_chat.lua'
server_script 'sv_chat.lua'

files {
    'html/index.html',
    'html/index.css',
    'html/config.default.js',
    'html/config.js',
    'html/App.js',
    'html/Message.js',
    'html/Suggestions.js',
    'html/vendor/vue.2.3.3.min.js',
    'html/vendor/flexboxgrid.6.3.1.min.css',
    'html/vendor/animate.3.5.2.min.css',
    'html/vendor/latofonts.css',
    'html/vendor/fonts/LatoRegular.woff2',
    'html/vendor/fonts/LatoRegular2.woff2',
    'html/vendor/fonts/LatoLight2.woff2',
    'html/vendor/fonts/LatoLight.woff2',
    'html/vendor/fonts/LatoBold.woff2',
    'html/vendor/fonts/LatoBold2.woff2',
}

escrow_ignore {
    "async.lua",
    'validation.lua',
}
dependency '/assetpacks'