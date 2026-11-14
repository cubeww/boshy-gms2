// Group 866 accelerates the two capsule colors to the left by the same amount.
x = floor(x - drift_speed - 1);
drift_speed += 0.2;
if (bbox_right < 0) {
    instance_destroy();
}
