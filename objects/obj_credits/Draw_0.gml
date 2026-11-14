if (page_top > 330) {
    exit;
}
draw_sprite(easy_credits ? spr_credits_label_02_easy : spr_credits_label_02, 0, 0, 208);
if (easy_credits) {
    draw_sprite(spr_credits_label_33, 0, 0, 272);
}
