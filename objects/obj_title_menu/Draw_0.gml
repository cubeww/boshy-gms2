var _draw_prompt_font = function(_text, _left, _top, _scale = 1) {
    for (var _i = 1; _i <= string_length(_text); ++_i) {
        var _glyph = ord(string_char_at(_text, _i)) - 32;
        draw_sprite_part_ext(spr_title_prompt_font, 0, (_glyph mod 32) * 16, (_glyph div 32) * 18,
            16, 18, round(_left + (_i - 1) * 16 * _scale), round(_top), _scale, _scale, c_white, 1);
    }
};

var _draw_choices = function(_choices, _selected, _alpha = 1) {
    for (var _i = 0; _i < array_length(_choices); ++_i) {
        var _choice = _choices[_i];
        var _frame = _i == _selected ? 1 : 0;
        draw_sprite_ext(_choice.sprite, _frame, _choice.x, _choice.y, _choice.size, _choice.size, 0, c_white, _alpha);
    }
};

if (attract_steps < 610) {
    var _scale = 640 / camera_width;
    var _left = camera_x - camera_width / 2;
    var _top = camera_y - (480 / _scale) / 2;
    var _draw_world = function(_sprite, _frame, _x, _y, _angle, _left, _top, _scale) {
        draw_sprite_ext(_sprite, _frame, round((_x - _left) * _scale), round((_y - _top) * _scale),
            _scale, _scale, _angle, c_white, 1);
    };

    _draw_world(spr_title_cinematic_terrain, 0, 0, 1120, 0, _left, _top, _scale);
    _draw_world(spr_title_platform, 0, 398, 288, 0, _left, _top, _scale);

    var _spike_frame = (attract_steps div 4) mod 11;
    for (var _i = 0; _i < array_length(spikes_up); ++_i) {
        _draw_world(spr_title_cinematic_spike_up, _spike_frame, spikes_up[_i][0], spikes_up[_i][1], 0, _left, _top, _scale);
        _draw_world(spr_title_cinematic_spike_down, _spike_frame, spikes_down[_i][0], spikes_down[_i][1], 0, _left, _top, _scale);
    }

    var _actor_frame = 0;
    if (attract_steps < 300) {
        var _running = [0, 2, 3, 2, 0, 4, 5, 4];
        _actor_frame = _running[(attract_steps div 5) mod array_length(_running)];
    } else if (attract_steps >= 350) {
        _actor_frame = 6;
        _draw_world(spr_title_cameo_left, 0, 154, 1193, darctan2(actor_x - 154, actor_y - 1193) + 90, _left, _top, _scale);
        _draw_world(spr_title_cameo_right, 0, 382, 1700, darctan2(actor_x - 382, actor_y - 1700) + 90, _left, _top, _scale);
        _draw_prompt_font("I WANNA...", (272 - _left) * _scale, (1656 - _top) * _scale, _scale);
        _draw_prompt_font("...BE THE...", (144 - _left) * _scale, (1144 - _top) * _scale, _scale);
    }
    _draw_world(spr_boshy_right, _actor_frame, actor_x, actor_y, 0, _left, _top, _scale);
    if (attract_steps >= 510) {
        draw_boshy_text("BOSHY!", round((actor_x + 33 - _left) * _scale), round((actor_y - 20 - _top) * _scale));
    }
} else {
    // The original storm fades over the white room clear color.
    draw_set_color(c_white);
    draw_rectangle(0, 0, 639, 479, false);
    draw_sprite_ext(spr_title_background, 0, -112, 0, 1, 1, 0, c_white, 1 - storm_transparency / 128);
    draw_sprite_ext(spr_title_status_panel, 0, 0, 192, 1, 1, 0, c_white, 0.23);
    draw_sprite(spr_title_platform, 0, 398, 288);
    title_draw_collectables();
    draw_sprite(spr_boshy_right, (prompt_steps div 8) mod 2, 446, 287);
    draw_boshy_text(string_copy("It's BOSHY time!", 1, min(16, prompt_steps div 2)), 479, 267);
    draw_sprite_ext(spr_title_logo, 0, 299, 92, logo_scale, logo_scale, 0, c_white, 1);

    draw_sprite(spr_title_twitter, 0, 107, 448);
    draw_set_font(-1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(127, 440, "twitter.com/Soulgryn");

    if (menu_page == TitlePage.Prompt && (prompt_steps div 30) mod 2 == 0) {
        _draw_prompt_font("PRESS START", 232, 384);
    }
    if (menu_page == TitlePage.Main) {
        _draw_choices(main_choices, menu_index);
    }
    if (menu_page == TitlePage.Slots || menu_page == TitlePage.DeleteSlot || menu_page == TitlePage.Difficulty) {
        var _on_slots = menu_page != TitlePage.Difficulty;
        var _slot = _on_slots ? menu_index : slot_index;
        var _save = global.profile.campaign_slots[_slot];
        var _has_save = _save.stage != "";
        var _preview = spr_tutorial_background;
        var _preview_x = 224;
        var _preview_y = 32;
        var _stage = "Tutorial";
        switch (_save.stage) {
            case "prehistorik":
                _preview = spr_prehistorik_mountains;
                _stage = "First World - Prehistorik";
                break;
            case "hello_kitty":
                _preview = spr_hello_kitty_hearts_wide;
                _stage = "First Boss - Hello Kitty";
                break;
            case "green_greens":
                _preview = spr_green_greens_hills;
                _stage = "Second World - Green Greens";
                break;
            case "king_dedede":
                _preview = spr_king_dedede_arena_background;
                _stage = "Mini-Boss - King Dedede";
                break;
            case "ryu":
                _preview = spr_ryu_arena_approach;
                _preview_y = 64;
                _stage = "Second Boss - Ryu";
                break;
            case "cheetahmen":
                _preview = spr_cheetahmen_preview;
                _stage = "Third World - Cheetahmen II";
                break;
            case "gastly":
                _preview = spr_gastly_background;
                _stage = "Gastly Fight";
                break;
            case "mario":
                _preview = spr_mario_arena_background;
                _stage = "Third Boss - Mario";
                break;
            case "vvvvvv":
                _preview = spr_vvvvvv_preview;
                _stage = "Fourth World - VVVVVV";
                break;
            case "biollante":
                _preview = spr_biollante_arena_preview;
                _stage = "Fourth Boss - Biollante";
                break;
            case "wario":
                _preview = spr_wario_preview;
                _stage = "Fifth World - Wario";
                break;
            case "sanicz":
                _preview = spr_sanicz_preview;
                _stage = "Fifth Boss - Sanicz";
                break;
            case "castlevania":
                _preview = spr_castlevania_preview;
                _stage = "Sixth World - Castlevania";
                break;
            case "gradius":
                _preview = spr_gradius_preview;
                _stage = "Midway - Gradius";
                break;
            case "skeleton_king":
                _preview = spr_skeleton_king_preview;
                _stage = "Sixth Boss - Skeleton King & Blob";
                break;
            case "milon":
                _preview = spr_milon_preview;
                _preview_y = 294;
                _stage = "Seventh World - Milon's Secret Castle";
                break;
            case "milon_depths":
                _preview = spr_milon_depths_preview;
                _preview_x = 32;
                _preview_y = 196;
                _stage = "Seventh World 7.5 - Metal Gear!";
                break;
            case "mega_man":
                _preview = spr_mega_man_arena_preview;
                _preview_x = 536;
                _preview_y = 406;
                _stage = "Seventh Boss - Mega Man";
                break;
            case "mega_man_world":
                _preview = spr_mega_man_world_preview;
                _preview_x = 338;
                _preview_y = 196;
                _stage = "Eighth World - Mega Man";
                break;
            case "shang_tsung":
                _preview = spr_shang_tsung_arena_preview;
                _preview_x = 520;
                _preview_y = 300;
                _stage = "Eighth Boss - Shang Tsung";
                break;
            case "kid_icarus":
                _preview = spr_kid_icarus_preview;
                _preview_x = 20;
                _preview_y = 320;
                _stage = "Ninth World - Kid Icarus";
                break;
            case "bomberman":
                _preview = spr_bomberman_arena_preview;
                _preview_x = 268;
                _preview_y = 280;
                _stage = "Ninth Boss - Bomberman";
                break;
            case "ninja_gaiden":
                _preview = spr_ninja_gaiden_preview;
                _preview_x = 6;
                _preview_y = 375;
                _stage = "Tenth World - Ninja Gaiden";
                break;
            case "missingno":
                _preview = spr_missingno_arena_preview;
                _preview_x = 115;
                _preview_y = 332;
                _stage = "Tenth Boss - MissingNo.";
                break;
            case "desert":
                _preview = spr_desert_preview;
                _preview_x = 12;
                _preview_y = 348;
                _stage = "Eleventh World - Desert";
                break;
            case "desert_secret":
                _preview = spr_desert_secret_preview;
                _preview_x = 267;
                _preview_y = 223;
                _stage = "THIS IS A LVL";
                break;
            case "final_path":
                _preview = spr_final_path_preview;
                _preview_x = 268;
                _preview_y = 306;
                _stage = "Final Path";
                break;
            case "solgryn":
                _preview = spr_solgryn_preview;
                _preview_x = 268;
                _preview_y = 408;
                _stage = "Eleventh Boss - Solgryn";
                break;
            case "teleporter":
                _preview = spr_teleporter_background;
                _preview_x = 268;
                _preview_y = 280;
                _stage = "Teleporter Room";
                break;
        }
        if (_on_slots) {
            if (_has_save) {
                draw_sprite_part(_preview, 0, _preview_x, _preview_y, 104, 72, 265, 253);
                draw_sprite(spr_title_save_detail, 1, 253, 241);
            } else {
                draw_sprite(spr_title_save_detail, 0, 253, 241);
            }
            _draw_choices(slot_choices, menu_index);
        } else {
            _draw_choices(slot_choices, -1, 0.3);
            _draw_choices(difficulty_choices, menu_index);
        }
        if (_has_save) {
            var _difficulty = game_campaign_difficulty_name(_save.difficulty);
            var _status = "Deaths - " + string(_save.deaths) + " - " + _difficulty;
            draw_boshy_text(_stage, 320 - string_length(_stage) * 4, 395);
            draw_boshy_text(_status, 320 - string_length(_status) * 4, 414);
        } else {
            draw_boshy_text("Save not active", 260, 414);
        }
    }
    if (menu_page == TitlePage.Main || menu_page == TitlePage.Slots || menu_page == TitlePage.Difficulty) {
        var _choices = main_choices;
        if (menu_page == TitlePage.Slots) {
            _choices = slot_choices;
        } else if (menu_page == TitlePage.Difficulty) {
            _choices = difficulty_choices;
        }
        var _selected = _choices[menu_index];
        draw_sprite(spr_title_arrow, 0, round(_selected.x + 50 - 50 * _selected.size), _selected.y - 80);
    }
    if (notice_steps > 0) {
        draw_boshy_text("Online play is unavailable.", 5, 197);
    }
    if (menu_page == TitlePage.DeleteSlot) {
        draw_set_color(c_black);
        draw_set_alpha(0.9);
        draw_rectangle(174, 193, 466, 302, false);
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_rectangle(174, 193, 466, 302, true);
        draw_rectangle(delete_confirmed ? 220 : 328, 268, delete_confirmed ? 312 : 420, 294, true);
        draw_boshy_text("Delete Save " + string(slot_index + 1) + "?", 264, 221);
        draw_boshy_text("Delete", 242, 275);
        draw_boshy_text("Cancel", 350, 275);
    }
}

draw_boshy_text("Made by Solgryn", 0, 0);
draw_boshy_text("Arrow keys (Select)", 488, 0, 0.5);
draw_boshy_text("Enter (Choose)", 528, 12, 0.5);
draw_boshy_text("Delete (Delete)", 520, 24, 0.5);
