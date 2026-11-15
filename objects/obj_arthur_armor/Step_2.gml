if (!visible) {
    if (!instance_exists(rider) || rider.dead) {
        instance_destroy();
        exit;
    }
    if (--armor_steps > 0) {
        exit;
    }
    rider.arthur_armor_lost = true;
    x = rider.x;
    y = rider.y;
    hsp = irandom(3) - irandom(3);
    vsp = -3 - irandom(3);
    visible = true;
}

// G1277–1279 eject one piece from Arthur's hotspot, with gravity and spin.
x = floor(x + hsp);
y = floor(y + vsp);
vsp += 0.2;
image_angle -= hsp * 10;
var _camera = view_camera[0];
var _left = camera_get_view_x(_camera);
var _top = camera_get_view_y(_camera);
if (bbox_left <= _left - 16 || bbox_right + 1 >= _left + camera_get_view_width(_camera) + 16
    || bbox_top <= _top - 16 || bbox_bottom + 1 >= _top + camera_get_view_height(_camera) + 16) {
    instance_destroy();
}
