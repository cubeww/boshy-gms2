++glow_steps;
// The original 50 Hz timer advances by 20 milliseconds per update.
image_alpha = 1 - clamp(20 - dsin(glow_steps * 20 / 8) * 45, 0, 128) / 128;
