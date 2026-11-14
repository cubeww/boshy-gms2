draw_self();
if (guard_alert_steps < 54) {
    draw_sprite(spr_milon_depth_guard_alert, (guard_alert_steps * 3 div 10) mod 4, x, y - 32);
}
if (guard_question_steps < 6) {
    draw_sprite(spr_milon_depth_guard_question, 0, x, y - 32);
}
