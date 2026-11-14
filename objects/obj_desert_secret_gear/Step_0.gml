// G950–955 scroll the camera-relative gears and recycle them above the screen.
screen_y += fall_speed;
if (screen_y >= 480) {
    screen_y -= 510;
}
