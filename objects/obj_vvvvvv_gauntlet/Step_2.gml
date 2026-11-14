var _player = instance_find(obj_player, 0);
if (_player != noone && !_player.dead && !_player.input_locked) {
    // Groups 955–956 resolve the rails before updating the timer or moving shots.
    var _gravity = -_player.gravity_direction;
    var _rail_hit = false;
    with (obj_vvvvvv_gauntlet_line) {
        if (gauntlet_floor == (_gravity < 0) && _player.boshy_mask_meeting(id)) {
            flash_steps = 0;
            sprite_index = spr_vvvvvv_gauntlet_line_flash;
            image_index = 0;
            _rail_hit = true;
        }
    }
    if (_rail_hit) {
        _player.set_gravity_direction(_gravity, false);
        audio_play_sound(snd_vvvvvv_gauntlet_flip, 1, false);
    }
}

if (gauntlet_complete) {
    exit;
}

// Group 957 rotates the existing projectiles before the volley is created.
with (obj_vvvvvv_gauntlet_projectile) {
    image_angle = (image_angle + 10) mod 360;
}

// G958 selects the volley before G959–960 update the countdown and its clock.
var _volley = undefined;
if (gauntlet_volley_steps == 40) {
    _volley = gauntlet_volleys[irandom(array_length(gauntlet_volleys) - 1)];
    gauntlet_volley_steps = 0;
}

var _camera = view_camera[0];
var _page_left = camera_get_view_x(_camera);
var _page_top = camera_get_view_y(_camera);
// Active 60 must be within the current viewport extended by eight pixels.
if (x <= _page_left - 8 || x + 16 >= _page_left + camera_get_view_width(_camera) + 8
    || y - 8 <= _page_top - 8 || y + 8 >= _page_top + camera_get_view_height(_camera) + 8) {
    gauntlet_volley_steps = 0;
    gauntlet_remaining = gauntlet_duration;
} else if (_player != noone && !_player.dead) {
    ++gauntlet_volley_steps;
    gauntlet_started = true;
    --gauntlet_remaining;
}

if (!is_undefined(_volley)) {
    if (_volley[0] < 0) {
        gauntlet_volley_steps = _volley[0];
    }
    var _direction = _volley[1];
    var _offsets = _volley[2];
    for (var _i = 0; _i < array_length(_offsets); ++_i) {
        var _offset = _offsets[_i];
        // The original volleys draw over the gravity rails.
        instance_create_depth(x + _offset[0], y + _offset[1], depth - 1, obj_vvvvvv_gauntlet_projectile, {
            travel_direction: _direction
        });
    }
}

// Groups 987–988 move every projectile, including those created this step.
with (obj_vvvvvv_gauntlet_projectile) {
    x += travel_direction * 3;
    if (x < -32 || x > room_width + 32) {
        instance_destroy();
    }
}

if (gauntlet_remaining == 0) {
    gauntlet_complete = true;
    with (obj_vvvvvv_gauntlet_line) {
        if (gauntlet_floor) {
            instance_destroy();
        }
    }
    with (obj_vvvvvv_gauntlet_projectile) {
        instance_destroy();
    }
}
