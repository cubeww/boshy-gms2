var _viewport = get_viewport_rectangle();
if (is_undefined(_viewport)) {
    chest_view_overlays = [];
    exit;
}

draw_clear(c_black);
if (!surface_exists(application_surface)) {
    chest_view_overlays = [];
    exit;
}

if (surface_get_width(application_surface) != render_width
    || surface_get_height(application_surface) != render_height) {
    surface_resize(application_surface, render_width, render_height);
}

var _blend_enabled = gpu_get_blendenable();
gpu_set_blendenable(false);

var _scene_cos = 1;
var _scene_sin = 0;
var _scene_offset_x = 0;
var _scene_offset_y = 0;
var _scene_mirrored = game_view_mirrored() && room != rm_title;
var _scene_flipped = false;
var _crop = chest_view_uniform == -1 ? undefined : chest_view_crop;
var _path_exit = room == rm_final_path ? instance_find(obj_final_path_exit, 0) : noone;
var _solgryn = room == rm_solgryn ? instance_find(obj_solgryn, 0) : noone;
var _path_drawn = _path_exit != noone && _path_exit.draw_final_path_scene(
    application_surface, _viewport.left, _viewport.top, _viewport.width, _viewport.height);
if (_solgryn != noone && _solgryn.solgryn_history_alpha > 0) {
    _solgryn.solgryn_draw_history(application_surface, _viewport, _scene_mirrored);
} else if (!_path_drawn) {
    var _mosaic = teleport_mosaic_uniform != -1 && teleport_mosaic_columns > 0 && teleport_mosaic_rows > 0;
    var _blur = directional_blur_uniform != -1 && (directional_blur_x != 0 || directional_blur_y != 0
        || scene_shake_x != 0 || scene_shake_y != 0);
    var _rotate = screen_rotation_uniform != -1 && screen_rotation != 0;
    var _desert = room == rm_desert ? instance_find(obj_desert, 0) : noone;
    var _heat = desert_heat_phase_uniform != -1 && _desert != noone;
    var _effects = _mosaic || _blur || _rotate || _heat;
    var _crop_with_effects = !is_undefined(_crop) && _effects;
    if (_crop_with_effects) {
        if (!surface_exists(chest_view_effect_surface)) {
            chest_view_effect_surface = surface_create(render_width, render_height);
        }
        _crop_with_effects = surface_exists(chest_view_effect_surface);
        if (_crop_with_effects) {
            surface_set_target(chest_view_effect_surface);
        } else {
            _crop = undefined;
        }
    }
    if (_mosaic && !(_solgryn != noone && _blur)) {
        shader_set(shd_teleport_mosaic);
        shader_set_uniform_f(teleport_mosaic_uniform, teleport_mosaic_columns, teleport_mosaic_rows);
    } else if (_blur) {
        _scene_cos = _rotate ? dcos(screen_rotation) : 1;
        _scene_sin = _rotate ? dsin(screen_rotation) : 0;
        _scene_offset_x = scene_shake_x;
        _scene_offset_y = scene_shake_y;
        shader_set(shd_directional_blur);
        shader_set_uniform_f(directional_blur_uniform, directional_blur_x, directional_blur_y, render_width, render_height);
        shader_set_uniform_f(directional_blur_rotation_uniform, _scene_cos, _scene_sin);
        shader_set_uniform_f(directional_blur_offset_uniform, _scene_offset_x / render_width, _scene_offset_y / render_height);
    } else if (_rotate) {
        _scene_cos = dcos(screen_rotation);
        _scene_sin = dsin(screen_rotation);
        shader_set(shd_view_rotation);
        shader_set_uniform_f(screen_rotation_uniform, _scene_cos, _scene_sin, render_width, render_height);
    } else if (_heat) {
        shader_set(shd_desert_heat);
        shader_set_uniform_f(desert_heat_phase_uniform, _desert.stage_steps * 0.02);
        shader_set_uniform_f(desert_heat_size_uniform, render_width, render_height);
    }
    _scene_flipped = flip_view_y;
    if (_crop_with_effects) {
        draw_surface(application_surface, 0, 0);
        shader_reset();
        surface_reset_target();
    }

    var _source = application_surface;
    if (!is_undefined(_crop)) {
        _source = _crop_with_effects ? chest_view_effect_surface : application_surface;
        shader_set(shd_chest_view);
        shader_set_uniform_f(chest_view_uniform, _crop.left, _crop.top, _crop.width, _crop.height);
        shader_set_uniform_f(chest_view_size_uniform, render_width, render_height);
    }
    draw_scene_surface(_source, _viewport, _scene_mirrored, _scene_flipped);
    if (_effects || !is_undefined(_crop)) {
        shader_reset();
    }
}
gpu_set_blendenable(_blend_enabled);
chest_draw_overlays(id, _viewport);

if (room == rm_biollante) {
    with (obj_biollante) {
        biollante_draw_hud(_viewport);
    }
} else if (room == rm_sanicz) {
    with (obj_sanicz) {
        sanicz_draw_hud(_viewport);
    }
} else if (room == rm_skeleton_king) {
    with (obj_skeleton_king) {
        skeleton_king_draw_hud(_viewport);
    }
} else if (room == rm_missingno) {
    with (obj_missingno) {
        missingno_victory_draw(_viewport);
    }
} else if (_solgryn != noone && !_solgryn.solgryn_hud_in_scene()) {
    var _hud_scale = _viewport.width / render_width;
    _solgryn.draw_solgryn_health_bar(_viewport.left, _viewport.top, _hud_scale);
    _solgryn.draw_solgryn_readouts(_viewport.left, _viewport.top, _hud_scale);
    with (_solgryn) {
        solgryn_victory_draw(_viewport);
    }
}

if (_scene_mirrored) {
    var _overlay_scale = _viewport.width / render_width;
    draw_gameplay_readouts(_viewport.left, _viewport.top, _overlay_scale);
    with (obj_game_over) {
        draw_death_panel(_viewport.left, _viewport.top, _overlay_scale);
    }
}

if (array_length(achievement_notifications) > 0 && achievement_notification_age > 0) {
    var _scale = _viewport.width / render_width;
    var _alpha = 1 - max(0, achievement_notification_age - 200) / 26;
    draw_sprite_ext(spr_tutorial_achievement_banner, 0,
        _viewport.left + 434 * _scale, _viewport.top + 7 * _scale, _scale, _scale, 0, c_white, _alpha);
    draw_sprite_part_ext(spr_trophy_icon, 1, 0, 6, 32, 32,
        _viewport.left + 440 * _scale, _viewport.top + 13 * _scale, _scale, _scale, c_white, _alpha);
    var _lines = string_split(achievement_notifications[0], "\n");
    var _letters = achievement_notification_age;
    var _text_y = array_length(_lines) == 1 ? 22 : 16;
    for (var _i = 0; _i < array_length(_lines) && _letters > 0; ++_i) {
        var _line = _lines[_i];
        var _length = string_length(_line);
        draw_boshy_text(string_copy(_line, 1, _letters),
            _viewport.left + (628 - _length * 8) * _scale,
            _viewport.top + (_text_y + _i * 12) * _scale, _alpha, _scale);
        _letters -= _length;
    }
}

if (!global.debug_overlay_visible) {
    exit;
}

var _lines = ["Room: " + room_get_name(room) + " (" + string(room_width) + " x " + string(room_height) + ")"];
var _player = instance_find(obj_player, 0);
var _gradius_ship = room == rm_gradius ? instance_find(obj_gradius_player, 0) : noone;
if (_player != noone) {
    array_push(_lines, "Player: X " + string(_player.x) + "  Y " + string(_player.y));
    array_push(_lines, "Speed: H " + string_format(_player.hsp, 0, 2)
        + "  V " + string_format(_player.vsp, 0, 2) + " px/step");
    array_push(_lines, "Ground: " + (_player.grounded ? "yes" : "no")
        + "  Air jump: " + (_player.air_jump_available ? "ready" : "spent")
        + "  Input: " + (_player.input_locked ? "locked" : "free"));
} else if (_gradius_ship != noone && !_gradius_ship.dead) {
    array_push(_lines, "Ship: X " + string(_gradius_ship.x) + "  Y " + string(_gradius_ship.y));
} else if (!is_undefined(debug_death_position)) {
    array_push(_lines, "Death: X " + string(debug_death_position.x) + "  Y " + string(debug_death_position.y));
} else {
    array_push(_lines, "Player: No active instance");
}

var _camera = view_enabled && view_visible[0] ? view_camera[0] : -1;
var _view_x = _camera == -1 ? 0 : camera_get_view_x(_camera);
var _view_y = _camera == -1 ? 0 : camera_get_view_y(_camera);
var _view_width = _camera == -1 ? room_width : camera_get_view_width(_camera);
var _view_height = _camera == -1 ? room_height : camera_get_view_height(_camera);
if (_camera != -1) {
    array_push(_lines, "Camera: X " + string(_view_x) + "  Y " + string(_view_y));
}

// Map through the fitted window and the center sample of the scene compositor.
var _mouse_x = (window_mouse_get_x() - _viewport.left) * render_width / _viewport.width;
var _mouse_y = (window_mouse_get_y() - _viewport.top) * render_height / _viewport.height;
var _mouse_text = "Outside viewport";
var _center_x = render_width * 0.5;
var _center_y = render_height * 0.5;
if (_mouse_x >= 0 && _mouse_x < render_width && _mouse_y >= 0 && _mouse_y < render_height) {
    _mouse_x = floor(_mouse_x) + 0.5;
    _mouse_y = floor(_mouse_y) + 0.5;
    if (_scene_mirrored) {
        _mouse_x = render_width - _mouse_x;
    }
    if (_scene_flipped) {
        _mouse_y = render_height - _mouse_y;
    }
    if (!is_undefined(_crop)) {
        var _sample = chest_view_sample(_crop, _mouse_x, _mouse_y, render_width, render_height);
        _mouse_x = _sample.x;
        _mouse_y = _sample.y;
    }
    _mouse_x += _scene_offset_x;
    _mouse_y += _scene_offset_y;
    if (_mouse_x >= 0 && _mouse_x < render_width && _mouse_y >= 0 && _mouse_y < render_height) {
        var _dx = _mouse_x - _center_x;
        var _dy = _mouse_y - _center_y;
        var _rotated_x = _center_x + _scene_cos * _dx - _scene_sin * _dy;
        var _rotated_y = _center_y + _scene_sin * _dx + _scene_cos * _dy;
        if (_rotated_x >= 0 && _rotated_x < render_width && _rotated_y >= 0 && _rotated_y < render_height) {
            _mouse_x = _rotated_x;
            _mouse_y = _rotated_y;
        }
        var _room_x = floor(_view_x + _mouse_x * _view_width / render_width);
        var _room_y = floor(_view_y + _mouse_y * _view_height / render_height);
        _mouse_text = "X " + string(_room_x) + "  Y " + string(_room_y);
    }
}
array_push(_lines, "Mouse: " + _mouse_text);

if (gameplay_room) {
    var _checkpoint_run = global.run;
    if (!_checkpoint_run.has_checkpoint && !is_undefined(_checkpoint_run.restart_run)) {
        _checkpoint_run = _checkpoint_run.restart_run;
    }
    var _checkpoint = _checkpoint_run.has_checkpoint
        ? "X " + string(_checkpoint_run.checkpoint_x) + "  Y " + string(_checkpoint_run.checkpoint_y)
        : "Entrance";
    if (_checkpoint_run.room_id != room) {
        _checkpoint = room_get_name(_checkpoint_run.room_id) + "  " + _checkpoint;
    }
    array_push(_lines, "Checkpoint: " + _checkpoint);
}
array_push(_lines, "FPS: " + string(fps));

// Draw in the fitted viewport after scene effects so the coordinates remain legible.
var _scale = _viewport.width / render_width;
var _line_count = array_length(_lines);
var _height = _line_count * 12 + 12;
var _text_columns = 0;
for (var _i = 0; _i < _line_count; ++_i) {
    _text_columns = max(_text_columns, string_length(_lines[_i]));
}

var _width = _text_columns * 8 + 12;
var _left = 8;
var _top = 8;
var _actor = _player;
if (_actor == noone && _gradius_ship != noone && !_gradius_ship.dead) {
    _actor = _gradius_ship;
}
if (_actor != noone) {
    // Project the player into the displayed view before choosing the free corner.
    var _dx = (_actor.x - _view_x) * render_width / _view_width - _center_x;
    var _dy = (_actor.y - _view_y) * render_height / _view_height - _center_y;
    var _actor_x = _center_x + _scene_cos * _dx + _scene_sin * _dy;
    var _actor_y = _center_y - _scene_sin * _dx + _scene_cos * _dy;
    if (_actor_x < 0 || _actor_x >= render_width || _actor_y < 0 || _actor_y >= render_height) {
        _actor_x = _center_x + _dx;
        _actor_y = _center_y + _dy;
    }
    _actor_x -= _scene_offset_x;
    _actor_y -= _scene_offset_y;
    if (!is_undefined(_crop)) {
        _actor_x = (_actor_x - _crop.left) * render_width / _crop.width;
        _actor_y = (_actor_y - _crop.top) * render_height / _crop.height;
    }
    if (_scene_mirrored) {
        _actor_x = render_width - _actor_x;
    }
    if (_scene_flipped) {
        _actor_y = render_height - _actor_y;
    }
    if (_actor_x < _center_x) {
        _left = render_width - _width - 8;
    }

    var _sprite = _actor.sprite_index;
    var _sprite_scale = max(abs(_actor.image_xscale), abs(_actor.image_yscale));
    if (_player != noone) {
        _sprite = _player.visual_facing() < 0 ? _player.character.sprite_left : _player.character.sprite_right;
        if (struct_exists(_player.character, "custom")) {
            var _frames = _player.character.poses[_player.pose].frames;
            var _frame = _frames[clamp(floor(_player.pose_frame), 0, array_length(_frames) - 1)];
            _sprite = game_character_sprite(_player.character, _player.pose, _frame, _player.visual_facing()).sprite;
        }
        if (room != rm_missingno) {
            _sprite_scale = 1;
        }
    } else {
        _sprite_scale *= 2;
    }
    var _ox = sprite_get_xoffset(_sprite);
    var _oy = sprite_get_yoffset(_sprite);
    var _radius = point_distance(0, 0, max(_ox, sprite_get_width(_sprite) - _ox),
        max(_oy, sprite_get_height(_sprite) - _oy)) * _sprite_scale;
    _radius *= max(render_width / _view_width, render_height / _view_height);
    if (!is_undefined(_crop)) {
        _radius *= max(render_width / _crop.width, render_height / _crop.height);
    }
    if (_actor_x + _radius >= _left && _actor_x - _radius <= _left + _width
        && _actor_y + _radius >= _top && _actor_y - _radius <= _top + _height) {
        _top = render_height - _height - 8;
    }
}
_left = _viewport.left + _left * _scale;
_top = _viewport.top + _top * _scale;

var _previous_alpha = draw_get_alpha();
draw_set_alpha(0.85);
draw_rectangle_color(_left, _top, _left + _width * _scale, _top + _height * _scale,
    c_black, c_black, c_black, c_black, false);
draw_set_alpha(_previous_alpha);
for (var _i = 0; _i < _line_count; ++_i) {
    draw_boshy_text(_lines[_i], _left + 6 * _scale, _top + (6 + _i * 12) * _scale, 1, _scale);
}
