if (!instance_exists(particle_boss) || ++particle_age >= 25) {
    instance_destroy();
    exit;
}
x = floor(lerp(x, particle_boss.x, 0.1));
y = floor(lerp(y, particle_boss.y, 0.1));
if (particle_age >= 5) {
    image_alpha = max(0, 1 - (particle_age - 4) * 10 / 128);
}
