if (scroll_speed != 0) {
    // Fusion groups 795–803 scroll in viewport coordinates and wrap the hotspot.
    x += scroll_speed;
    if (x <= -wrap_margin) {
        x += wrap_distance;
    }
    if (x > 740) {
        x -= wrap_distance;
    }
}
