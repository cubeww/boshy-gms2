function title_draw_collectables() {
    // Frame 1, layer 2. Each pair in spr_title_collectables is locked, then collected.
    static _items = [
        ["AwesomeSauce", 438, 312],
        ["Mixer", 480, 322],
        ["Rupees", 516, 331],
        ["Gastly", 555, 334],
        ["Timer", 571, 314],
        ["Scouter", 604, 318],
        ["Metal Gear", 458, 360],
        ["Cake", 489, 360],
        ["Lalalalalala CD", 461, 399],
        ["Trololol CD", 495, 399],
        ["RickRoll CD", 528, 399],
        ["Chocolate CD", 562, 399],
        ["Barrel Roll CD", 597, 400],
        ["Keyboard Cat CD", 461, 432],
        ["Hamster CD", 495, 431],
        ["Cookie CD", 528, 432],
        ["Wily CD", 560, 432],
        ["LIVE CD", 592, 432],
        ["Sax CD", 464, 464],
        ["Sexy Sax CD", 496, 463]
    ];

    var _previous_color = draw_get_color();
    var _previous_alpha = draw_get_alpha();
    draw_set_color(c_white);
    draw_set_alpha(1 - 90 / 128);
    draw_rectangle(442, 309, 635, 475, false);
    draw_set_alpha(1);

    var _slot = game_campaign_title_slot();
    for (var _i = 0; _i < array_length(_items); ++_i) {
        var _item = _items[_i];
        var _frame = _i * 2 + (game_has_item(_item[0], _slot) ? 1 : 0);
        draw_sprite(spr_title_collectables, _frame, _item[1], _item[2]);
    }

    draw_set_color(_previous_color);
    draw_set_alpha(_previous_alpha);
}
