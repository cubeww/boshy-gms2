y += 5;
image_angle = (image_angle + 10) mod 360;
if (bbox_top >= 512) {
    instance_destroy();
}
