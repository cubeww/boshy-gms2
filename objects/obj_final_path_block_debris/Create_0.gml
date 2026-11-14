// G873–876 give each chip separate random speeds and ten settled frames.
var _direction = irandom(89);
velocity_x = (10 + 0.8 * (irandom(9) - irandom(9))) * dcos(_direction);
velocity_y = (10 + 0.8 * (irandom(9) - irandom(9))) * dsin(_direction);
position_x = x;
position_y = y;
settled_steps = 0;
