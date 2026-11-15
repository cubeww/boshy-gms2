var _ez_mode = game_campaign_difficulty() == 0;
if (instance_exists(boss)) {
    // G614 removes GiantBow outside Ez-mode.
    if (_ez_mode) {
        // G855 and G1116 anchor the bow to the active Kappa frame's action point.
        var _faces_left = boss.sprite_index == spr_secret_jtv_scope_boss_left;
        var _bow_angle = (_faces_left ? -45 : 45) + dsin(scene_steps * 4) * 10;
        var _bow_scale = boss.image_xscale * 0.1;
        var _bow_offset_x = (_faces_left ? 7 : -5) * boss.image_xscale;
        var _bow_offset_y = (_faces_left ? -6 : -9) * boss.image_yscale;
        var _rotation_cos = dcos(boss.image_angle);
        var _rotation_sin = dsin(boss.image_angle);
        var _bow_x = boss.x + _bow_offset_x * _rotation_cos + _bow_offset_y * _rotation_sin;
        var _bow_y = boss.y - _bow_offset_x * _rotation_sin + _bow_offset_y * _rotation_cos;
        draw_sprite_ext(giant_bow.sprite_index, 0, _bow_x, _bow_y, _bow_scale, _bow_scale,
            _bow_angle, c_white, 1);
    }

    var _flash = (hit_flash_steps >= 7 && hit_flash_steps <= 8) || (hit_flash_steps >= 3 && hit_flash_steps <= 4);
    // G850–854 alternate additive and normal ink on hit.
    if (_flash) {
        gpu_set_blendmode(bm_add);
    }
    draw_sprite_ext(boss.sprite_index, 0, boss.x, boss.y, boss.image_xscale, boss.image_yscale,
        boss.image_angle, c_white, 1);
    if (_flash) {
        gpu_set_blendmode(bm_normal);
    }
}

var _player = instance_find(obj_player, 0);
if (_ez_mode && _player != noone && !_player.dead && _player.visible) {
    var _bow = _player.facing < 0 ? spr_secret_jtv_player_bow_left : spr_secret_jtv_player_bow_right;
    var _bow_frame = floor(scene_steps * 0.15) mod sprite_get_number(_bow);
    draw_sprite(_bow, _bow_frame, _player.x - _player.facing * 4, _player.y - 12);
}

secret_jtv_dialogue_draw();

if (hp > 0) {
    draw_set_color(c_red);
    draw_rectangle(1920, 1488, 1920 + floor(640 * (hp / max_hp)) - 1, 1495, false);
    draw_set_color(c_white);
}
