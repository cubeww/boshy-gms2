function pokemon_puzzle_spike_hit() {
    var _spike = instance_place(x, y, obj_pokemon_puzzle_shootable_spike);
    if (_spike == noone) {
        return false;
    }

    // G745–746 use the spike's position for the G710 blood burst.
    repeat (71) {
        instance_create_depth(_spike.x, _spike.y, _spike.depth - 1, obj_blood);
    }
    audio_play_sound(snd_pokemon_puzzle_spike_hit, 1, false);
    instance_destroy(_spike);

    // G763 opens the gate after the last shootable spike in this part of the maze.
    var _gate = inst_pokemon_puzzle_spike_gate;
    if (instance_exists(_gate)) {
        var _spike_remains = false;
        with (obj_pokemon_puzzle_shootable_spike) {
            if (id != _spike && point_in_rectangle(x, y, 1308, 247, 1863, 952)) {
                _spike_remains = true;
            }
        }
        if (!_spike_remains) {
            instance_destroy(_gate);
        }
    }
    return true;
}
