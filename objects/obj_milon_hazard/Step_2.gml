switch (hazard_kind) {
    case MilonHazard.Blade:
        // G714–715 keep the blade moving after the first shot.
        if (armed) {
            x += 20;
            image_angle = (image_angle + 15) mod 360;
            if (bbox_left >= room_width + 480) {
                instance_destroy();
            }
        }
        break;

    case MilonHazard.HomingOrb:
        // G734–799 first move with the stored heading, then aim for the next step.
        x = floor(travel_x);
        y = floor(travel_y);
        travel_x += dcos(image_angle) * travel_speed;
        travel_y -= dsin(image_angle) * travel_speed;
        var _target = instance_find(obj_player, 0);
        if (_target != noone) {
            var _dx = x - _target.x;
            var _dy = y - _target.y;
            var _angle = darctan2(_dx, _dy) + 90;
            image_angle = _angle - frac(_angle);
            travel_speed = abs(_dx) + abs(_dy) < 90 ? 2 : 0;
        }
        break;

    case MilonHazard.Hopper:
        var _player = instance_find(obj_player, 0);
        // G809–818 let the hopper jump through the arena until it reaches x7785.
        if (armed) {
            y = floor(y + vertical_speed);
            vertical_speed += 0.5;
        }
        if (place_meeting(x, y, obj_player_backdrop)) {
            vertical_speed = -10;
        }
        if (_player != noone) {
            if (milon_in_zone(_player, 6020, 677, 6356, 938)) {
                armed = true;
            }
            if (armed && milon_in_zone(_player, 6001, 235, 8047, 938)) {
                if (x > _player.x) {
                    x -= 5;
                }
                if (x < _player.x) {
                    x += 5;
                }
            }
        } else if (armed) {
            armed = false;
            image_index = 2;
            audio_play_sound(snd_milon_hopper_voice, 1, false);
        }
        if (armed) {
            image_index = vertical_speed > -5 ? 1 : 0;
        }
        if (x > 7785) {
            armed = false;
        }
        break;

    case MilonHazard.Spider:
        var _spider_target = instance_find(obj_player, 0);
        if (!armed && milon_in_zone(_spider_target, 8762, 403, 8799, 932)) {
            armed = true;
            image_xscale = 2.3;
            image_yscale = 2.3;
            scream = audio_play_sound(snd_prehistorik_spider_scream, 1, false);
        }
        if (armed) {
            // G922–926 dash left for nine steps, wait, then chase past the exit.
            if (hazard_age == 275) {
                audio_stop_sound(scream);
                scream = audio_play_sound(snd_prehistorik_spider_scream, 1, false);
            }
            if (hazard_age < 9 || hazard_age >= 275) {
                x -= 30;
                if (bbox_right < -480) {
                    instance_destroy();
                }
            }
            ++hazard_age;
        }
        break;
}
