x += velocity_x;
y += velocity_y;
velocity_y += effect_gravity;
if ((sprite_index == spr_secret_1_1_coin_burst && velocity_y > 0)
    || y - 32 > inst_secret_1_1_controller.scroll_view_top + 480) {
    instance_destroy();
}
