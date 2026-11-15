++stage_steps;
var _player = instance_find(obj_player, 0);
if (_player == noone) {
    game_controller.fade_stage_music();
}
update_view(_player);

with (obj_wario_title_sign) {
    // Groups 682–683 reveal the entrance ice and drop the title into view.
    if (!dropping && _player != noone && point_in_rectangle(_player.x, _player.y, 146, 955, 176, 1310)) {
        dropping = true;
        with (obj_wario_ice) {
            if (reveal_with_sign) {
                sprite_index = spr_wario_ice;
                image_speed = 1;
                visible = true;
                layer = layer_get_id("Gameplay");
            }
        }
    }
    if (dropping) {
        y += 2;
        image_xscale = 3;
        image_yscale = 3;
    }
}

with (obj_wario_hazard) {
    advance(_player, other.stage_steps);
}

if (_player != noone) {
    // Group 836 checks the hidden detector before group 979 reattaches it to the player.
    ds_list_clear(ice_contacts);
    with (obj_wario_ice_reveal) {
        instance_place_list(x, y, obj_wario_ice, other.ice_contacts, false);
        x = _player.x;
        y = _player.y;
    }
    var _count = ds_list_size(ice_contacts);
    for (var _index = 0; _index < _count; ++_index) {
        var _ice = ice_contacts[| _index];
        if (!_ice.visible && !_ice.reveal_with_sign) {
            _ice.visible = true;
            audio_play_sound(snd_wario_ice_reveal, 1, false);
        }
    }
}
