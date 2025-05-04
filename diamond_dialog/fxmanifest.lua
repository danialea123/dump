lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield


fx_version 'bodacious'

game 'gta5'

ui_page 'icon/html/index.html'

client_scripts {
    'icon/Client/*.lua',
    'icon/lib/*.lua'
}

this_is_a_map "yes"

files {
    'icon/html/index.html',
    'icon/html/css/*.css',
    'icon/html/js/*.js',
    'icon/html/js/*.js.map',
    'icon/html/img/*.png',
    'icon/html/img/*.jpg',
    'icon/html/img/*.gif',
    -- 'html/_sounds/*.mp3',
}

client_scripts {
    "RageUI/RMenu.lu*",
    "RageUI/menu/RageUI.lu*",
    "RageUI/menu/Menu.lu*",
    "RageUI/menu/MenuController.lu*",
    "RageUI/components/*.lu*",
    "RageUI/menu/elements/*.lu*",
    "RageUI/menu/items/*.lu*",
}

client_scripts {
    'config.lu*',
	'client/*.lu*'
}

export 'CreateDialog'
export 'CloseDialog'
export 'CloseAll'
export 'IsDialogOpened'
export 'ConfirmationDialog'