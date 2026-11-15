function missingno_wrap_shot() {
    var _vine = instance_find(obj_missingno_wrap, 0);
    if (_vine == noone) {
        return false;
    }

    // G828 consumes the player's bullets and credits one step toward breaking the vine.
    with (obj_bullet) {
        instance_destroy();
    }
    ++_vine.wrap_release;
    audio_play_sound(snd_mario_bump, 1, false);
    return true;
}

function missingno_wrap_clear(_player) {
    with (obj_missingno_wrap) {
        if (_player != noone) {
            _player.image_xscale = 1;
            _player.image_yscale = 1;
        }
        instance_destroy();
    }
}

function missingno_wrap_tick_overlay() {
    var _vine = instance_find(obj_missingno_wrap, 0);
    if (_vine != noone) {
        // G832 sets 128 - age / 4, then G1060 adds ten transparency levels.
        image_alpha = clamp((_vine.wrap_age div 4) - 10, 0, 128) / 128;
        return;
    }

    // G833 adds another transparency level while the attack group is selected.
    var _boss = instance_find(obj_missingno, 0);
    var _fade = _boss != noone && _boss.attack_kind == 6 ? 11 : 10;
    image_alpha = max(0, image_alpha - _fade / 128);
}

function missingno_pattern_wrap(_player) {
    switch (fight_age) {
        case 710:
            missingno_attack_caption("Enemy MISSINGNO. used WRAP!");
            break;
        case 800:
            // G824 creates Active 44 at the boss's hotspot.
            instance_create_layer(x, y, "Hazards", obj_missingno_wrap);
            break;
        case 1550:
            target_y = 360;
            break;
        case 1650:
            target_y = 123;
            break;
    }

    var _vine = instance_find(obj_missingno_wrap, 0);
    if (_vine == noone || _player == noone) {
        return;
    }

    // G825 approaches the player each step and narrows the vine on the X axis.
    if (_vine.wrap_age > 0) {
        var _frame = _vine.image_index + (_vine.wrap_age < 150 ? 0.35 : 0.5);
        _vine.image_index = _frame < 4 ? _frame : 2 + (_frame - 4);
    }
    ++_vine.wrap_age;
    ++_vine.wrap_stun_steps;
    _vine.x = floor(lerp(_vine.x, _player.x, 0.2));
    _vine.y = floor(lerp(_vine.y, _player.y, 0.2));
    _vine.image_xscale -= 0.0025;
    if (_vine.wrap_stun_steps >= 5 && _player.boshy_mask_meeting(_vine)) {
        // G826–827 handle both rounded horizontal speeds with the same stun.
        _player.force_horizontal_speed(0);
        _player.vsp = 0;
        _vine.wrap_stun_steps = 0;
        ++_vine.wrap_release;
    }

    if (_vine.wrap_release >= 100) {
        missingno_wrap_clear(_player);
        audio_play_sound(snd_death_impact, 1, false);
        fight_age = 1500;
        return;
    }
    if (_vine.wrap_age >= 285) {
        missingno_wrap_clear(_player);
        _player.die();
        return;
    }

    // G837 changes the player's displayed proportions while the attack is active.
    _player.image_xscale -= 0.001;
    _player.image_yscale += 0.003;
    if (_player.boshy_mask_meeting(_vine)) {
        // G838 pins the vine vertically to the player's body on contact.
        _vine.x = floor(_player.x);
        _vine.y = floor(_player.y) - 8;
        missingno_attack_kick(_vine.wrap_age / 10, 3);
    }
}
