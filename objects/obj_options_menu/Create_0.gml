game_controller = instance_find(obj_game, 0);
controls_open = false;
capturing_key = false;
capture_hint = "";
selected_row = 0;
vertical_repeat = { direction: 0, age: 0, up_us: 0, down_us: 0 };
horizontal_repeat = { direction: 0, age: 0 };

options = [
    { top: 128, label: "Music Volume", setting: "music_volume", limit: 100,
        help: "Use left/right arrow to \nchange the volume." },
    { top: 177, label: "Speech\nVolume", setting: "speech_volume", limit: 100,
        help: "Use left/right arrow to \nchange the volume." },
    { top: 226, label: "Screen size", action: "display",
        help: "Use left/right arrow to\nchange the screen size." },
    { top: 276, label: "Controls", action: "controls",
        help: "Press enter to change\ncontrols." },
    { top: 325, label: "Special\njumping\nsounds", setting: "special_jump_sounds", limit: 1,
        help: "Enable/disable special\njumping sounds for some\ncharacters." },
    { top: 374, label: "Special\nshooting\nsounds", setting: "special_shoot_sounds", limit: 1,
        help: "Enable/disable special\nshooting sounds for some\ncharacters." },
    { top: 423, label: "Character\nwalk sound", setting: "character_walk_sound", limit: 1,
        help: "Enable/disable the walk\nsound/music for the\nDig Dug character." },
    { top: 472, label: "Special\nshooting\ngraphics", setting: "special_shot_graphics", limit: 1,
        help: "Enable/disable special\nshooting graphics for\nsome characters." },
    { top: 521, label: "Restart\nmusic", setting: "restart_music", limit: 1,
        help: "OFF = The music won't\nrestart when you die or\nrestart." },
    { top: 570, label: "Online death\neffects", action: "unavailable", value: "N/A",
        help: "Applies to blood from\nother players in co-op." },
    { top: 619, label: "Blood\nintensity", setting: "blood_intensity", limit: 200,
        help: "Changes how many blood\nparticles are spawned\nby death." },
    { top: 668, label: "FPS Mark\n(F8)", setting: "show_fps", limit: 1,
        help: "Turn on/off an FPS mark\ndisplayed ingame." },
    { top: 718, label: "Transparency\nof online\nplayers", action: "unavailable", value: "N/A",
        help: "Applies to other players\nin online play." },
    { top: 767, label: "Frame Rate", action: "frame_rate",
        help: "Use left/right to set\nthe frame rate. Applies\nwhen you leave Options." },
    { top: 815, label: "Mirror mode", setting: "mirror", limit: 1,
        help: "Turn on/off mirroring\nof the world." },
    { top: 864, label: "Death\nCounter", setting: "show_deaths", limit: 1,
        help: "Turn on/off the on-screen\ndeath counter while\nplaying." },
    { top: 913, label: "Auto Fire", setting: "auto_fire", limit: 1,
        help: "Hold Shoot to fire\nrepeatedly." },
    { top: 962, label: "Low Input\nLatency", setting: "low_input_latency", limit: 1,
        help: "Apply horizontal input\non the current frame." }
];

controls_row = 3;
speech_row = 1;
marker_y = 151;
bindings = [
    { top: 128, label: "Move Left", setting: "left" },
    { top: 177, label: "Move Right", setting: "right" },
    { top: 226, label: "Move Up", setting: "up" },
    { top: 276, label: "Move Down", setting: "down" },
    { top: 325, label: "Jump", setting: "jump" },
    { top: 374, label: "Shoot", setting: "shoot" },
    { top: 423, label: "Restart", setting: "restart" },
    { top: 472, label: "Back to\nOptions", action: "back" }
];

game_controller.start_stage_music(snd_options_music, true, false, 44100);
speech_preview_instance = -1;
speech_preview_steps = 0;

handle_escape = function() {
    if (capturing_key) {
        capturing_key = false;
        return true;
    }

    if (controls_open) {
        controls_open = false;
        selected_row = controls_row;
        return true;
    }

    return false;
};

read_direction = function(_negative, _positive, _repeat, _timed = false) {
    var _direction = keyboard_check(_positive) - keyboard_check(_negative);
    if (_direction != _repeat.direction) {
        _repeat.direction = _direction;
        _repeat.age = 0;
        return _direction;
    }

    if (_direction != 0) {
        ++_repeat.age;
        if (_repeat.age >= 10) {
            if (_timed) {
                var _timer = _direction < 0 ? "up_us" : "down_us";
                var _elapsed = struct_get(_repeat, _timer) + delta_time;
                var _due = _elapsed >= 100000;
                struct_set(_repeat, _timer, _elapsed - (_due ? 100000 : 0));
                return _due ? _direction : 0;
            }
            if ((_repeat.age - 10) mod 5 == 0) {
                return _direction;
            }
        }
    }
    return 0;
};
