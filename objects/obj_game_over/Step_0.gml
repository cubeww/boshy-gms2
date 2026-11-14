++elapsed_steps;

// The original alternates its scale target every 20 steps.
var _pulse = ((elapsed_steps - 1) div 20) mod 2;
var _target_scale = _pulse == 0 ? 1.2 : 1;
overlay_scale = lerp(overlay_scale, _target_scale, 0.2);
