beam_age = 0;
appear_frame = 0;
fading = false;
fade_age = 0;
image_speed = 0;
depth = -81;

begin_fade = function() {
    if (fading) {
        return;
    }
    fading = true;
    // Fusion clears collisions while the Disappearing animation plays.
    sprite_index = -1;
    depth = -81;
};
