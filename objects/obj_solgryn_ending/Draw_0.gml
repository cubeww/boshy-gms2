solgryn_draw_parallax(spr_solgryn_arena_cloud_lower, dark_cloud_rows, 0, 0, ending_age mod 500, 641, 500);
if (ending_age >= 400) {
    // G12 reveals the blue fill and the second Parallaxer together.
    var _alpha = min(1, (ending_age - 399) / 255);
    draw_sprite_ext(spr_solgryn_ending_blue_fill, 0, 0, 213, 1, 1, 0, c_white, _alpha);
    solgryn_draw_parallax(spr_solgryn_ending_blue_clouds, blue_cloud_rows, 0, 0, ending_age mod 150, 639, 150, _alpha);
} else {
    draw_self();
}
