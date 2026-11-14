// G746–747 display integer positions and keep the original fractional travel.
x = floor(projectile_x);
y = floor(projectile_y);
projectile_x += lengthdir_x(guard_shot_speed, image_angle);
projectile_y += lengthdir_y(guard_shot_speed, image_angle);
if (bbox_right < -480 || bbox_left > room_width + 480 || bbox_bottom < -300 || bbox_top > room_height + 300) {
    instance_destroy();
}
