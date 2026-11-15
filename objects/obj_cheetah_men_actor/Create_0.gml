phase = 1;
actor_active = true;
actor_hsp = 0;
actor_vsp = 0;
faces_left = true;
attack_pose = false;
giant_form = false;
invert_colors = false;

idle_sprites = [
    [spr_cheetah_men_phase_1_idle_right, spr_cheetah_men_phase_1_idle_left],
    [spr_cheetah_men_phase_2_idle_right, spr_cheetah_men_phase_2_idle_left],
    [spr_cheetah_men_phase_3_idle_right, spr_cheetah_men_phase_3_idle_left]
];
attack_sprites = [idle_sprites[0],
    [spr_cheetah_men_phase_2_attack_right, spr_cheetah_men_phase_2_attack_left],
    [spr_cheetah_men_phase_3_attack_right, spr_cheetah_men_phase_3_attack_left]
];

update_pose = function() {
    var _sprites = attack_pose ? attack_sprites : idle_sprites;
    var _sprite = giant_form ? spr_cheetah_men_giant : _sprites[phase - 1][faces_left ? 1 : 0];
    if (sprite_index != _sprite) {
        sprite_index = _sprite;
        image_index = 0;
    }
};

restore_actor = function(_x, _y) {
    x = _x;
    y = _y;
    actor_hsp = 0;
    actor_vsp = 0;
    actor_active = true;
    faces_left = phase != 3;
    attack_pose = false;
    giant_form = false;
    invert_colors = false;
    image_angle = 0;
    image_xscale = 1;
    image_yscale = 1;
    image_speed = 1;
    update_pose();
    image_index = 0;
};

projectile_origin = function() {
    // G1230/G1233 create at the firing sprite's action point.
    var _dx = phase == 1 ? (faces_left ? -3 : 3) : (faces_left ? -3 : 4);
    var _dy = phase == 1 ? -45 : (faces_left && image_index >= 1 ? -44 : -43);
    _dx *= image_xscale;
    _dy *= image_yscale;
    return {
        x: floor(x + _dx * dcos(image_angle) + _dy * dsin(image_angle)),
        y: floor(y - _dx * dsin(image_angle) + _dy * dcos(image_angle))
    };
};
