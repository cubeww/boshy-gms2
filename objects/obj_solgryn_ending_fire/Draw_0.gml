var _scene = instance_find(obj_solgryn_ending, 0);
if (_scene == noone || _scene.ending_age >= 950) {
    exit;
}

var _age = _scene.ending_age;
// G5 raises the flames every 30 ms from steps 50–400, then G12 moves them down one pixel per step.
var _rise = ((clamp(_age, 49, 400) - 49) * 20) div 30;
var _draw_y = y - _rise + max(0, _age - 399);
if (_draw_y - sprite_get_yoffset(sprite_index) < room_height) {
    gpu_set_blendmode(bm_add);
    draw_sprite(sprite_index, image_index, x, _draw_y);
    gpu_set_blendmode(bm_normal);
}
