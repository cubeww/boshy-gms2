skeleton_king_body_draw();
if (king_started) {
    if (blob_visible) {
        draw_sprite(blob_pose, blob_mask.image_index, blob_x, blob_y);
    }
    if (blob_chat_age >= 0) {
        var _wiggle = 0;
        if (blob_chat_age >= 2 && blob_chat_age < 15) {
            _wiggle = (15 - blob_chat_age) * ((blob_chat_age div 2) mod 2 == 0 ? -1 : 1);
        }
        var _text_x = blob_chat_x + 174 - blob_chat_letters * 8;
        draw_boshy_text(string_copy("Oh, hai!", 1, blob_chat_letters), _text_x, blob_chat_y + _wiggle);
    }
    if (blob_arm_active) {
        draw_sprite_ext(spr_skeleton_king_blob_platform, 0, 2006, 480, 1.2, 1.2, blob_arm_angle, c_white, 1);
    }
}
skeleton_king_attacks_draw();
