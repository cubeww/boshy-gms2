if (settled) {
    exit;
}

x += hsp;
y += vsp;
vsp += fall_acceleration;

if (place_meeting(x, y, [obj_solid, obj_player_backdrop])) {
    // The original pastes the unrotated sprite into the backdrop on impact.
    image_angle = 0;
    settled = true;
} else if (bbox_right < 0 || bbox_left >= room_width || bbox_top >= room_height) {
    instance_destroy();
}
