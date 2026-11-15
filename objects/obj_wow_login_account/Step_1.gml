if (progress_owner.wow_account_name == "" && mouse_check_button_pressed(mb_left)) {
    var _mouse = wow_mouse_room_position();
    if (!is_undefined(_mouse) && point_in_rectangle(_mouse.x, _mouse.y, x, y, x + 89, y + 14)) {
        // G1045 clears the account field on each click.
        focused = true;
        typed_name = "";
        keyboard_string = "";
    }
}
