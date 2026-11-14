// G734 uses the current boss hotspot throughout the additive charge.
if (!instance_exists(charge_boss) || ++charge_age >= 120) {
    instance_destroy();
    exit;
}
x = charge_boss.x;
y = charge_boss.y;
image_angle = (image_angle + 15) mod 360;
image_xscale += 0.025;
image_yscale = image_xscale;
