// Fusion plays the extension once, then repeats subimages 3–4 once more.
++beam_age;
if (beam_fade_age >= 0) {
    ++beam_fade_age;
    image_alpha = max(0, 1 - beam_fade_age * 5 / 128);
    if (beam_fade_age >= 50) {
        instance_destroy();
    }
} else {
    var _frame = floor(beam_age * 0.09);
    if (_frame >= 7) {
        beam_fade_age = 0;
    } else {
        image_index = _frame < 5 ? _frame : _frame - 2;
    }
}
