switch (source_handle) {
    case 997: wario_floating_skull_step(); break;
    case 1013:
    case 1014:
        // Groups 777–780 use the placement's Y to offset the three pairs.
        x = floor(xstart + swing_direction * dsin(swing_phase div 3) * (10 + ystart - 1120));
        swing_phase += 25;
        break;
}
