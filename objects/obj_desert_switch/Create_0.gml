probe_contact = false;
image_speed = 0;
animation_age = 0;

refresh_switch = function() {
    sprite_index = desert_switch_enabled() ? spr_desert_switch_on : spr_desert_switch_off;
    image_index = 0;
    animation_age = 0;
};
