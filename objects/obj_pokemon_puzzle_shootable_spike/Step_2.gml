// G747 picks one of the four authored directions every second.
if (--direction_steps <= 0) {
    image_index = irandom(3);
    direction_steps = 50;
}
