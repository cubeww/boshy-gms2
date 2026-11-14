if (scroll_speed != 0) {
    // G932–940 use hotspot coordinates and fixed viewport margins.
    x += scroll_speed;
    if (x <= -wrap_margin) {
        x += wrap_distance;
    }
    if (x > 740) {
        x -= wrap_distance;
    }
}
