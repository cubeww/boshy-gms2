if (y > inst_secret_jtv_controller.page_top + 480) {
    instance_create_depth(x, y, depth - 1, obj_secret_jtv_arena_blast, { image_angle: irandom(359) });
    instance_destroy();
    exit;
}
fall_y += fall_speed;
y = floor(fall_y);
fall_speed += 0.45;
image_angle += irandom_range(1, 2);
