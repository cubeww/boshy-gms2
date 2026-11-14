function prehistorik_opening_setup() {
    // Active 15–17 are decoys over the shaft. The three tiles at x496 are solids.
    opening_decoys = [];
    for (var _x = 304; _x <= 368; _x += 16) {
        array_push(opening_decoys, { x: _x, y: 432, falling: false });
    }

    opening_drop_floor = [
        inst_prehistorik_drop_floor_1,
        inst_prehistorik_drop_floor_2,
        inst_prehistorik_drop_floor_3
    ];
    opening_drop_block = inst_prehistorik_drop_block;
    opening_drop_active = false;

    opening_penguin_x = 250;
    opening_penguin_y = 419;
    opening_penguin_warning = 0;
    opening_penguin_warned = false;
    opening_character_hint = 0;
    opening_penguin_spawn = false;
    opening_penguins = [];
    opening_age = 0;
}

function prehistorik_opening_overlaps(_player, _left, _top, _right, _bottom) {
    return _player.bbox_left < _right && _player.bbox_right >= _left
        && _player.bbox_top < _bottom && _player.bbox_bottom >= _top;
}

function prehistorik_opening_step(_player) {
    ++opening_age;
    opening_penguin_warning = max(0, opening_penguin_warning - 1);
    opening_character_hint = max(0, opening_character_hint - 1);

    for (var _i = 0; _i < array_length(opening_decoys); ++_i) {
        var _tile = opening_decoys[_i];
        if (_player != noone && prehistorik_opening_overlaps(_player, _tile.x, _tile.y, _tile.x + 16, _tile.y + 15)) {
            _tile.falling = true;
        }
        if (_tile.falling) {
            _tile.y += 5;
        }
    }

    if (instance_exists(opening_drop_block)) {
        if (!opening_drop_active && _player != noone
            && point_in_rectangle(_player.x, _player.y, opening_drop_block.x - 5, opening_drop_block.y - 5,
                opening_drop_block.x + 53, opening_drop_block.y + 10)) {
            opening_drop_active = true;
            play_boshy_voice(snd_prehistorik_down_i_go);
        }
        if (opening_drop_active) {
            opening_drop_block.y += 5;
            for (var _i = 0; _i < array_length(opening_drop_floor); ++_i) {
                var _tile = opening_drop_floor[_i];
                if (instance_exists(_tile) && opening_drop_block.bbox_bottom >= _tile.bbox_top) {
                    with (_tile) {
                        instance_destroy();
                    }
                }
            }
            if (opening_drop_block.y > room_height) {
                with (opening_drop_block) {
                    instance_destroy();
                }
            }
        }
    }

    if (_player != noone) {
        var _left = opening_penguin_x - 10;
        var _top = opening_penguin_y - 11;
        if (!opening_penguin_warned && prehistorik_opening_overlaps(_player, _left, _top, _left + 22, _top + 26)) {
            opening_penguin_warned = true;
            opening_penguin_warning = 80;
        }
        if (prehistorik_opening_overlaps(_player, 410, 407, 432, 433)
            || prehistorik_opening_overlaps(_player, 272, 263, 294, 289)) {
            opening_character_hint = 100;
        }

        var _bullet = collision_rectangle(_left, _top, _left + 21, _top + 25, obj_bullet, false, true);
        if (_bullet != noone) {
            with (_bullet) {
                instance_destroy();
            }
            if (!opening_penguin_spawn) {
                if (_player.x < opening_penguin_x) {
                    opening_penguin_spawn = true;
                    audio_play_sound(snd_prehistorik_penguin_hit, 1, false);
                    if (game_trophy_unlock("IWannaBeThePenguin")) {
                        prehistorik_show_trophy("I Wanna Be The Penguin!");
                    }
                } else if (_player.x > opening_penguin_x) {
                    opening_penguin_x = _player.x;
                    opening_penguin_y = _player.y;
                    audio_play_sound(snd_prehistorik_penguin_retaliate, 1, false);
                    audio_play_sound(snd_prehistorik_penguin_retaliate, 1, false);
                    if (_player.die()) {
                        _player = noone;
                    }
                }
            }
        }
    }

    // The original spawner at (336, 480) is invisible.
    if (opening_penguin_spawn && opening_age mod 5 == 0) {
        array_push(opening_penguins, { x: 336, y: 480, vx: -2 - irandom(6), vy: -10 - irandom(4) });
    }

    if (array_length(opening_penguins) == 0) {
        return;
    }
    for (var _i = array_length(opening_penguins) - 1; _i >= 0; --_i) {
        var _penguin = opening_penguins[_i];
        _penguin.x += _penguin.vx;
        _penguin.y += _penguin.vy;
        _penguin.vy += 0.4;

        // Original groups 686–689 probe backdrop collision around the launched penguin.
        if (_penguin.vy < 0 && (collision_point(_penguin.x - 8, _penguin.y - 10, obj_solid, true, false) != noone
            || collision_point(_penguin.x + 8, _penguin.y - 10, obj_solid, true, false) != noone)) {
            _penguin.vy = _penguin.vy * -0.5 + 1;
        } else if (_penguin.vy > 0 && (collision_point(_penguin.x - 4, _penguin.y + 16, obj_solid, true, false) != noone
            || collision_point(_penguin.x + 4, _penguin.y + 16, obj_solid, true, false) != noone)) {
            _penguin.vy *= -0.5;
            _penguin.vx *= 0.8;
        }

        var _edge_x = _penguin.x + sign(_penguin.vx) * 8;
        if (_penguin.vx != 0 && collision_point(_edge_x, _penguin.y, obj_solid, true, false) != noone) {
            _penguin.x -= sign(_penguin.vx);
            _penguin.vx *= -0.8;
        }

        if (_penguin.x - 10 <= page_left - 80 || _penguin.x + 12 >= page_left + 720
            || _penguin.y - 11 <= page_top - 80 || _penguin.y + 15 >= page_top + 560) {
            array_delete(opening_penguins, _i, 1);
        } else if (_player != noone && prehistorik_opening_overlaps(_player,
            _penguin.x - 9, _penguin.y - 11, _penguin.x + 11, _penguin.y + 14)) {
            if (_player.die()) {
                _player = noone;
            }
        }
    }
}

function prehistorik_opening_draw() {
    for (var _i = 0; _i < array_length(opening_decoys); ++_i) {
        var _tile = opening_decoys[_i];
        draw_sprite(spr_prehistorik_drop_tile, 0, _tile.x, _tile.y);
    }

    var _frame = (opening_age div 2) mod 4;
    var _frame_offset = [0, -1, -3, -2];
    var _wobble = dsin(opening_age * 10) * 8;
    draw_sprite(spr_prehistorik_penguin, _frame, opening_penguin_x, opening_penguin_y + _frame_offset[_frame]);
    draw_sprite_ext(spr_prehistorik_penguin, _frame, 420, 418 + _frame_offset[_frame], 1, 1, _wobble, c_white, 1);
    draw_sprite_ext(spr_prehistorik_penguin, _frame, 282, 274 + _frame_offset[_frame], 1, 1, _wobble, c_white, 1);

    for (var _i = 0; _i < array_length(opening_penguins); ++_i) {
        var _penguin = opening_penguins[_i];
        draw_sprite(spr_prehistorik_penguin, 0, _penguin.x, _penguin.y);
    }

    if (opening_penguin_warning > 0) {
        draw_boshy_text(" Plz don't shoot!", 178, 384);
    }
    if (opening_character_hint > 0) {
        var _scale = 1 + dsin(opening_age * 10) * 0.02;
        draw_sprite_ext(spr_prehistorik_penguin_hint, 0, 292, 264, _scale, _scale, 0, c_white, 1);
        draw_boshy_text("Press \"F3\" to\nchange your\ncharacter!", 296, 214);
    }
}
