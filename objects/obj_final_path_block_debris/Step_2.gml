position_x += velocity_x;
position_y += velocity_y;
x = floor(position_x);
y = floor(position_y);
velocity_x *= 0.9;
velocity_y *= 0.9;
if (floor(abs(velocity_x)) + floor(abs(velocity_y)) == 0 && ++settled_steps >= 10) {
    instance_destroy();
}
