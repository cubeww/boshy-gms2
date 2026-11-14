// G803/G809 scatter, fade, and shrink the independently animated echo.
image_alpha = max(0, image_alpha - 15 / 255);
image_xscale -= 0.03;
image_yscale = image_xscale;
x += irandom(2) - irandom(2);
y += irandom(2) - irandom(2);
if (++trail_age > 30) {
    instance_destroy();
}
