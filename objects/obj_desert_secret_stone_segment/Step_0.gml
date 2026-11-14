var _floor = instance_find(obj_desert_secret_rising_floor, 0);
y -= (_floor == noone ? 0 : _floor.rise_speed) + 6;
if (bbox_bottom < camera_get_view_y(view_camera[0]) - 128) {
    instance_destroy();
}
