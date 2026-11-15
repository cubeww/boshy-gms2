function mega_man_pair_spawn() {
    // G707 replaces Mega Man with both fighters at their original hotspots.
    metal_fighter = mega_man_spawn_actor(MegaManActor.MetalMan, spr_mega_man_metal_man, 616, 30, 25);
    bomb_fighter = mega_man_spawn_actor(MegaManActor.BombMan, spr_mega_man_bomb_man, 323, 37, 25);
    metal_fighter.spinner_steps = 0;
    bomb_fighter.bomb_flag = false;
    bomb_fighter.bomb_flag_wait_us = 750000;
    bomb_fighter.bomb_animation_ticks = 0;
    bomb_fighter.bomb_touching_backdrop = false;
    bomb_fighter.image_speed = 0;
}

function mega_man_metal_step(_controller, _player) {
    // G708 follows the room timer even while Mega Man's phase counter is held.
    var _timer = _controller.game_controller.frame_elapsed_us div 1000;
    y = floor(268 + dsin(_timer div 8) * 50);
    x = floor(330 + dcos(_timer div 10) * 290);
    if (++enemy_cooldown >= 110) {
        mega_man_spawn_charge(x, y);
        enemy_cooldown = 0;
    }

    // G711–713 add paired spinning blades once Bomb Man is gone.
    if (!instance_exists(_controller.bomb_fighter) && ++spinner_steps >= 100) {
        mega_man_spawn_spinner(x, y, 1);
        mega_man_spawn_spinner(x, y, -1);
        spinner_steps = 0;
    }
}

function mega_man_bomb_step(_controller, _player) {
    // G724's collision event runs before G723 updates position and velocity.
    var _touching_backdrop = place_meeting(x, y, obj_player_backdrop);
    if (_touching_backdrop && !bomb_touching_backdrop) {
        enemy_vy = -1 - enemy_vy * 0.5;
    }
    bomb_touching_backdrop = _touching_backdrop;
    y = floor(y + enemy_vy);
    enemy_vy += 0.5;
    x = floor(300 + dsin(_controller.game_controller.frame_elapsed_us div 3000) * 32);

    // Each direction has the same animation clock, with a one-play clip on the left.
    if (enemy_facing > 0 || image_index < image_number - 1) {
        bomb_animation_ticks += 50;
        if (bomb_animation_ticks > 100) {
            bomb_animation_ticks -= 100;
            image_index = (image_index + 1) mod image_number;
        }
    }
    if (++enemy_cooldown >= 40) {
        // G725–726 select the throw direction before G727 toggles the flag.
        var _facing = bomb_flag ? 1 : -1;
        if (enemy_facing != _facing) {
            enemy_facing = _facing;
            var _frame = image_index;
            sprite_index = _facing > 0 ? spr_mega_man_bomb_man : spr_mega_man_bomb_man_left;
            // Fusion changes the direction bank without resetting the animation frame.
            image_index = _frame;
        }
        mega_man_spawn_bomb(x, y, _facing * (1 + irandom(4)), -15);
        enemy_cooldown = 0;
    }

    bomb_flag_wait_us -= delta_time;
    if (bomb_flag_wait_us <= 0) {
        bomb_flag = !bomb_flag;
        bomb_flag_wait_us += 750000;
    }
}
