// Group 953 creates 50 stars. One additional star is authored just above the view.
stars = array_create(51);
stars[0] = { draw_x: 128, draw_y: -16, position_x: 0, scroll_speed: 3, fast: false };
for (var _i = 1; _i < array_length(stars); ++_i) {
    stars[_i] = {
        draw_x: 128,
        draw_y: 20 + irandom(439),
        position_x: 20 + irandom(599),
        scroll_speed: (10 + irandom(19)) * 0.1,
        fast: false
    };
}
