Translations = {}

function _(str, ...) -- Translate string
    if Translations[Config.TranslationSelected] ~= nil then
        if Translations[Config.TranslationSelected][str] ~= nil then
            return string.format(Translations[Config.TranslationSelected][str], ...)
        else
            return 'Translation [' .. Config.TranslationSelected .. '][' .. str .. '] does not exist'
        end
    else
        return 'Locale [' .. Config.TranslationSelected .. '] does not exist'
    end
end

function _U(str, ...) -- Translate string first char uppercase
    return tostring(_(str, ...):gsub('^%l', string.upper))
end

Translations['en'] = {
    ['help_play'] = '~INPUT_CELLPHONE_CANCEL~ Back\n~INPUT_FRONTEND_RDOWN~ ~INPUT_JUMP~ Spin\n~INPUT_CONTEXT~ Change Camera\nBet Cost: ~y~%s~w~ Chips',
    ['help_sit'] = 'Press ~INPUT_CONTEXT~ To Sit\nBet Cost: ~y~%s~w~ Chips'
}