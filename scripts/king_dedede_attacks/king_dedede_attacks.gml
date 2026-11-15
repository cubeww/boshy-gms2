enum KingDededePuzzlePhase {
    Waiting,
    Demonstrating,
    Answering,
    Checking,
    Rejected
}

function king_dedede_attacks_setup() {
    // Fusion group 68 starts Ez-mode with two commands. The other modes start with three.
    dedede_command_count = game_campaign_difficulty() == 0 ? 2 : 3;
    dedede_commands = [
        { prompt: "Right!", sprite: spr_king_dedede_right, sound: snd_green_greens_middle_reflect, rate: 0.2, loop: true },
        { prompt: "Left!", sprite: spr_king_dedede_left, sound: snd_king_dedede_shoot, rate: 0.2, loop: true },
        { prompt: "Down!", sprite: spr_king_dedede_down, sound: snd_king_dedede_blip, rate: 0.5, loop: false },
        { prompt: "Jump!", sprite: spr_king_dedede_jump, sound: snd_king_dedede_jump, rate: 0.3, loop: false },
        { prompt: "Attack!", sprite: spr_king_dedede_attack, sound: snd_king_dedede_roll, rate: 0.7, loop: false }
    ];
    dedede_sequence = [];
    dedede_response = [];
    dedede_rounds_answered = 0;
    dedede_puzzle_phase = KingDededePuzzlePhase.Waiting;
    dedede_puzzle_age = 0;
    dedede_round_prompt = "Ready?!";
    dedede_prompt_steps = 100;
    dedede_prompt_alpha = 1;
    dedede_answer_correct = false;
    dedede_show_puzzle = true;
    dedede_spotlight_x = -166;
    dedede_spotlight_y = 307;
    dedede_spotlight_alpha = 0;
    dedede_wrong_effect = noone;
    dedede_wrong_age = -1;
    dedede_wrong_blur = 0;
    king_dedede_puzzle_pose(spr_king_dedede_thinking);
}

function king_dedede_puzzle_pose(_sprite, _rate = 0, _loop = false) {
    sprite_index = _sprite;
    image_index = 0;
    image_speed = 0;
    dedede_pose_age = 0;
    dedede_pose_rate = _rate;
    dedede_pose_loop = _loop;
}

function king_dedede_puzzle_prompt(_text, _steps) {
    dedede_round_prompt = _text;
    dedede_prompt_steps = _steps;
    dedede_prompt_alpha = 1;
}

function king_dedede_demonstrate_command() {
    var _command = irandom(array_length(dedede_commands) - 1);
    var _definition = dedede_commands[_command];
    array_push(dedede_sequence, _command);
    king_dedede_puzzle_pose(_definition.sprite, _definition.rate, _definition.loop);
    king_dedede_puzzle_prompt(_definition.prompt, 42);
    audio_play_sound(_definition.sound, 1, false);
    dedede_puzzle_age = 0;
    if (array_length(dedede_sequence) == dedede_command_count) {
        dedede_puzzle_phase = KingDededePuzzlePhase.Answering;
    }
}

function king_dedede_capture_response() {
    var _keys = global.settings.keys;
    // These keys follow the input event order in Fusion groups 710–714.
    var _inputs = [game_horizontal_key(_keys, true), game_horizontal_key(_keys, false), _keys.down, _keys.jump, _keys.shoot];
    for (var _i = 0; _i < array_length(_inputs); ++_i) {
        if (keyboard_check_pressed(_inputs[_i]) && array_length(dedede_response) < dedede_command_count) {
            array_push(dedede_response, _i);
            audio_play_sound(dedede_commands[_i].sound, 1, false);
        }
    }
    if (array_length(dedede_response) == dedede_command_count) {
        dedede_puzzle_phase = KingDededePuzzlePhase.Checking;
        dedede_puzzle_age = 0;
        king_dedede_puzzle_pose(spr_king_dedede_thinking);
        king_dedede_puzzle_prompt("Hmm!", 500);
        audio_play_sound(snd_king_dedede_drumroll, 1, false);
    }
}

function king_dedede_check_response(_player) {
    for (var _i = 0; _i < dedede_command_count; ++_i) {
        if (dedede_response[_i] != dedede_sequence[_i]) {
            dedede_puzzle_phase = KingDededePuzzlePhase.Rejected;
            king_dedede_puzzle_pose(spr_king_dedede_wrong_answer);
            king_dedede_puzzle_prompt("WRONG!", 500);
            audio_play_sound(snd_king_dedede_boo, 1, false);
            audio_play_sound(snd_king_dedede_wrong, 1, false);
            var _blare = audio_play_sound(snd_hello_kitty_laser, 1, false);
            audio_sound_gain(_blare, 0.4, 0);
            // Group 722 creates the beam at the action point of the wrong-answer pose.
            dedede_wrong_effect = instance_create_depth(x - 16, y - 28, depth, obj_green_greens_prop, {
                sprite_index: spr_king_dedede_wrong_effect, image_speed: 0,
                image_xscale: 3, image_yscale: 3, visible: false
            });
            dedede_wrong_age = 0;
            dedede_wrong_blur = 0.0225;
            _player.die();
            return;
        }
    }

    king_dedede_puzzle_pose(spr_king_dedede_right_answer);
    king_dedede_puzzle_prompt("RIGHT?!", 500);
    audio_play_sound(snd_king_dedede_cheer, 1, false);
    dedede_answer_correct = true;
}

function king_dedede_attacks_step(_player) {
    if (!dedede_show_puzzle) {
        return;
    }

    if (dedede_prompt_steps > 0) {
        --dedede_prompt_steps;
    } else {
        dedede_prompt_alpha = max(0, dedede_prompt_alpha - 10 / 128);
    }

    if (_player == noone || _player.input_locked) {
        return;
    }

    ++dedede_puzzle_age;
    ++dedede_pose_age;
    var _frame = floor(dedede_pose_age * dedede_pose_rate);
    image_index = dedede_pose_loop ? _frame mod image_number : min(_frame, image_number - 1);
    if (dedede_spotlight_x >= 0) {
        dedede_spotlight_alpha = min(80 / 128, dedede_spotlight_alpha + 5 / 128);
    }

    switch (dedede_puzzle_phase) {
        case KingDededePuzzlePhase.Waiting:
            if (dedede_puzzle_age >= 150) {
                dedede_sequence = [];
                dedede_response = [];
                dedede_answer_correct = false;
                dedede_puzzle_phase = KingDededePuzzlePhase.Demonstrating;
                dedede_spotlight_x = x;
                dedede_spotlight_y = 307;
                dedede_spotlight_alpha = 0;
                king_dedede_demonstrate_command();
            }
            break;

        case KingDededePuzzlePhase.Demonstrating:
            if (dedede_puzzle_age == 43) {
                king_dedede_puzzle_pose(spr_king_dedede_thinking);
            } else if (dedede_puzzle_age == 61) {
                king_dedede_demonstrate_command();
            }
            break;

        case KingDededePuzzlePhase.Answering:
            if (dedede_puzzle_age == 60) {
                king_dedede_puzzle_pose(spr_king_dedede_thinking);
                king_dedede_puzzle_prompt("Now you!", 500);
                dedede_spotlight_x = 127;
                dedede_spotlight_y = 350;
                dedede_spotlight_alpha = 0;
            }
            king_dedede_capture_response();
            break;

        case KingDededePuzzlePhase.Checking:
            // The original answer clock advances by 1.5 until its 200 and 250 thresholds.
            if (dedede_puzzle_age == 134) {
                king_dedede_check_response(_player);
            } else if (dedede_puzzle_age == 167) {
                ++dedede_rounds_answered;
                if (dedede_rounds_answered mod 2 == 0) {
                    ++dedede_command_count;
                }
                dedede_puzzle_phase = KingDededePuzzlePhase.Waiting;
                dedede_puzzle_age = 0;
            }
            break;

        case KingDededePuzzlePhase.Rejected:
            // A surviving player can retry once the wrong-answer effect has finished.
            if (dedede_wrong_age < 0) {
                dedede_puzzle_phase = KingDededePuzzlePhase.Waiting;
                dedede_puzzle_age = 0;
            }
            break;
    }
}

function king_dedede_wrong_effect_step() {
    if (dedede_wrong_age < 0) {
        return;
    }

    var _age = dedede_wrong_age++;
    if (instance_exists(dedede_wrong_effect)) {
        if (_age < 50) {
            dedede_wrong_effect.image_index = _age mod dedede_wrong_effect.image_number;
        } else {
            // Groups 921–922 end the active beam and play its native Disappearing clip.
            if (_age == 50) {
                dedede_wrong_effect.sprite_index = spr_king_dedede_wrong_effect_disappear;
            }
            var _frame = _age - 50;
            if (_frame < dedede_wrong_effect.image_number) {
                dedede_wrong_effect.image_index = _frame;
            } else {
                instance_destroy(dedede_wrong_effect);
                dedede_wrong_effect = noone;
            }
        }
    }

    if (_age >= 50) {
        dedede_wrong_blur *= 0.9;
    }
    if (dedede_wrong_blur < 0.0005) {
        dedede_wrong_blur = 0;
        if (dedede_wrong_effect == noone) {
            dedede_wrong_age = -1;
        }
    }
    var _angle = irandom(359);
    game_controller.directional_blur_x = lengthdir_x(dedede_wrong_blur, _angle);
    game_controller.directional_blur_y = lengthdir_y(dedede_wrong_blur, _angle);
}

function king_dedede_attacks_draw() {
    if (!dedede_show_puzzle) {
        return;
    }
    if (dedede_spotlight_alpha > 0) {
        draw_sprite_ext(spr_king_dedede_response_marker, 0, dedede_spotlight_x, dedede_spotlight_y,
            1, 1, 0, c_white, dedede_spotlight_alpha);
    }

    draw_sprite(spr_king_dedede_arrow, 0, x - 18, y - 26);
    var _text_width = string_length(dedede_round_prompt) * 8;
    draw_boshy_text(dedede_round_prompt, x - 25 - _text_width, y - 30, dedede_prompt_alpha);
}
