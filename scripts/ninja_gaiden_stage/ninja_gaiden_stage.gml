function ninja_gaiden_wall_contact(_player, _probe, _kind) {
    var _hit = false;
    var _left = _player.probe_x + _probe.left;
    var _right = _player.probe_x + _probe.right;
    with (obj_ninja_gaiden_wall_jump) {
        if (wall_jump_kind == _kind && bbox_left <= _right && bbox_right >= _left
            && _player.probe_overlaps(_probe, id)) {
            _hit = true;
            break;
        }
    }
    return _hit;
}
