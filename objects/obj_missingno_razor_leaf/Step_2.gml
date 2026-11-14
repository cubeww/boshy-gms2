// G1061–1062 apply the previous fractional position before queuing the next step.
x = floor(leaf_x);
y = floor(leaf_y);
leaf_x += lengthdir_x(18, image_angle);
leaf_y += lengthdir_y(18, image_angle);
if (bbox_right < -16 || bbox_left > room_width + 16
    || bbox_bottom < -16 || bbox_top > room_height + 16) {
    instance_destroy();
}
