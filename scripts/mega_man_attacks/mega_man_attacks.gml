enum MegaManActor {
    Electric,
    MetalMan,
    BombMan,
    Skeleton,
    Dragon
}

function mega_man_attacks_setup() {
    secondary_hp = 25;
    secondary_meter_visible = false;
    interlude_bomb_timer = 250;
    electric_fighter = noone;
    metal_fighter = noone;
    bomb_fighter = noone;
    skeleton_fighter = noone;
    dragon_fighter = noone;
}

function mega_man_spawn_actor(_kind, _sprite, _x, _y, _hp) {
    return instance_create_depth(_x, _y, depth - 1, obj_mega_man_actor, {
        enemy_kind: _kind,
        enemy_health: _hp,
        sprite_index: _sprite
    });
}

function mega_man_secondary_hp() {
    return secondary_hp;
}

function mega_man_secondary_meter_visible() {
    return secondary_meter_visible;
}

function mega_man_spawn_flame(_x, _y) {
    // Fusion creates these in the terrain layer below the foreground platform trim.
    instance_create_depth(_x, _y, 1, obj_mega_man_ledge_flame);
}

function mega_man_actor_bounce(_restitution) {
    var _touching_backdrop = place_meeting(x, y, obj_player_backdrop);
    if (_touching_backdrop && !enemy_touching_backdrop) {
        enemy_vy = -1 - enemy_vy * _restitution;
    }
    enemy_touching_backdrop = _touching_backdrop;
}

function mega_man_electric_step(_controller, _player) {
    // Fusion dispatches the G696 backdrop collision before the next movement pass.
    mega_man_actor_bounce(0.5);
    y = floor(y + enemy_vy);
    enemy_vy += 0.35;
    x = floor(x + enemy_vx);
    if (_player != noone && x != _player.x) {
        enemy_facing = sign(_player.x - x);
        sprite_index = enemy_facing < 0 ? spr_mega_man_electric_left : spr_mega_man_electric_right;
    }
    ++enemy_age;
    ++enemy_cooldown;
    _controller.secondary_hp = enemy_health;
    _controller.secondary_meter_visible = true;

    // G697 charges an aimed shot above the fighter. G699–700 switch to the falling volley.
    if (enemy_age < 500 && enemy_cooldown == 90) {
        var _angle = _player == noone ? -90 : darctan2(x - _player.x, y - _player.y) + 90;
        mega_man_spawn_shot(MegaManHazard.Burst, x, y - 32, _angle, 3);
        enemy_cooldown = 0;
    }
    if (enemy_age == 500) {
        enemy_vy = -15;
    }
    if (enemy_age >= 530) {
        x = floor(380 + dcos((_controller.scene_steps * 20) div 5) * 220);
        if (enemy_cooldown >= 15) {
            mega_man_spawn_shot(MegaManHazard.SplitShot, x, y, 90, 3);
            enemy_cooldown = 0;
        }
    }
    if (enemy_age == 590) {
        enemy_age = 0;
        x = 317;
    }
}

function mega_man_skeleton_step(_player) {
    // G735–736 keep Fusion's integer position and target bias.
    mega_man_actor_bounce(0.1);
    y = floor(y + enemy_vy);
    enemy_vy += 0.2;
    x = floor(lerp(x, enemy_target_x, 0.2) + clamp(enemy_target_x, -1, 1));
    ++enemy_age;
    if (enemy_age == 100) {
        enemy_target_x = enemy_facing > 0 ? 50 : 590;
    }
    if (enemy_age >= 150 && enemy_age < 250) {
        // G739–740 offset the wake differently on each side.
        instance_create_depth(x + (enemy_facing < 0 ? -10 : 0), y + (enemy_facing > 0 ? 7 : 0), depth - 1,
            obj_mega_man_skeleton_wave, { wave_facing: enemy_facing, image_xscale: 1.6, image_yscale: 1.6 });
    }
    if (_player != noone && x != _player.x) {
        enemy_facing = sign(_player.x - x);
    }
    if (enemy_age == 250) {
        enemy_vy = -10;
        enemy_target_x = enemy_facing < 0 ? 560 : 80;
    }
    if (enemy_age >= 300 && enemy_age <= 345 && (enemy_age - 300) mod 15 == 0) {
        for (var _i = 0; _i < 36; ++_i) {
            mega_man_spawn_shot(MegaManHazard.SkeletonShot, x, y, _i * 10, 2);
        }
        enemy_target_x = (enemy_age == 300 || enemy_age == 330) ? 80 : 590;
    }
    if (enemy_age == 500) {
        enemy_age = 0;
    }

    // Active 37's forced entrance clip releases to its normal direction after one pass.
    ++entrance_frames;
    if (entrance_frames * 50 <= 400) {
        image_index = max(0, entrance_frames * 50 - 1) div 100;
    } else {
        sprite_index = enemy_facing < 0 ? spr_mega_man_skeleton_left : spr_mega_man_skeleton_right;
        image_index = 0;
    }
}

function mega_man_destroy_form(_actor) {
    var _dragon = _actor.enemy_kind == MegaManActor.Dragon;
    mega_man_spawn_explosion(_actor.x, _actor.y - (_dragon ? 50 : 0), _dragon ? 3 : 1);
    audio_play_sound(snd_mega_man_victory_death, 1, false);
    audio_play_sound(snd_mega_man_form_explosion, 1, false);
    instance_destroy(_actor);
    if (!_dragon) {
        shake_strength = 50;
        blur_strength = 5;
        blur_angle = 0;
    }
}

function mega_man_attack_shot(_bullet) {
    var _actor = noone;
    with (_bullet) {
        _actor = instance_place(x, y, obj_mega_man_actor);
    }
    if (_actor == noone || _actor.enemy_health <= 0 || !_actor.enemy_active
        || (_actor.enemy_kind == MegaManActor.Dragon && _actor.enemy_age < 50)) {
        return false;
    }

    // The skeleton's display reads HP before damage, unlike the dragon's counter.
    if (_actor.enemy_kind == MegaManActor.Skeleton) {
        secondary_hp = _actor.enemy_health div 3;
    }
    --_actor.enemy_health;
    if (_actor.enemy_kind == MegaManActor.MetalMan || _actor.enemy_kind == MegaManActor.BombMan) {
        secondary_hp = _actor.enemy_health;
    } else if (_actor.enemy_kind == MegaManActor.Dragon) {
        secondary_hp = _actor.enemy_health div 4;
    }
    if (_actor.enemy_flash == 0) {
        _actor.enemy_flash = 1;
    }
    audio_play_sound(snd_mario_bump, 1, false);
    return true;
}

function mega_man_attacks_step(_player) {
    var _controller = id;
    if (fight_age == 500) {
        electric_fighter = mega_man_spawn_actor(MegaManActor.Electric, spr_mega_man_electric_right, 317, 50, 25);
        mega_man_change_mask();
        blur_strength = 4;
        blur_angle = 90;
    }
    if (instance_exists(electric_fighter)) {
        with (electric_fighter) {
            mega_man_electric_step(_controller, _player);
        }
        if (electric_fighter.enemy_health <= 0) {
            mega_man_destroy_form(electric_fighter);
            mega_man_clear_electric_shots();
            fight_age = 552;
            secondary_meter_visible = false;
        }
    }

    if (fight_age >= 630) {
        interlude_bomb_timer -= 20;
        if (interlude_bomb_timer <= 0) {
            interlude_bomb_timer += 250;
            if (fight_age < 680) {
                mega_man_spawn_bomb(x, y, irandom(1) - irandom(1));
                audio_play_sound(snd_mega_man_ordnance_shoot, 1, false);
            }
        }
    }
    if (fight_age == 750) {
        mega_man_pair_spawn();
        mega_man_change_mask();
        secondary_meter_visible = true;
        shake_strength = 20;
    }
    if (instance_exists(metal_fighter)) {
        with (metal_fighter) {
            mega_man_metal_step(_controller, _player);
        }
        if (metal_fighter.enemy_health <= 0) {
            mega_man_destroy_form(metal_fighter);
        }
    }
    if (instance_exists(bomb_fighter)) {
        if (bomb_fighter.enemy_health <= 0) {
            mega_man_destroy_form(bomb_fighter);
        } else {
            with (bomb_fighter) {
                mega_man_bomb_step(_controller, _player);
            }
        }
    }
    if (fight_age == 751 && !instance_exists(metal_fighter) && !instance_exists(bomb_fighter)) {
        fight_age = 752;
        secondary_meter_visible = false;
    }

    if (fight_age == 1500) {
        skeleton_fighter = mega_man_spawn_actor(MegaManActor.Skeleton, spr_mega_man_skeleton_appear, 323, 27, 75);
        skeleton_fighter.enemy_target_x = 327;
        skeleton_fighter.entrance_frames = 0;
        skeleton_fighter.image_speed = 0;
        for (var _i = 0; _i < 3; ++_i) {
            mega_man_spawn_flame(-1 + _i * 16, 350);
            mega_man_spawn_flame(591 + _i * 16, 350);
        }
        mega_man_change_mask();
        secondary_meter_visible = true;
        shake_strength = 20;
    }
    if (instance_exists(skeleton_fighter)) {
        with (skeleton_fighter) {
            mega_man_skeleton_step(_player);
        }
        if (skeleton_fighter.enemy_health <= 0) {
            mega_man_destroy_form(skeleton_fighter);
        }
    }
    if (fight_age == 1501 && !instance_exists(skeleton_fighter)) {
        fight_age = 1502;
        secondary_meter_visible = false;
    }
    if (fight_age == 1502) {
        dragon_fighter = mega_man_dragon_spawn(_player);
        mega_man_spawn_flame(32, 464);
        mega_man_spawn_flame(591, 463);
    }
    if (instance_exists(dragon_fighter)) {
        with (dragon_fighter) {
            mega_man_dragon_step(_controller, _player);
        }
        if (fight_age == 1900) {
            secondary_meter_visible = true;
        }
        if (dragon_fighter.enemy_health <= 0) {
            mega_man_destroy_form(dragon_fighter);
            mega_man_reveal_final_form();
        }
    }

    with (obj_mega_man_actor) {
        if (enemy_flash > 0 && ++enemy_flash >= 10) {
            enemy_flash = 0;
        }
    }
}
