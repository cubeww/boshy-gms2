++effect_age;
if (sprite_index == spr_sanicz_explosion) {
    image_index = (effect_age * 25 - 1) div 100;
    if (image_index >= image_number) {
        instance_destroy();
    }
    exit;
}

// Groups 1235–1238 grow, shrink, and spin the ambient stars.
var _scale_step = 11 - effect_age;
var _next_scale = image_xscale + _scale_step * 0.015;
if (_next_scale >= 0) {
    image_xscale = _next_scale;
    image_yscale = _next_scale;
}
image_angle += abs(_scale_step - 1);
if (effect_age >= 30) {
    instance_destroy();
}
