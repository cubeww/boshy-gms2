enum CreditsMotion {
    None,
    PrehistorikBlock,
    PrehistorikTrap,
    Kitty,
    KittyPlatform,
    PopStar,
    Kracko,
    KrackoEye,
    Rain,
    Ryu,
    CheetahmenShot,
    MarioLava,
    MarioRunning,
    WrapLeft,
    BiollanteVine,
    VvvvvvController,
    WarioSpike,
    Sonic,
    GradiusShip,
    SkeletonHead,
    SkeletonArm,
    CastleFog,
    Drift,
    MilonClown,
    NinjaTurret,
    MissingNo,
    MissingNoHealth,
    Desert,
    Solgryn,
    Firebar,
    ShangCloud,
    ShangBridge
}

function credits_near_view(_y, _top, _margin) {
    return _y >= _top - _margin && _y < _top + 480 + _margin;
}

function credits_actor_inside_view(_top, _margin) {
    return credits_sprite_inside_view(sprite_index, x, y, image_xscale, image_yscale,
        image_angle, _top, _margin);
}

function credits_sprite_inside_view(_sprite, _x, _y, _xscale, _yscale, _angle, _top, _margin) {
    // Fusion's negated Near Window Edge condition tests the complete rendered image.
    var _left = -sprite_get_xoffset(_sprite) * _xscale;
    var _top_offset = -sprite_get_yoffset(_sprite) * _yscale;
    var _right = _left + sprite_get_width(_sprite) * _xscale;
    var _bottom = _top_offset + sprite_get_height(_sprite) * _yscale;
    var _cos = dcos(_angle);
    var _sin = dsin(_angle);
    var _min_x = min(_left * _cos, _right * _cos) + min(_top_offset * _sin, _bottom * _sin);
    var _max_x = max(_left * _cos, _right * _cos) + max(_top_offset * _sin, _bottom * _sin);
    var _min_y = min(-_left * _sin, -_right * _sin) + min(_top_offset * _cos, _bottom * _cos);
    var _max_y = max(-_left * _sin, -_right * _sin) + max(_top_offset * _cos, _bottom * _cos);
    return _x + _min_x > -_margin && _x + _max_x < room_width + _margin
        && _y + _min_y > _top - _margin && _y + _max_y < _top + 480 + _margin;
}

function credits_wrap_left(_start, _age, _speed, _left, _right) {
    var _position = _start + _age * _speed;
    if (_position >= _left) {
        return _position;
    }
    var _period = _right - _left;
    return _position + ceil((_left - _position) / _period) * _period;
}

function credits_draw_actor_panorama(_top, _zoom) {
    // The importer applies the same native Panorama mapping to the static scenery.
    // Capture only the animated layer content in the patch, with straight alpha.
    static _uniform = shader_is_compiled(shd_credits_panorama)
        ? shader_get_uniform(shd_credits_panorama, "u_zoom") : -1;
    if (_uniform == -1) {
        return false;
    }
    if (!surface_exists(panorama_surface)) {
        panorama_surface = surface_create(640, 480);
    }
    if (!surface_exists(panorama_surface) || !surface_set_target(panorama_surface)) {
        return false;
    }
    var _blend = gpu_get_blendenable();
    gpu_set_blendenable(false);
    draw_clear_alpha(c_black, 0);
    draw_sprite_ext(sprite_index, image_index, x, y - _top, image_xscale, image_yscale,
        image_angle, image_blend, image_alpha);
    surface_reset_target();
    gpu_set_blendenable(true);
    shader_set(shd_credits_panorama);
    shader_set_uniform_f(_uniform, _zoom);
    draw_surface(panorama_surface, 0, _top);
    shader_reset();
    gpu_set_blendenable(_blend);
    return true;
}

function credits_effect_spawn(_sprite, _x, _y, _dx, _dy, _ttl, _angular_speed = 0) {
    var _effect = {
        sprite: _sprite,
        x: _x,
        y: _y,
        dx: _dx,
        dy: _dy,
        ttl: _ttl,
        steps: 0,
        angle: 0,
        spin: _angular_speed,
        scale: 1,
        alpha: 1,
        additive: false,
        gravity: 0,
        window_margin: -1
    };
    array_push(effects, _effect);
    return _effect;
}

function credits_effect_step(_top) {
    for (var _i = array_length(effects) - 1; _i >= 0; --_i) {
        var _effect = effects[_i];
        // G1003 culls Skeleton King shards before G1007 updates the positions.
        if (_effect.window_margin >= 0 && (_effect.x < 0
            || !credits_sprite_inside_view(_effect.sprite, _effect.x, _effect.y,
                _effect.scale, _effect.scale, _effect.angle, _top, _effect.window_margin))) {
            array_delete(effects, _i, 1);
            continue;
        }
        ++_effect.steps;
        _effect.x += _effect.dx;
        _effect.y += _effect.dy;
        _effect.dy += _effect.gravity * _effect.steps;
        _effect.angle += _effect.spin;
        if (_effect.sprite == spr_credits_actor_kitty_heart_spark) {
            _effect.angle += 5 + irandom(14);
            _effect.scale *= 0.98;
        }
        if (_effect.steps >= _effect.ttl || _effect.x < -320 || _effect.x > 960) {
            array_delete(effects, _i, 1);
        }
    }
}

function credits_effect_draw(_top) {
    for (var _i = 0; _i < array_length(effects); ++_i) {
        var _effect = effects[_i];
        if (!credits_near_view(_effect.y, _top, 64)) {
            continue;
        }
        var _frame = floor(_effect.steps * sprite_get_speed(_effect.sprite) / 50);
        if (_effect.additive) {
            gpu_set_blendmode(bm_add);
        }
        draw_sprite_ext(_effect.sprite, _frame mod sprite_get_number(_effect.sprite),
                       floor(_effect.x), floor(_effect.y), _effect.scale, _effect.scale,
                       _effect.angle, c_white, _effect.alpha);
        if (_effect.additive) {
            gpu_set_blendmode(bm_normal);
        }
    }
}
