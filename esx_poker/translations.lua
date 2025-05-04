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
    -- notifications
    ['chair_occupied'] = 'This seat is taken.',
    ['no_react'] = 'You didn\'t answer the dealer\'s question in time, you folded the hand.',
    ['no_bet_input'] = 'You have not set a bet amount.',
    ['not_enough_chips'] = 'You don\'t have enough chips.',
    ['not_enough_chips_next'] = 'You don\'t have enough chips to bet on Pair Plus as you wouldn\'t have enough chips to play.',
    ['not_enough_chips_third'] = 'You can\'t put in that amount of chips because you wouldn\'t have enough to play your hand.',
    ['not_enough_chips_toplay'] = 'You don\'t have enough chips to play!',
    ['already_betted']= 'You already bet.',
    ['lose'] = 'You lost!',
    -- formatted notif
    ['dealer_not_qual'] = 'Tie.\nDealer did not qualify for the game.\nYou got %s chips back.',
    ['dealer_not_qual_ante'] = 'Tie.\nDealer did not qualify for the game.\nYou got %s chips back. (Odd Multiplier: x%s)',
    ['player_won_ante'] = 'Your hand has won!\nYou have received %s chips. (Odd Multiplier: x%s)',
    ['player_won'] = 'Your hand has won!\nYou have received %s the chips.',
    ['pair_won'] = 'You won %s chips with your Pair Plus bet! (Even Multiplier: x%s)',
    -- hud
    ['current_bet_input'] = 'Bet Vaue:',
    ['current_player_chips'] = 'Your Files:',
    ['table_min_max'] = 'Min/Max:',
    ['remaining_time'] = 'Timer:',
    -- top left
    ['waiting_for_players'] = 'Esperanto for ~b~players~w~...\n',
    ['clearing_table'] = 'Clearing the table..\n~b~Next game will start soon.\n',
    ['dealer_showing_hand'] = '~r~negotiator~w~ is showing his hand.\n',
    ['players_showing_hands'] = 'Revealing the players hand..\n',
    ['dealing_cards'] = 'Negotiator is dealing the cards to the players..\n',
    -- inputs
    ['fold_cards'] = 'To give up',
    ['play_cards'] = 'Continue',
    ['leave_game'] = 'Rise',
    ['raise_bet'] = 'Raise bet',
    ['reduce_bet'] = 'Reduce bet',
    ['custom_bet'] = 'Custom bet',
    ['place_bet'] = 'Place bet',
    ['place_pair_bet'] = 'Place a pair bet',
    -- gtao ui
    ['tcp'] = '<C>[Vanilla]</C> ~b~Poker 3 Cards',
    ['sit_down_table'] = '~h~<C>Play</C> ~b~Poker 3 Cards',
    ['description'] = 'Game Description',
    ['desc_1'] = 'TCP_DIS1', -- this is Rockstar Setuped default, this will automaticly change if you are using german language etc.
    ['desc_2'] = 'TCP_DIS2',
    ['desc_3'] = 'TCP_DIS3',
    ['description_info'] = 'Como o jogo funciona.',
    ['rule_1'] = 'TCP_RULE_1',
    ['rule_2'] = 'TCP_RULE_2',
    ['rule_3'] = 'TCP_RULE_3',
    ['rule_4'] = 'TCP_RULE_4',
    ['rule_5'] = 'TCP_RULE_5',
    ['rule_header_1'] = 'TCP_RULE_1T',
    ['rule_header_2'] = 'TCP_RULE_2T',
    ['rule_header_3'] = 'TCP_RULE_3T',
    ['rule_header_4'] = 'TCP_RULE_4T',
    ['rule_header_5'] = 'TCP_RULE_5T',
    ['rules'] = 'Game Rules',
    ['rules_info'] = 'Regras do jogo ou qualquer coisa que você deva saber.'
}
