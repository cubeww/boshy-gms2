phase = DesertPhase.Right;
active = true;
art_sprite = spr_desert_phase_right;
art_age = 0;
image_speed = 0;
image_alpha = (128 - 60) / 128;

set_active = function(_active) {
    if (_active != active) {
        active = _active;
        layer = layer_get_id(_active ? "Hazards" : "Foreground Gameplay");
        // The foreground animation keeps advancing independently of its collision mask.
        sprite_index = _active ? art_sprite : -1;
        image_index = art_age div 2;
    }
};
