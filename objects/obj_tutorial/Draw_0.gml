if (page_left == 0) {
    gpu_set_blendmode(bm_add);
    for (var _x = 0; _x < 640; _x += 16) {
        draw_sprite(spr_tutorial_conveyor, floor(conveyor_frame), _x, 448);
    }
    gpu_set_blendmode(bm_normal);
}

for (var _i = 0; _i < array_length(recovery_strips); ++_i) {
    var _strip = recovery_strips[_i];
    for (var _x = _strip.left; _x < _strip.right; _x += 32) {
        draw_sprite(spr_tutorial_recovery, _i, _x, 480);
    }
}

if (page_left == 3200) {
    draw_boshy_text("These platforms ->\n\nAre only available on ez-mode", 3440, 256);
}
