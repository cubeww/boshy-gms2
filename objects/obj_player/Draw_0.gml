var _visual_facing = visual_facing();
var _sprite = _visual_facing < 0 ? character.sprite_left : character.sprite_right;
var _poses = _visual_facing < 0 ? left_poses : character.poses;
var _frames = _poses[pose].frames;
var _frame = _frames[min(floor(pose_frame), array_length(_frames) - 1)];
var _xscale = room == rm_missingno ? image_xscale : 1;
var _yscale = room == rm_missingno ? image_yscale : 1;
draw_sprite_ext(_sprite, _frame, x, y, _xscale, _yscale, image_angle, c_white, 1);
