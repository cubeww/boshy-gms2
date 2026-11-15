var _credits = instance_find(obj_credits, 0);
if (_credits == noone) {
    exit;
}
var _age = _credits.credits_age;
var _top = _credits.page_top;
var _player = instance_find(obj_player, 0);
var _player_y = _player != noone ? _player.y : _top + 340;
var _timer = _age * 20;

credits_effect_step(_top);
// Integer hundredths keep the wrapped frame nonnegative at the end of a loop.
var _animation_step = round(animation_rate * 100);
var _animation_finished = false;
if (_animation_step > 0 && image_number > 0) {
    animation_ticks += _animation_step;
    _animation_finished = animation_ticks >= image_number * 100;
    if (_animation_finished) {
        animation_ticks -= (image_number - animation_loop_start) * 100;
    }
    image_index = animation_ticks div 100;
}

switch (motion) {
    case CreditsMotion.PrehistorikBlock:
    case CreditsMotion.PrehistorikTrap:
        // G865–873 move the rock scene 100 pixels around its three source heights.
        y = floor(home_y + dsin(_timer / 10) * 100);
        break;

    case CreditsMotion.Kitty:
        // G874–888 animate the balloon and leave a trail of smaller hearts behind each shot.
        y = floor(3063 + dsin(_timer / 6) * 150);
        if (_age mod 50 == 0) {
            // Fusion's bullet movement uses a fixed-point direction table.
            var _velocities = [[-251, 49], [-236, 97], [-212, 142]];
            var _direction = irandom(2);
            var _velocity = _velocities[_direction];
            var _shot = credits_effect_spawn(spr_credits_actor_kitty_heart, x - 4 * image_xscale,
                y - image_yscale, _velocity[0] * 100 / 2048, _velocity[1] * 100 / 2048, 60);
            _shot.first_visible_step = 1;
            _shot.heart_direction = (17 + _direction) * 11.25;
        }
        if (_age mod 5 == 0) {
            var _count = array_length(effects);
            for (var _i = 0; _i < _count; ++_i) {
                var _heart = effects[_i];
                if (_heart.sprite == spr_credits_actor_kitty_heart) {
                    var _spark_angle = 180 - _heart.heart_direction + irandom(89) - irandom(89);
                    credits_effect_spawn(spr_credits_actor_kitty_heart_spark,
                        floor(_heart.x), floor(_heart.y), lengthdir_x(2, _spark_angle), lengthdir_y(2, _spark_angle), 40);
                }
            }
        }
        credits_kitty_hearts_step();
        break;

    case CreditsMotion.KittyPlatform:
        // G877 and G881 advance each platform's own sine phase.
        var _tilt = sprite_index == spr_credits_actor_kitty_island ? 2 : 1;
        y = floor(home_y + dsin(phase_steps * 10) * 4);
        phase_steps += 1 + irandom(1);
        var _wave = dsin(phase_steps * 5);
        x = floor(15 + _wave * 5);
        image_angle = _wave * _tilt;
        break;

    case CreditsMotion.PopStar:
    case CreditsMotion.Firebar:
        image_angle = _age mod 360;
        break;

    case CreditsMotion.Kracko:
        // G890–891 keep the emitter ready until the boss enters the expanded view.
        phase_steps = min(10, phase_steps + 1);
        if (phase_steps == 10 && credits_actor_inside_view(_top, 100)) {
            phase_steps = 0;
            var _spark_steps = ceil(sprite_get_number(spr_credits_actor_kracko_spark) * 50
                / sprite_get_speed(spr_credits_actor_kracko_spark));
            repeat (3) {
                var _angle = irandom(359);
                var _spark = credits_effect_spawn(spr_credits_actor_kracko_spark, x, y, 0, 0, _spark_steps);
                _spark.angle = _angle;
                _spark.scale = 0.5;
                _spark.additive = true;
            }
        }
        break;

    case CreditsMotion.KrackoEye:
        x = 303;
        y = 4320;
        if (_player != noone) {
            image_angle = darctan2(_player.x - x, _player.y - y) - 90;
        }
        break;

    case CreditsMotion.Rain:
        x = home_x - (_age mod 128);
        break;

    case CreditsMotion.Ryu:
        if (_age > 0 && _age mod 50 == 0) {
            sprite_index = spr_credits_actor_ryu_attack;
            image_index = 0;
            animation_ticks = 0;
            animation_rate = 0.35;
            // G895 shoots from animation 12's left-facing action point.
            var _shot = credits_effect_spawn(spr_credits_actor_ryu_hadoken, x - 49, y - 6, -6.25, 0, 100);
            _shot.first_visible_step = 1;
            _shot.left_limit = -64;
        } else if (sprite_index == spr_credits_actor_ryu_attack && _animation_finished) {
            sprite_index = spr_credits_actor_ryu;
            image_index = 0;
            animation_ticks = 0;
            animation_rate = 0.2;
        }
        break;

    case CreditsMotion.CheetahmenShot:
        if (phase_steps > 0 || (_player_y >= 5862 && _player_y <= 5956)) {
            phase_steps = min(10, phase_steps + 1);
            y = home_y - phase_steps * 20;
            image_xscale = 25;
            image_yscale = 25;
        }
        break;

    case CreditsMotion.MarioLava:
        y = floor(home_y + dsin(_timer / 15 - home_x) * 10);
        break;

    case CreditsMotion.MarioRunning:
        // G900–901 move in ten-pixel steps and wrap 700 pixels at x < −50.
        x = home_x - 10 * _age + 700 * ceil(max(0, -50 - (home_x - 10 * _age)) / 700);
        image_xscale = 3;
        image_yscale = 3;
        break;

    case CreditsMotion.WrapLeft:
        x = credits_wrap_left(home_x, _age, motion_speed, wrap_left, wrap_right);
        break;

    case CreditsMotion.ShangCloud:
    case CreditsMotion.DesertMist:
        // G1024–1029 and G1089–1091 wrap at equality before applying the current movement.
        x = (x <= wrap_left ? wrap_right : x) + motion_speed;
        break;

    case CreditsMotion.ShangBridge:
        // G1032–1039 advance and wrap the bridge spans and the pillars independently.
        x += motion_speed;
        if (x < -400) {
            x = 640;
        }
        break;

    case CreditsMotion.BiollanteVine:
        image_angle = dsin(_timer / 8) * (motion_direction > 0 ? 60 : 50) + phase_offset;
        break;

    case CreditsMotion.VvvvvvController:
        credits_vvvvvv_step(_top);
        break;

    case CreditsMotion.WarioSpike:
        x = floor(home_x + motion_direction * dsin(_age * 25 / 3) * (home_y - 8726));
        break;

    case CreditsMotion.Sonic:
        // G965 belongs to the inactive "p" group. G967 moves Sonic in the expanded window.
        if (credits_actor_inside_view(_top, 180)) {
            x = floor(home_x + dcos(_timer / 3) * 100);
            y = floor(home_y - dsin(_timer / 3) * 100);
            image_angle = (90 + _timer / 3) mod 360;
        }
        break;

    case CreditsMotion.GradiusShip:
        if (_player_y >= 10240 && _player_y < 10361) {
            phase_steps = 1;
        }
        if (phase_steps && x < 736) {
            x += 5;
        }
        image_xscale = 3;
        image_yscale = 3;
        break;

    case CreditsMotion.SkeletonHead:
    case CreditsMotion.SkeletonArm:
        // G1001 follows the leg frame's action point through the assembled skeleton.
        var _legs_frame = floor(_age * 0.15) mod 6;
        var _legs_x = [0, 0, 1, 1, 1, 0];
        var _legs_y = [1, 4, 5, 9, 5, 4];
        x = (motion == CreditsMotion.SkeletonHead ? 478 : home_x) + _legs_x[_legs_frame];
        y = (motion == CreditsMotion.SkeletonHead ? 11078 : home_y) + _legs_y[_legs_frame];
        if (motion == CreditsMotion.SkeletonHead && credits_actor_inside_view(_top, 190)) {
            var _head_frame = floor(image_index) mod 4;
            var _muzzle_x = [-44, -42, -40, -41];
            var _muzzle_y = [-103, -103, -104, -105];
            repeat (3) {
                var _angle = 180 + irandom(49) - irandom(49);
                var _shard = credits_effect_spawn(spr_credits_actor_skeleton_king_shard,
                    x + _muzzle_x[_head_frame], y + _muzzle_y[_head_frame],
                    lengthdir_x(25, _angle), lengthdir_y(25, _angle), 45);
                _shard.angle = _angle;
                _shard.gravity = 0.01;
                _shard.window_margin = 16;
            }
        }
        break;

    case CreditsMotion.CastleFog:
    case CreditsMotion.Drift:
        x = home_x + (_age mod 32);
        y = home_y + (_age mod 32);
        break;

    case CreditsMotion.MilonClown:
        // G1008–1009 use the Milon vignette's solid ledge on the scenery layer.
        if (bounce_platform != -1 && bbox_bottom >= layer_sprite_get_y(bounce_platform)) {
            motion_speed = -8;
        }
        y = floor(y + motion_speed);
        motion_speed += 0.5;
        break;

    case CreditsMotion.KidIcarusFloor:
        // G1041 starts gravity at frame 7, which is also the source clip's loop point.
        if (image_index >= 7) {
            y = floor(y + motion_speed);
            motion_speed += 0.5;
        }
        // This authored floor prop is outside the viewport and never reaches a Layer 1 obstacle.
        if (y >= room_height) {
            instance_destroy();
        }
        break;

    case CreditsMotion.KidIcarusPlatform:
        // G1044 reacts to a fresh contact before G1043 applies this step's gravity.
        // Each authored platform's bottom row meets its Layer 1 backdrop directly.
        var _touching = bounce_platform != -1 && y > layer_sprite_get_y(bounce_platform);
        if (_touching && !touching_backdrop) {
            motion_speed = -10 - irandom(2);
        }
        touching_backdrop = _touching;
        y = floor(y + motion_speed);
        motion_speed += 0.5;
        break;

    case CreditsMotion.NinjaTurret:
        // G1051, G1065, G1067 and G1069 fire before the view-qualified counter advances.
        if (phase_steps >= shot_interval) {
            var _shot = credits_effect_spawn(spr_credits_actor_ninja_gaiden_shot, x + 13, y - 3, -10, 0, 80);
            _shot.first_visible_step = 1;
            _shot.left_limit = -64;
            phase_steps = 0;
        }
        if (credits_actor_inside_view(_top, 0)) {
            ++phase_steps;
            image_index = min(image_number - 1, floor(phase_steps * image_number / shot_interval));
        }
        break;

    case CreditsMotion.MissingNo:
        x = floor(x + (540 - x) * 0.2 + 1);
        y = floor(y + (16781 - y) * 0.2 + 1 + dsin(_timer / 3) * 4);
        image_xscale = 4;
        image_yscale = 4;
        // G1082 fades and expands each copy without rotating it. Recover
        // particles track the current position as their radius shrinks.
        for (var _i = 0; _i < array_length(effects); ++_i) {
            var _effect = effects[_i];
            if (_effect.sprite == spr_credits_actor_missingno_trail) {
                _effect.scale = 4 + _effect.steps * 0.1;
                _effect.alpha = max(0, 1 - _effect.steps * 15 / 128);
            } else {
                var _orbit_age = _effect.steps - 1;
                var _radius = 100 - _orbit_age * 3;
                var _angle = _effect.orbit_start + _orbit_age * 5;
                _effect.x = floor(x + lengthdir_x(_radius, _angle));
                _effect.y = floor(y + lengthdir_y(_radius, _angle));
            }
        }
        if (_age > 0 && _timer div 50 > (_timer - 20) div 50) {
            var _trail = credits_effect_spawn(spr_credits_actor_missingno_trail, x, y, 0, 0, 25);
            _trail.scale = 4;
        }
        // G1086–1087 start ten recovery particles every half second.
        if (_age > 0 && _age mod 25 == 0) {
            for (var _index = 0; _index < 10; ++_index) {
                var _particle = credits_effect_spawn(spr_missingno_recover, x, y, 0, 0, 34);
                _particle.orbit_start = _index * 35;
                _particle.scale = 2;
            }
        }
        break;

    case CreditsMotion.Solgryn:
        if (_player_y >= 18927 && _player_y < 19470) {
            y += 3;
            image_angle += 1;
        }
        break;
}
