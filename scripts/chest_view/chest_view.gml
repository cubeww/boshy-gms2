function chest_view_update(_game, _player, _age) {
    var _state = _game.chest_view_state;
    var _fixed = room == rm_secret_1_1;
    var _opening = _player != noone && _age > 0;
    if (!_fixed && !_opening && _state.width >= 644.5) {
        _state.width = 645;
        _state.opening = false;
        _game.chest_view_crop = undefined;
        return;
    }

    var _camera = view_camera[0];
    var _page_x = camera_get_view_x(_camera);
    var _page_y = camera_get_view_y(_camera);
    var _page_width = camera_get_view_width(_camera);
    var _page_height = camera_get_view_height(_camera);
    var _track_camera = room == rm_ryu || room == rm_cheetah_men;
    // A few rooms already build the native (-1, -2) offset into their source camera.
    var _offset_x = room == rm_cheetah_men || room == rm_pokemon_puzzle || room == rm_secret_jtv ? -1 : 0;
    var _offset_y = _offset_x == -1 || room == rm_desert ? -2 : 0;
    var _center_x = 319 - _offset_x;
    var _center_y = 238 - _offset_y;
    if (_fixed) {
        // The 1-1 Viewport samples the same point of the scrolling page throughout.
        _center_x = 400;
        _center_y = 245;
        if (_state.opening && !_opening) {
            _state.target = 640;
        }
    } else if (_opening) {
        if (!_state.opening) {
            _state.x = _page_x + _center_x;
            _state.y = _page_y + (_track_camera ? _center_y : 246 - _offset_y);
        }
        if (_age < 200 || _track_camera) {
            _state.x = lerp(_state.x, floor(_player.x), 0.2) + clamp(floor(_player.x), -1, 1);
            _state.y = lerp(_state.y, floor(_player.y), 0.2) + clamp(floor(_player.y), -1, 1);
        }
        _center_x = _state.x - _page_x - (_track_camera ? 6 : 5);
        _center_y = _state.y - _page_y;
    } else if (room == rm_ryu) {
        _center_x = _state.x - _page_x - 1;
        _state.x = lerp(_state.x, _page_x + _page_width / 2, 0.2) + 1;
    }
    _state.opening = _opening;

    // Viewport action 83 positions the raw signed rectangle before clamping its size.
    var _width = sign(_state.width - 5) * floor(abs(_state.width - 5));
    var _height_expr = _state.width * 0.75 - 2.5;
    var _height = sign(_height_expr) * floor(abs(_height_expr));
    var _half_width = sign(_width) * (abs(_width) div 2);
    var _half_height = sign(_height) * (abs(_height) div 2);
    var _scale_x = _game.render_width / _page_width;
    var _scale_y = _game.render_height / _page_height;
    _game.chest_view_crop = {
        left: (floor(_center_x) - _half_width) * _scale_x,
        top: (floor(_center_y) - _half_height) * _scale_y,
        width: max(1, _width) * _scale_x,
        height: max(1, _height) * _scale_y
    };

    // Fusion draws the previous displayed width, then eases it toward the target.
    var _target = _state.target - (_opening ? min(_age, 199) * 2 : 0);
    _state.width = lerp(_state.width, _target, 0.2) + clamp(_target, -1, 1);
}

function chest_view_sample(_crop, _x, _y, _width, _height) {
    return {
        x: clamp(_crop.left + _x * _crop.width / _width, 0.5, _width - 0.5),
        y: clamp(_crop.top + _y * _crop.height / _height, 0.5, _height - 0.5)
    };
}
