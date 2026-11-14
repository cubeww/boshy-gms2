image_speed = 0;
image_index = image_number - 1;
mask_index = spr_solid;
floor_frame = image_index;
floor_target = floor_frame;
floor_frame_steps = 0;
floor_draw_xscale = image_xscale;

set_floor_frame = function(_frame) {
    floor_frame = _frame;
    image_index = _frame;
    // The collision width follows the opaque strip of the current frame.
    var _solid_width = min(sprite_get_width(sprite_index), 37 + 36 * _frame);
    image_xscale = floor_draw_xscale * _solid_width / sprite_get_width(mask_index);
};
set_floor_frame(floor_frame);

set_floor_open = function(_open) {
    var _target = _open ? 0 : image_number - 1;
    if (floor_target != _target) {
        floor_target = _target;
        floor_frame_steps = 0;
        // Fusion restarts the selected animation at its first frame.
        set_floor_frame(_open ? image_number - 1 : 0);
    }
};
