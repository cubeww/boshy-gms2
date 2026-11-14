enum MegaManDragonPose {
    Idle,
    Roar,
    Fire
}

function mega_man_dragon_spawn(_player) {
    var _dragon = mega_man_spawn_actor(MegaManActor.Dragon, spr_mega_man_dragon_idle_right, 322, 670, 75);
    _dragon.image_speed = 0;
    _dragon.enemy_target_x = _player == noone ? 322 : _player.x;
    _dragon.enemy_active = false;
    _dragon.dragon_direction = 0;
    _dragon.dragon_pose = MegaManDragonPose.Idle;
    _dragon.dragon_pose_steps = 0;
    _dragon.dragon_swoop_steps = 20;
    return _dragon;
}

function mega_man_dragon_set_pose(_pose) {
    if (dragon_pose != _pose) {
        dragon_pose = _pose;
        dragon_pose_steps = 0;
    }
    var _frame = max(0, dragon_pose_steps * 65 - 1) div 100;
    switch (dragon_pose) {
        case MegaManDragonPose.Idle:
            sprite_index = enemy_facing < 0 ? spr_mega_man_dragon_idle_left : spr_mega_man_dragon_idle_right;
            image_index = 0;
            break;
        case MegaManDragonPose.Roar:
            sprite_index = enemy_facing < 0 ? spr_mega_man_dragon_roar_left : spr_mega_man_dragon_roar_right;
            image_index = _frame;
            break;
        case MegaManDragonPose.Fire:
            sprite_index = enemy_facing < 0 ? spr_mega_man_dragon_fire_left : spr_mega_man_dragon_fire_right;
            image_index = _frame mod 4;
            break;
    }
}

function mega_man_dragon_action_point() {
    static _roar_left_y = [-37, -38, -38, -38];
    var _frame = floor(image_index);
    switch (dragon_pose) {
        case MegaManDragonPose.Roar:
            return { x: x + enemy_facing * 34, y: y + (enemy_facing < 0 ? _roar_left_y[_frame] : -39) };
        case MegaManDragonPose.Fire:
            return enemy_facing < 0
                ? { x: x + (_frame == 3 ? -27 : -28), y: y - 136 }
                : { x: x + 25, y: y - 134 };
    }
    return { x: x + enemy_facing * 28, y: y + (enemy_facing < 0 ? -134 : -136) };
}

function mega_man_dragon_look_at(_player) {
    if (_player == noone) {
        return;
    }
    // Fusion quantizes Look At to a 32-direction table before selecting the nearest authored art.
    var _direction = floor((point_direction(x, y, _player.x, _player.y) + 5.625) / 11.25) mod 32;
    if (_direction != 8 && _direction != 24) {
        enemy_facing = _direction > 8 && _direction < 24 ? -1 : 1;
    }
    dragon_direction = _direction;
    mega_man_dragon_set_pose(dragon_pose);
}

function mega_man_dragon_step(_controller, _player) {
    if (dragon_pose != MegaManDragonPose.Idle) {
        ++dragon_pose_steps;
    }
    if (dragon_pose == MegaManDragonPose.Roar && dragon_pose_steps * 65 > 400) {
        mega_man_dragon_set_pose(MegaManDragonPose.Idle);
    } else {
        mega_man_dragon_set_pose(dragon_pose);
    }

    // G758–760 align the dragon with the player, bring it through the floor and start its attacks.
    var _fight_age = _controller.fight_age;
    if (_fight_age == 1600 && _player != noone) {
        enemy_target_x = _player.x;
        x = enemy_target_x;
    }
    if (_fight_age >= 1600 && _fight_age < 1820) {
        --y;
        mega_man_dragon_look_at(_player);
        _controller.shake_strength = 20;
        _controller.blur_strength = 2;
        _controller.blur_angle = 0;
    }
    if (_fight_age == 1900) {
        mega_man_dragon_set_pose(MegaManDragonPose.Roar);
        audio_play_sound(snd_mega_man_dragon_roar, 1, false);
        enemy_active = true;
        _controller.shake_strength = 120;
        _controller.blur_strength = 50;
        _controller.blur_angle = 0;
    }
    if (!enemy_active) {
        return;
    }

    // G761–764 move toward the previous target before choosing a new side.
    ++enemy_age;
    ++enemy_cooldown;
    if (enemy_age >= 100) {
        x = floor(lerp(x, enemy_target_x, 0.2) + clamp(enemy_target_x, -1, 1));
    }
    if (enemy_age == 100 && _player != noone && _player.x != x) {
        enemy_facing = sign(_player.x - x);
        dragon_direction = enemy_facing < 0 ? 16 : 0;
        enemy_target_x = enemy_facing > 0 ? 80 : 540;
        mega_man_dragon_set_pose(dragon_pose);
    }

    // G765–766 sweep the fireball angle from the dragon's mouth toward the opposite wall.
    var _horizontal_direction = dragon_direction == 0 ? 1 : (dragon_direction == 16 ? -1 : 0);
    if (enemy_age >= 125 && enemy_age < 230 && enemy_cooldown >= 10 && _horizontal_direction != 0) {
        mega_man_dragon_set_pose(MegaManDragonPose.Fire);
        var _mouth = mega_man_dragon_action_point();
        var _sweep = enemy_age - 125;
        mega_man_spawn_shot(MegaManHazard.Fireball, _mouth.x, _mouth.y,
            enemy_facing > 0 ? _sweep - 90 : 270 - _sweep, 2 + _sweep * 0.1);
        enemy_cooldown = 0;
        audio_play_sound(snd_mario_fireball, 1, false);
    }
    if (enemy_age >= 270 && --dragon_swoop_steps == 0) {
        // Fusion evaluates the 400 ms timer before its last condition, E < 350.
        dragon_swoop_steps = 20;
        if (enemy_age < 350) {
            var _opening = mega_man_dragon_action_point();
            mega_man_spawn_swoop(_opening.x, _opening.y + 100, _horizontal_direction, 3);
            mega_man_dragon_set_pose(MegaManDragonPose.Roar);
            audio_play_sound(snd_mega_man_dragon_swoop, 1, false);
        }
    }

    if (enemy_age >= 350 && enemy_age < 370) {
        mega_man_spawn_diving_spark(x, -100 + (enemy_age - 350) * 53);
        audio_play_sound(snd_mega_man_dragon_spark_spawn, 1, false);
    }
    if (enemy_age >= 370 && enemy_age < 388) {
        mega_man_spin_diving_sparks();
    }
    if (enemy_age == 400) {
        mega_man_launch_diving_sparks();
        audio_play_sound(snd_mega_man_dragon_spark_launch, 1, false);
    }
    if (enemy_age == 460) {
        audio_play_sound(snd_green_greens_kracko_explosion, 1, false);
    }
    if (enemy_age >= 650 && enemy_age < 800 && enemy_cooldown >= 25) {
        // G772 creates bombs at the main Mega Man object's position, even while it is transparent.
        mega_man_spawn_bomb(_controller.x, _controller.y, -irandom(9), -5);
        audio_play_sound(snd_mega_man_ordnance_shoot, 1, false);
        enemy_cooldown = 0;
    }
    if (enemy_age >= 900) {
        enemy_age = 125;
    }
}
