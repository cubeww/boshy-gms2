++emote_steps;
if (heal_steps == 175) {
    exit;
}

var _player = instance_find(obj_player, 0);
if (heal_steps < 0) {
    // G931 shows the dialogue and emote on first contact.
    if (_player == noone || _player.dead || !_player.boshy_mask_meeting(id)) {
        exit;
    }
    heal_steps = 0;
}

// G932–935 hold the player at the machine, play its cue, then trigger death.
++heal_steps;
if (heal_steps >= 50 && _player != noone && !_player.dead) {
    _player.x = 255;
    _player.y = 194;
}
if (heal_steps == 80) {
    var _game = instance_find(obj_game, 0);
    _game.start_stage_music(snd_pokemon_puzzle_nurse_heal, false, false);
}
if (heal_steps == 175 && _player != noone && !_player.dead) {
    _player.die();
}
