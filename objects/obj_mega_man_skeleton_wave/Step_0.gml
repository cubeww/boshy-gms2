// G741 and G744–745 rotate the blade each step as it travels sideways.
image_angle += 40;
x += 5 * wave_facing;
if (bbox_right < -80 || bbox_left > room_width + 80) {
    instance_destroy();
}
