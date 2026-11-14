++ending_age;
if (ending_age == 950) {
    // Fusion frame 46 G15 advances after the rainbow fades out.
    room_goto(rm_credits);
    exit;
}

if (ending_age <= 400) {
    // G3/G4/G6/G7 add one emitter per step at each of the four thresholds.
    var _emitters = 1 + min(3, ending_age div 100);
    repeat (_emitters) {
        solgryn_victory_burst(x, y, false);
    }
    explosion_clock += 1 + (_emitters - 1) * 0.5;
    if (explosion_clock >= 10) {
        play_explosion(snd_green_greens_kracko_explosion);
        explosion_clock = 0;
    }
    if (_emitters > 1) {
        blur_strength = _emitters - 1;
    }
}

if (ending_age == 400) {
    // G9 hides Solgryn, begins the sky reveal, and plays both explosion samples.
    play_explosion(snd_green_greens_kracko_explosion);
    play_explosion(snd_bomberman_victory_explosion);
    blur_strength = 20;
}
if (ending_age == 400 || ending_age == 410 || ending_age == 420) {
    flash_ink = 0;
}

// Fusion decays the scatter radius by ten percent and rolls a new angle each step.
blur_strength *= 0.9;
var _blur = blur_strength > 0.001 ? blur_strength * 0.01 : 0;
var _angle = _blur > 0 ? irandom(359) : 0;
game_controller.directional_blur_x = dcos(_angle) * _blur;
game_controller.directional_blur_y = dsin(_angle) * _blur;
flash_ink = min(128, flash_ink + 10);
