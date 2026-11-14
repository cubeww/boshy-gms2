// G886 types a letter every 50 ms during typing; G888–893 animate its arrival.
var _length = string_length(line);
if (letters_shown < _length) {
    letter_time += 20;
    if (letter_time >= 50) {
        letter_time -= 50;
        ++letters_shown;
        audio_play_sound(snd_ryu_dialogue_tick, 1, false);
    }
}
if (dialogue_bob > 0) {
    --dialogue_bob;
    if (dialogue_bob_clock >= 2) {
        dialogue_draw_y = y + (dialogue_bob_clock mod 4 == 0 ? -dialogue_bob : dialogue_bob);
    }
    ++dialogue_bob_clock;
} else {
    dialogue_draw_y = y;
}
if (letters_shown == _length && ++finished_age >= _length * 4) {
    instance_destroy();
}
