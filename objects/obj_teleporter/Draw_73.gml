teleporter_draw_portal_label(label_portal);
if (sonic_notice_age > 0) {
    var _alpha = min(1, sonic_notice_age / 20);
    draw_boshy_text("STOP!", page_left + 298, 202, _alpha);
    draw_boshy_text("No sonic allowed!", page_left + 246, 220, _alpha);
}
if (warp_age >= 0) {
    teleporter_draw_exit(warp_age);
}
