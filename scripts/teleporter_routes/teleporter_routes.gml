function teleporter_portal_label(_player) {
    if (_player == noone || _player.dead) {
        return noone;
    }

    var _candidate = noone;
    var _order = 0;
    with (obj_teleporter_portal) {
        // One shared Text Blitter keeps the last name tag selected in Fusion event order.
        if (!is_undefined(route) && route_handle > _order && abs(_player.x - x) < 50
            && _player.y > y - 150 && _player.y < y + 80) {
            _candidate = id;
            _order = route_handle;
        }
    }
    return _candidate;
}

function teleporter_draw_portal_label(_portal) {
    if (instance_exists(_portal)) {
        draw_boshy_text(_portal.route.title, _portal.x, _portal.y - 90);
    }
}
