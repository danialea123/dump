lua54 'yes'
client_script 'validation.lua'

---@diagnostic disable: undefined-global
shared_script '@WaveShield/resource/waveshield.js' --this line was automatically written by WaveShield

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

---@diagnostic disable: undefined-global
fx_version "bodacious"


author "CanX"
version '1.0.0'




games {
    "gta5",
}

ui_page 'web/index.html'

shared_scripts {
    -- '@es_extended/imports.lua',
	-- '@es_extended/locale.lua',
    "shared/config.lua"
}

client_script {
    "client/**/*",
    'locales/*.lua',
}
server_script {
    "@mysql-async/lib/MySQL.lua",
    "server/**/*",
    'locales/*.lua',
}

files {
    'web/index.html',
    'web/**/*',
}


escrow_ignore {
    "client/**/*",
    "server/**/*",
    "locales/**/*",
    "shared/config.lua"
  }
dependency '/assetpacks'