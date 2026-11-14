function prehistorik_cave_setup() {
    cave_shaft_spike = inst_prehistorik_cave_shaft_spike;
    cave_chaser = inst_prehistorik_cave_chaser;
    cave_spider = inst_prehistorik_cave_spider;
    cave_spider_age = -1;
    cave_steps = 0;
    cave_chase_voice = -1;
    cave_spider_voice = -1;

    cave_web_spider = inst_prehistorik_web_spider;
    cave_web_spider_warning = inst_prehistorik_web_warning;
    cave_web_spider_wake_steps = -1;
    cave_web_spider_sound = -1;

    cave_crumble_platform = inst_prehistorik_cave_crumble_platform;
    cave_falling_ledges = [inst_prehistorik_cave_falling_ledge_1, inst_prehistorik_cave_falling_ledge_2];

    // The rail is a backtracking shortcut powered by the Metal Gear collectible.
    cave_rail_enabled = game_has_item("Metal Gear");
    cave_rail = inst_prehistorik_cave_rail;
    cave_rail_end = inst_prehistorik_cave_rail_end;
    cave_rail_end.image_index = cave_rail_enabled ? 1 : 0;
}

function prehistorik_cave_step(_player) {
    ++cave_steps;

    // Groups 700–701. Entering the shaft's lower trigger releases the overhead spike.
    if (instance_exists(cave_shaft_spike)) {
        if (_player != noone && point_in_rectangle(_player.x, _player.y, 156, 1012, 206, 1156)) {
            cave_shaft_spike.falling = true;
        }
        if (cave_shaft_spike.falling) {
            cave_shaft_spike.y += 15;
            if (cave_shaft_spike.y >= 1920) {
                instance_destroy(cave_shaft_spike);
            }
        }
    }

    prehistorik_cave_step_chaser(_player);
    prehistorik_cave_step_spider(_player);
    prehistorik_cave_step_web_spider();
    prehistorik_cave_step_platforms(_player);

    // The moving hazards have advanced since the player's movement event.
    if (_player != noone && _player.touching_hazard()) {
        _player.die();
    }
}

function prehistorik_cave_step_chaser(_player) {
    if (!instance_exists(cave_chaser)) {
        return;
    }

    // Groups 736–745. The chase follows the grass trail and ends at the exit climb.
    var _chaser = cave_chaser;
    _chaser.image_index = (_chaser.image_index + 0.25) mod _chaser.image_number;
    if (_chaser.phase == "waiting" && _player != noone
        && point_in_rectangle(_player.x, _player.y, 818, 1003, 1371, 1364)) {
        _chaser.phase = "chase";
        cave_chase_voice = play_boshy_voice(snd_prehistorik_run_like_the_wind);
    }

    if (_chaser.phase == "chase") {
        if (_player == noone) {
            _chaser.x -= 5;
            _chaser.image_angle += 15;
            return;
        }

        _chaser.x += 3;
        _chaser.y = floor(_chaser.y + (_player.y - _chaser.y) / 10);
        _chaser.image_angle = darctan2(_chaser.x - _player.x, _chaser.y - _player.y) + 90;
        if (_chaser.x > _player.x) {
            _chaser.x = _player.x;
            _chaser.y = _player.y;
        }
        if (_chaser.x >= 3500) {
            _chaser.phase = "swell";
        }
    }

    if (_chaser.phase == "swell") {
        _chaser.image_xscale += 0.1;
        _chaser.image_yscale = _chaser.image_xscale;
        ++_chaser.swell_steps;
        if (_chaser.swell_steps == 50) {
            var _blood_count = floor(360 * global.settings.blood_intensity / 100);
            repeat (_blood_count) {
                instance_create_depth(_chaser.x, _chaser.y, _chaser.depth - 1, obj_blood);
            }
            audio_play_sound(snd_death_impact, 1, false);
            instance_destroy(_chaser);
        }
    }
}

function prehistorik_cave_step_spider(_player) {
    // Groups 826–832. The spider drops, retreats, then dives once more.
    if (cave_spider_age < 0 && _player != noone
        && point_in_rectangle(_player.x, _player.y, 951, 748, 1010, 1392)) {
        cave_spider_age = 0;
        cave_spider.image_xscale = 2;
        cave_spider.image_yscale = 2;
        cave_spider_voice = audio_play_sound(snd_prehistorik_spider_scream, 1, false);
    }
    if (cave_spider_age < 0 || cave_spider_age >= 100) {
        return;
    }

    var _milliseconds = cave_steps * 1000 / game_get_speed(gamespeed_fps);
    if (cave_spider_age < 35) {
        cave_spider.y += 10;
        cave_spider.image_angle = dsin(_milliseconds) * 20;
    }
    ++cave_spider_age;
    if (cave_spider_age >= 35 && cave_spider_age <= 70) {
        cave_spider.y -= 20;
        cave_spider.image_angle = dsin(_milliseconds / 3) * 10;
    }
    if (cave_spider_age == 70) {
        audio_stop_sound(cave_spider_voice);
        cave_spider_voice = audio_play_sound(snd_prehistorik_spider_scream, 1, false);
    }
    if (cave_spider_age >= 70 && cave_spider_age < 100) {
        cave_spider.y += 40;
        cave_spider.image_angle = 0;
    }
}

function prehistorik_cave_fall(_piece) {
    _piece.y = floor(_piece.y + _piece.fall_speed);
    _piece.fall_speed += 0.5;
    _piece.image_angle += 1;
}

function prehistorik_cave_on_platform(_player, _platform) {
    return _player != noone && _player.probe_overlaps(_player.down_probe, _platform);
}

function prehistorik_cave_step_platforms(_player) {
    // Groups 746–749 and 977–978. Two scenery ledges and one walkable ledge fall.
    for (var _i = 0; _i < array_length(cave_falling_ledges); ++_i) {
        var _ledge = cave_falling_ledges[_i];
        if (!instance_exists(_ledge)) {
            continue;
        }
        if (_player != noone && _player.x >= _ledge.x - 16 && _player.y >= _ledge.y - 200) {
            _ledge.falling = true;
        }
        if (_ledge.falling) {
            prehistorik_cave_fall(_ledge);
            if (_ledge.y >= 1920) {
                instance_destroy(_ledge);
            }
        }
    }

    if (instance_exists(cave_crumble_platform)) {
        if (prehistorik_cave_on_platform(_player, cave_crumble_platform)) {
            cave_crumble_platform.falling = true;
        }
        if (cave_crumble_platform.falling) {
            prehistorik_cave_fall(cave_crumble_platform);
            if (cave_crumble_platform.y >= 1920) {
                instance_destroy(cave_crumble_platform);
            }
        }
    }

    if (!cave_rail_enabled) {
        return;
    }
    var _rail = cave_rail;
    var _riding = prehistorik_cave_on_platform(_player, _rail);
    var _next_x = _rail.x + _rail.rail_direction;
    var _blocked = false;
    with (_rail) {
        _blocked = place_meeting(_next_x, y, obj_player_backdrop);
    }
    if (_blocked || _next_x < _rail.xstart || _next_x > cave_rail_end.x) {
        _rail.rail_direction = -_rail.rail_direction;
        return;
    }
    _rail.x = _next_x;
    if (_riding) {
        _player.x += _rail.rail_direction;
    }
}

function prehistorik_cave_wake_web_spider() {
    // Groups 833–834. The first hit wakes the spider and reveals its warning.
    cave_web_spider_wake_steps = 0;
    cave_web_spider_warning.visible = true;
    cave_web_spider_sound = audio_play_sound(snd_prehistorik_web_spider_wake, 1, false);
    if (game_trophy_unlock("Raider of the lost spider")) {
        prehistorik_show_trophy("Raider of the lost spider!");
    }
}

function prehistorik_cave_step_web_spider() {
    if (cave_web_spider_wake_steps < 0 || !instance_exists(cave_web_spider)) {
        return;
    }
    // Groups 836–837. The spider waits before growing and charging left.
    if (cave_web_spider_wake_steps <= 250) {
        ++cave_web_spider_wake_steps;
        return;
    }
    cave_web_spider.x -= 30;
    cave_web_spider.image_xscale = 2;
    cave_web_spider.image_yscale = 2;
    if (cave_web_spider.bbox_right < 0) {
        instance_destroy(cave_web_spider);
    }
}

function prehistorik_cave_cleanup() {
    if (cave_chase_voice != -1) {
        audio_stop_sound(cave_chase_voice);
    }
    if (cave_spider_voice != -1) {
        audio_stop_sound(cave_spider_voice);
    }
    if (cave_web_spider_sound != -1) {
        audio_stop_sound(cave_web_spider_sound);
    }
}
