if (!breakaway_active && place_meeting(x, y, obj_ninja_gaiden_crusher)) {
    // G1055–1056 scatter the spikes when the crusher touches them.
    breakaway_active = true;
    breakaway_velocity = -3 - irandom(3);
}
if (breakaway_active) {
    x += 2;
    y += breakaway_velocity++;
    image_angle = (image_angle - 2 + 360) mod 360;
    if (bbox_top >= room_height) {
        instance_destroy();
    }
}
