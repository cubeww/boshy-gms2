draw_self();
if (heal_steps < 0) {
    exit;
}

var _emote = spr_pokemon_puzzle_nurse_emote;
var _frame = (emote_steps div 10) mod sprite_get_number(_emote);
draw_sprite(_emote, _frame, x - 5, y - 67);
var _line = heal_steps == 175 ? "You're not a pokemanz?!" : "Lemme heal your pokemanz!";
draw_boshy_text(_line, x - 16, y - 88);
