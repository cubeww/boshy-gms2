draw_sprite(spr_king_dedede_arena_background, 0, 0, 0);

var _pulse = dsin(floor(arena_steps * 20 / 6)) * 32;
for (var _i = 0; _i < array_length(question_marks); ++_i) {
    var _mark = question_marks[_i];
    var _transparency = clamp(floor(_mark.y / 2) - 20 + _pulse, 0, 128);
    draw_sprite_ext(spr_king_dedede_question_mark, 0, _mark.x, _mark.y, 1, 1, 0, c_white, 1 - _transparency / 128);
}

draw_sprite(spr_king_dedede_arena_terrain, 0, 0, 0);
