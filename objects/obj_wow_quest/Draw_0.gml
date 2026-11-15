switch (quest_state) {
    case WowQuestState.Dialogue:
        draw_self();
        break;

    case WowQuestState.Accepted:
        var _alpha = max(0, 1 - (quest_age + 1) * 15 / 255);
        if (_alpha > 0) {
            draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, c_white, _alpha);
        }
        break;

    case WowQuestState.Declined:
        var _scale = 0.25 + 0.1 * min(quest_age + 1, 9);
        var _frame = min(quest_age div 2, sprite_get_number(spr_wow_quest_axe) - 1);
        draw_sprite_ext(spr_wow_quest_axe, _frame, axe_x, axe_y, _scale, _scale, 0, c_white, 1);
        break;
}
