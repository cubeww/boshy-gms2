// Read debug input before any player or hazard Step event.
if (gameplay_room && keyboard_check_pressed(ord("G"))) {
    global.debug_invincible = !global.debug_invincible;
}
