function missingno_pose_setup() {
    // G703 scales the precise body silhouette before the first scene step.
    sprite_index = spr_missingno_body;
    image_speed = 0;
    image_xscale = 3;
    image_yscale = 3;
    hit_flash_age = 0;
    pose_ink = 0;
    pose_attack_additive = false;
    pose_trail_wait_us = 50000;
}

function missingno_pose_step() {
    // G696–701 apply discrete ink changes while a hit's ten-step flag is active.
    switch (hit_flash_age) {
        case 2:
        case 6:
            pose_ink = 2;
            break;
        case 4:
        case 8:
        case 10:
            pose_ink = 0;
            break;
    }
    if (hit_flash_age > 0) {
        hit_flash_age = hit_flash_age == 10 ? 0 : hit_flash_age + 1;
    }

    // G734 advances older copies before G738 creates a fresh one.
    with (obj_missingno_pose_trail) {
        ++trail_age;
        image_xscale += 0.1;
        image_yscale = image_xscale;
        image_alpha = max(0, 1 - trail_age * 15 / 128);
        if (trail_age >= 25) {
            instance_destroy();
        }
    }
    pose_trail_wait_us -= delta_time;
    if (pose_trail_wait_us <= 0) {
        pose_trail_wait_us += 50000;
        if (hit_points > 0) {
            instance_create_layer(x, y, "Boss Afterimages", obj_missingno_pose_trail, {
                image_xscale: image_xscale,
                image_yscale: image_yscale
            });
        }
    }
}

function missingno_pose_draw() {
    // G802 and G813 set the attack ink after the hit-flash events.
    if (pose_attack_additive != attack_additive) {
        pose_attack_additive = attack_additive;
        pose_ink = attack_additive ? 9 : 0;
    }
    if (pose_ink == 9) {
        gpu_set_blendmode(bm_add);
    }
    var _sprite = pose_ink == 2 ? spr_missingno_body_inverted : sprite_index;
    draw_sprite_ext(_sprite, 0, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    if (pose_ink == 9) {
        gpu_set_blendmode(bm_normal);
    }
    missingno_assists_draw();
}

function missingno_intro_skip() {
    with (obj_missingno_entry_grid) {
        instance_destroy();
    }
    with (obj_missingno_intro_silhouette) {
        instance_destroy();
    }
}

function missingno_draw_entry_grid() {
    // The native fixed layer covers the world, Pokémon captions and health displays.
    var _camera = camera_get_active();
    var _left = camera_get_view_x(_camera);
    var _top = camera_get_view_y(_camera);
    with (obj_missingno_entry_grid) {
        draw_grid(_left, _top);
    }
}
