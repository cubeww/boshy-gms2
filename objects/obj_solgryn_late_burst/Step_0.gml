if (++burst_age >= 20) {
    instance_destroy();
    exit;
}

// G669–670 use a short additive burst with a fluctuating scale.
image_xscale = 2 + 0.02 * (irandom(19) - irandom(19));
image_yscale = image_xscale;
