fade_age = 0;
image_speed = 0;

begin_fade = function() {
    if (fade_age == 0) {
        // G1121 starts the fade and G1210 applies its first decrement on the same step.
        fade_age = 1;
        image_alpha = 118 / 128;
    }
};
