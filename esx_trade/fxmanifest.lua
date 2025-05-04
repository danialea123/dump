lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'bodacious'

game 'gta5'

client_scripts {
    'GetFrameworkObject.lua',
    'config/config.lua',
    'client/client.lua',
}
server_scripts {
    'GetFrameworkObject.lua',
    'config/config.lua',
    'config/server_config.lua',
    'server/editable.lua',
    'server/server.lua',
}
ui_page 'html/index.html'


escrow_ignore {
    'config/server_config.lua',
    'server/editable.lua',
    'config/config.lua',
    'GetFrameworkObject.lua',
	
	
}

files {
    'html/index.html',
    'html/images/*.png',
    'html/itemimages/*.png',
    'html/fonts/*.OTF',
    'html/fonts/*.otf',
    'html/fonts/*.ttf',
    'html/index.js',
    "html/modules/*.css",
    "html/modules/*.js",
}

escrow_ignore{
    'client/*.lua',
    'config/*.lua',
    'server/*.lua',
    'GetFrameworkObject.lua',
}




dependencies {
	'/onesync'
}
dependency '/assetpacks'