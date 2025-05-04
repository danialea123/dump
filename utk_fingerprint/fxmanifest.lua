lua54 'yes'
client_script 'validation.lua'

shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version "adamant"

game "gta5"

files {
    "movies/script.js",
    "movies/style.css",
    "movies/intro.gif",
    "movies/success.gif",
    "movies/fail.gif",
    "movies/blank.png",
    "movies/movie.html",
}

ui_page "movies/movie.html"

client_script "client.lua"

dependency "utk_hackdependency"