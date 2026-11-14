if (fade_age == 0) {
    exit;
}

// G1210 and G1211 advance transparency by ten and remove the sky on step 25.
if (++fade_age >= 25) {
    instance_destroy();
    exit;
}
image_alpha = max(0, 1 - fade_age * 10 / 128);
