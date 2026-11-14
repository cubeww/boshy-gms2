function solgryn_early_view_bounds(_sprite, _frame) {
    static _solgryn_early_shot = [[-22, -5, 9, 7], [-24, -8, 11, 9], [-25, -5, 12, 6], [-26, -8, 13, 9]];
    static _solgryn_early_ice_burst = [[-34, -22, 53, 20], [-41, -21, 53, 19], [-15, -26, 51, 24], [-20, -25, 56, 23]];
    static _solgryn_early_ice_burst_left = [[-52, -22, 35, 20], [-52, -21, 42, 19], [-50, -26, 16, 24], [-55, -25, 21, 23]];
    static _solgryn_late_shield_plasma = [[-16, -14, 15, 15], [-17, -13, 15, 19], [-18, -14, 14, 17], [-16, -14, 15, 18]];
    switch (_sprite) {
        case spr_solgryn_early_shot:
            return _solgryn_early_shot[_frame mod array_length(_solgryn_early_shot)];
        case spr_solgryn_early_ice_burst:
            return _solgryn_early_ice_burst[_frame mod array_length(_solgryn_early_ice_burst)];
        case spr_solgryn_early_ice_burst_left:
            return _solgryn_early_ice_burst_left[_frame mod array_length(_solgryn_early_ice_burst_left)];
        case spr_solgryn_late_shield_plasma:
            return _solgryn_late_shield_plasma[_frame mod array_length(_solgryn_late_shield_plasma)];
    }
    var _left = -sprite_get_xoffset(_sprite);
    var _top = -sprite_get_yoffset(_sprite);
    return [_left, _top, _left + sprite_get_width(_sprite), _top + sprite_get_height(_sprite)];
}
