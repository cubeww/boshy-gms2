function cheetahmen_late_setup() {
    cheetahmen_spiny_timer = 0;
    cheetahmen_spinies = [inst_cheetahmen_late_3847];
    cheetahmen_pacman_age = -1;
    cheetahmen_pacman_sound = -1;
    cheetahmen_bagel_age = -1;
    cheetahmen_bagel_digits = [];
}

function cheetahmen_late_step(_player) {
    cheetahmen_lakitu_step(_player);
    cheetahmen_pacman_step(_player);
    cheetahmen_bagel_step(_player);
    if (_player != noone) {
        cheetahmen_mirror_ball_step(_player);
    }
}

function cheetahmen_late_draw() {
    var _board = inst_cheetahmen_late_3501;
    if (instance_exists(_board)) {
        prehistorik_death_board_draw(_board.x + 6, _board.y + 16);
    }

    for (var _i = 0; _i < array_length(cheetahmen_bagel_digits); ++_i) {
        var _digit = cheetahmen_bagel_digits[_i];
        draw_sprite_part(spr_cheetahmen_bagel_digits, 0, _digit.glyph * 14, 0, 14, 20, _digit.x, _digit.y);
    }
}

function cheetahmen_late_cleanup() {
    if (cheetahmen_pacman_sound != -1) {
        audio_stop_sound(cheetahmen_pacman_sound);
    }
}

function cheetahmen_lakitu_step(_player) {
    // Fusion groups 738–746 evaluate the 600 ms timer while Lakitu is active.
    var _lakitu = inst_cheetahmen_late_3715;
    if (instance_exists(_lakitu) && cheetahmen_late_in_zone(_player, 3838, -3, 4484, 482)) {
        _lakitu.x = floor(_lakitu.x + _lakitu.horizontal_speed);
        if (_lakitu.horizontal_speed > 5) {
            --_lakitu.horizontal_speed;
        } else if (_lakitu.horizontal_speed < -4) {
            ++_lakitu.horizontal_speed;
        }
        _lakitu.horizontal_speed += _lakitu.x > _player.x ? -0.3 : 0.3;

        if (++cheetahmen_spiny_timer >= 30) {
            cheetahmen_spiny_timer = 0;
            var _new_spiny = instance_create_layer(_lakitu.x, _lakitu.y, "Gameplay", obj_hazard, {
                sprite_index: spr_cheetahmen_spiny,
                fall_speed: -3
            });
            array_push(cheetahmen_spinies, _new_spiny);
        }
    }

    for (var _i = array_length(cheetahmen_spinies) - 1; _i >= 0; --_i) {
        var _spiny = cheetahmen_spinies[_i];
        if (!instance_exists(_spiny)) {
            array_delete(cheetahmen_spinies, _i, 1);
            continue;
        }
        _spiny.y = floor(_spiny.y + _spiny.fall_speed);
        _spiny.fall_speed += 0.3;
        if (_spiny.bbox_top >= room_height) {
            instance_destroy(_spiny);
            array_delete(cheetahmen_spinies, _i, 1);
        }
    }
}

function cheetahmen_mirror_ball_step(_player) {
    // Fusion groups 73–75 mirror the player relative to the visible frame edges.
    var _ball = inst_cheetahmen_late_4548;
    if (!instance_exists(_ball)) {
        return;
    }
    var _in_zone = cheetahmen_late_in_zone(_player, 4473, 475, 5129, 969);
    var _hit_hazard = false;
    if (_in_zone) {
        var _camera = view_camera[0];
        var _right = camera_get_view_x(_camera) + camera_get_view_width(_camera);
        var _bottom = camera_get_view_y(_camera) + camera_get_view_height(_camera);
        _ball.x = floor(_right - abs(_player.x - 4480));
        _ball.y = floor(_bottom - (_player.y - 505));
        with (_ball) {
            _hit_hazard = place_meeting(x, y, obj_hazard);
        }
    }
    if (_hit_hazard || _player.boshy_mask_meeting(_ball)) {
        _player.die();
    }
}

function cheetahmen_pacman_step(_player) {
    // Fusion groups 907–909 enlarge the rising trap 25 times for its fifteen-step attack.
    var _pacman = inst_cheetahmen_late_4972;
    if (!instance_exists(_pacman)) {
        return;
    }
    if (cheetahmen_pacman_age < 0 && cheetahmen_late_in_zone(_player, 5135, 708, 5727, 738)) {
        cheetahmen_pacman_age = 0;
        cheetahmen_pacman_sound = audio_play_sound(snd_cheetahmen_pacman, 1, false);
    }
    if (cheetahmen_pacman_age >= 0 && cheetahmen_pacman_age < 15) {
        _pacman.image_xscale = 25;
        _pacman.image_yscale = 25;
        _pacman.y -= 20;
        if (_player != noone) {
            _pacman.x = _player.x;
        }
        ++cheetahmen_pacman_age;
    }
}

function cheetahmen_bagel_step(_player) {
    // Fusion groups 1097–1102 trigger the rolling bagel and its display.
    if (cheetahmen_bagel_age < 0 && cheetahmen_late_in_zone(_player, 2028, 546, 2100, 704)) {
        cheetahmen_bagel_age = 0;
    }
    if (cheetahmen_bagel_age < 0) {
        return;
    }

    var _bagel = inst_cheetahmen_late_4270;
    if (instance_exists(_bagel)) {
        _bagel.x -= 15;
        _bagel.image_angle = (_bagel.image_angle + 5) mod 360;
        ++cheetahmen_bagel_age;
        // All three create actions use the rolling bagel as their position parent.
        if (cheetahmen_bagel_age == 15 || cheetahmen_bagel_age == 20 || cheetahmen_bagel_age == 25) {
            var _glyph = cheetahmen_bagel_age == 25 ? 3 : 0;
            array_push(cheetahmen_bagel_digits, { glyph: _glyph, x: _bagel.x, y: _bagel.y });
        }
        if (_bagel.bbox_right < 0) {
            instance_destroy(_bagel);
        }
    }
}

function cheetahmen_late_in_zone(_player, _left, _top, _right, _bottom) {
    return _player != noone && _player.x >= _left && _player.x < _right
        && _player.y >= _top && _player.y < _bottom;
}
