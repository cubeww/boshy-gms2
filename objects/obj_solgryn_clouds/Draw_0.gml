var _camera = camera_get_active();
if (_camera == -1) {
    exit;
}

var _view_top = camera_get_view_y(_camera);
if (y + 280 <= _view_top || y >= _view_top + camera_get_view_height(_camera)) {
    exit;
}

var _boss = instance_find(obj_solgryn, 0);
if (remove_on_rush && _boss != noone && _boss.fight_age >= 8000) {
    exit;
}

solgryn_draw_parallax(cloud_sprite, solgryn_parallax_rows(cloud_sprite), x, y, cloud_scroll, 641);
