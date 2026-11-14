function biollante_vines_step(_age, _reaction) {
    var _lower = inst_biollante_lower_vine;
    var _upper = inst_biollante_upper_vine;
    if (!instance_exists(_lower) || !instance_exists(_upper)) {
        return;
    }

    // Groups 702 and 745 initialize the separate oscillation counters.
    if (_age == 830 || _age == 860) {
        _lower.wave_phase = 0;
        _upper.wave_phase = 0;
    }
    if (_age == 860) {
        _lower.image_xscale = 3.5;
        _lower.image_yscale = 3.5;
        _upper.image_xscale = 3.5;
        _upper.image_yscale = 3.5;
    }

    // Groups 704–707 raise the lower head first, then lower the upper head.
    if (_age >= 860 && _age < 1300) {
        if (_age < 900) {
            _lower.y -= 5;
        } else if (_age < 940) {
            _upper.y += 5;
        } else if (_age >= 1200) {
            _lower.y += 5;
            _upper.y -= 5;
        }
        var _lower_angle = dsin(_lower.wave_phase div 8) * 60;
        _lower.image_angle = sign(_lower_angle) * floor(abs(_lower_angle));
        _upper.image_angle = floor(180 + dsin(_upper.wave_phase div 7) * 50);
        _lower.wave_phase += 25;
        _upper.wave_phase += 25;
    }

    // A reflected shot retracts the heads. The second turn restores their positions.
    if (_reaction == 20 || _age == 1736) {
        _lower.y = _lower.ystart;
        _upper.y = _upper.ystart;
    }
    if (_reaction == 20) {
        _lower.image_xscale = 1;
        _lower.image_yscale = 1;
        _upper.image_xscale = 1;
        _upper.image_yscale = 1;
        _lower.image_angle = 0;
        _upper.image_angle = 0;
    }
    if (_age == 1736) {
        _lower.x = _lower.xstart;
        _upper.x = _upper.xstart;
    }
}
