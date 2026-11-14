// G1056–1057 carry fractional travel in alterable values while rendering integer positions.
x = floor(travel_x);
y = floor(travel_y);
travel_x += lengthdir_x(travel_speed, image_angle);
travel_y += lengthdir_y(travel_speed, image_angle);
if (bbox_right < -16 || bbox_left >= room_width + 16
    || bbox_bottom < -16 || bbox_top >= room_height + 16) {
    instance_destroy();
}
