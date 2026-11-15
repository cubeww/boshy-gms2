var _visual_facing = visual_facing();
var _sprite = _visual_facing < 0 ? character.sprite_left : character.sprite_right;
if (arthur_armor_lost) {
    _sprite = _visual_facing < 0 ? spr_stock_arthur_unarmored_left : spr_stock_arthur_unarmored_right;
}
var _poses = _visual_facing < 0 ? left_poses : character.poses;
var _frames = _poses[pose].frames;
var _frame = _frames[min(floor(pose_frame), array_length(_frames) - 1)];
var _xscale = room == rm_missingno ? image_xscale : 1;
var _yscale = room == rm_missingno ? image_yscale : 1;
if (secret_1_1_poison_steps > 0) {
    _xscale = 1 + secret_1_1_poison_steps * 0.2;
    _yscale = _xscale;
}
if (struct_exists(character, "custom")) {
    game_character_draw(character, pose, _frame, _visual_facing, x, y, _xscale, _yscale, image_angle);
} else {
    draw_sprite_ext(_sprite, _frame, x, y, _xscale, _yscale, image_angle, c_white, 1);
}
