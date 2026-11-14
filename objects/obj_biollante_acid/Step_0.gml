++acid_age;
if (acid_age == 40) {
    instance_destroy();
    exit;
}

// Groups 814–815 keep these trail images stationary as they shrink.
image_angle += 5 + irandom(14);
image_xscale *= 0.98;
image_yscale = image_xscale;
