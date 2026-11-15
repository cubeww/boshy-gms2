// G924 creates each fireball at the front of the Game layer.
if (visible) {
    instance_create_layer(round(x - 19 * image_xscale), round(y - 14 * image_yscale),
        "Fireballs", obj_pokemon_puzzle_fireball, { image_angle: fire_angle, travel_speed: 1 });
    fire_angle += irandom_range(10, 14);
} else {
    var _player = instance_find(obj_player, 0);
    if (_player == noone || !point_in_rectangle(_player.x, _player.y, 1407, 790, 1426, 819)) {
        exit;
    }
    visible = true;
    audio_play_sound(snd_pokemon_puzzle_charizard, 1, false);
}

// G928 enlarges Charizard while the volley turns through its first 300 degrees.
if (fire_angle < 300) {
    image_xscale += 0.05;
    image_yscale = image_xscale;
}
