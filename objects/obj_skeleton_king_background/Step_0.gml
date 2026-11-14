// Groups 1027–1028 scroll the fixed backdrop one pixel per 30 ms and wrap at 32 pixels.
brick_elapsed_ms += 1000 / game_get_speed(gamespeed_fps);
var _steps = brick_elapsed_ms div 30;
brick_elapsed_ms -= _steps * 30;
brick_scroll = (brick_scroll + _steps) mod 32;
