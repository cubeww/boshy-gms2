var _enter = keyboard_check_pressed(vk_enter);
if (attract_steps < 610) {
    if (_enter || ++attract_steps >= 610) {
        settle_title(_enter);
        exit;
    }

    if (attract_steps < 300 || attract_steps >= 350) {
        ++actor_x;
    }
    if (attract_steps >= 350 && attract_steps < 510) {
        actor_y -= 10;
        camera_x = lerp(camera_x, actor_x, 0.16);
        camera_y = lerp(camera_y, actor_y, 0.16);
        camera_width = lerp(camera_width, 400, 0.2);
    } else {
        if (attract_steps >= 510) {
            actor_y = floor(actor_y + actor_vsp + 0.00001);
            actor_vsp += 0.2;
        }
        camera_x = 320;
        camera_y = floor(actor_y / 480) * 480 + 240;
        camera_width = 640;
    }
    if (attract_steps == 350) {
        jump_voice = audio_play_sound(snd_stock_mario_jump, 1, false);
    }
    if (attract_steps == 400) {
        camping_voice = play_boshy_voice(snd_title_camping_noobs);
    }
    exit;
}

++prompt_steps;
logo_scale = lerp(logo_scale, 1.5, 0.2);
notice_steps = max(0, notice_steps - 1);
if (storm_wait <= 0) {
    storm_wait = irandom_range(80, 229);
    storm_transparency = 90;
    if (thunder_voice != -1) {
        audio_stop_sound(thunder_voice);
    }
    thunder_voice = audio_play_sound(thunder_sounds[irandom(array_length(thunder_sounds) - 1)], 1, false);
} else {
    --storm_wait;
    storm_transparency = max(0, storm_transparency - 2);
}

var _escape = keyboard_check_pressed(vk_escape);
var _previous = keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up);
var _next = keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down);

var _mouse_x = -1000;
var _mouse_y = -1000;
var _viewport = game_controller.get_viewport_rectangle();
if (!is_undefined(_viewport)) {
    _mouse_x = (window_mouse_get_x() - _viewport.left) * 640 / _viewport.width;
    _mouse_y = (window_mouse_get_y() - _viewport.top) * 480 / _viewport.height;
}
var _click = mouse_check_button_pressed(mb_left);

if (menu_page == TitlePage.DeleteSlot) {
    if (_previous || _next) {
        delete_confirmed = !delete_confirmed;
    }
    if (_click && point_in_rectangle(_mouse_x, _mouse_y, 220, 268, 312, 294)) {
        delete_confirmed = true;
        _enter = true;
    } else if (_click && point_in_rectangle(_mouse_x, _mouse_y, 328, 268, 420, 294)) {
        delete_confirmed = false;
        _enter = true;
    }
    if (_escape || _enter) {
        if (!_escape && delete_confirmed) {
            game_delete_campaign_slot(slot_index);
        }
        menu_page = TitlePage.Slots;
        menu_index = slot_index;
    }
    exit;
}

if (keyboard_check_pressed(vk_f3)) {
    game_open_title_menu(rm_dresser);
    exit;
}
if (keyboard_check_pressed(vk_f5)) {
    game_open_title_menu(rm_trophies);
    exit;
}

if (menu_page == TitlePage.Prompt) {
    if (_enter || (_click && point_in_rectangle(_mouse_x, _mouse_y, 232, 384, 408, 408))) {
        menu_page = TitlePage.Main;
        menu_index = 0;
    }
    exit;
}

if (_escape) {
    switch (menu_page) {
        case TitlePage.Main:
            menu_page = TitlePage.Prompt;
            break;
        case TitlePage.Slots:
            menu_page = TitlePage.Main;
            menu_index = 0;
            break;
        case TitlePage.Difficulty:
            menu_page = TitlePage.Slots;
            menu_index = slot_index;
            break;
    }
    notice_steps = 0;
    exit;
}

var _choices = main_choices;
if (menu_page == TitlePage.Slots) {
    _choices = slot_choices;
} else if (menu_page == TitlePage.Difficulty) {
    _choices = difficulty_choices;
}
menu_index = clamp(menu_index + _next - _previous, 0, array_length(_choices) - 1);

// Use the same logical screen rectangle for mouse input at every display size.
if (_click) {
    var _hit = -1;
    var _nearest = 0;
    for (var _i = 0; _i < array_length(_choices); ++_i) {
        var _choice = _choices[_i];
        var _left = _choice.x - sprite_get_xoffset(_choice.sprite) * _choice.size;
        var _top = _choice.y - sprite_get_yoffset(_choice.sprite) * _choice.size;
        var _right = _left + sprite_get_width(_choice.sprite) * _choice.size;
        var _bottom = _top + sprite_get_height(_choice.sprite) * _choice.size;
        var _distance = point_distance(_mouse_x, _mouse_y, _choice.x, _choice.y);
        if (point_in_rectangle(_mouse_x, _mouse_y, _left, _top, _right, _bottom) && (_hit < 0 || _distance < _nearest)) {
            _nearest = _distance;
            _hit = _i;
        }
    }
    if (_hit >= 0) {
        menu_index = _hit;
        _enter = true;
    }
}

if (menu_page == TitlePage.Slots) {
    game_campaign_select_title_slot(menu_index);
}

for (var _i = 0; _i < array_length(_choices); ++_i) {
    var _choice = _choices[_i];
    _choice.size = lerp(_choice.size, _i == menu_index ? 1.5 : 1, 0.2);
}

if (menu_page == TitlePage.Slots && keyboard_check_pressed(vk_delete)
    && global.profile.campaign_slots[menu_index].stage != "") {
    slot_index = menu_index;
    delete_confirmed = false;
    menu_page = TitlePage.DeleteSlot;
    exit;
}

if (!_enter) {
    exit;
}

switch (menu_page) {
    case TitlePage.Main:
        switch (menu_index) {
            case 0:
                menu_page = TitlePage.Slots;
                menu_index = global.profile.title_slot;
                break;
            case 1:
                game_open_title_menu(rm_options);
                break;
            case 2:
                notice_steps = 150;
                break;
        }
        break;
    case TitlePage.Slots:
        slot_index = menu_index;
        if (global.profile.campaign_slots[slot_index].stage == "") {
            menu_page = TitlePage.Difficulty;
            menu_index = 0;
        } else {
            game_start_campaign(slot_index);
        }
        break;
    case TitlePage.Difficulty:
        game_start_campaign(slot_index, menu_index);
        break;
}
