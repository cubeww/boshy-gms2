if (fan_rate != 0) {
    exit;
}

// G1271–1275 create three independently swinging beams at each side.
if (++scene_steps == 1) {
    visible = false;
    for (var _side = 0; _side <= 1; ++_side) {
        repeat (3) {
            var _beam = instance_create_layer(_side * room_width, 0, "SpotlightEffects", obj_cheetah_men_spotlight);
            _beam.fan_rate = (5 + irandom(9)) * 0.01;
            _beam.fan_angle = _side == 0 ? 45 : -45;
            _beam.image_index = min(irandom(5), _beam.image_number - 1);
        }
    }
}

// G1247 resets the transparency to 200 before G1270 fades each beat.
var _alpha = 0;
if (scene_steps >= 20) {
    _alpha = max(0, (55 - 3 * (1 + scene_steps mod 20)) / 255);
}
var _milliseconds = scene_steps * 20;
with (obj_cheetah_men_spotlight) {
    image_alpha = _alpha;
    image_angle = floor(dsin(_milliseconds * fan_rate) * 30 + fan_angle);
}
