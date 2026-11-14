// G883–884 use the previous phase for height and the incremented phase for angle.
x -= 15;
var _next_y = y + dsin(wave_age * 15) * 6 - 5;
y = sign(_next_y) * floor(abs(_next_y));
var _angle = dsin(++wave_age * 10) * 15;
image_angle = sign(_angle) * floor(abs(_angle));
if (x < -64) {
    instance_destroy();
}
