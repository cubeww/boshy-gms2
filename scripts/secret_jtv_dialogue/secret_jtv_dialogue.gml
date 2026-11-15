enum SecretJtvChatPhase {
    Idle,
    Active,
    Dead,
    Victory
}

function secret_jtv_chat_add_row(_chat, _first_message, _last_message, _x, _y) {
    // G858–892 and G955–989 select a chatter. The two panels only differ at entry 31.
    static _names = [
        "Solgryn", "Mareximo", "Pravus", "Bunikita_93", "Sora1ash", "Michael_1985", "Baconbandit",
        "Skeld", "Nuvius38", "Benji10042", "Multitapgaming", "Lolgryn", "Trollgryn", "Cunnan",
        "Vertigoelectric", "Boshytime", "Ozwaldd", "Utgardtv", "Spikedapenguin", "Jools64", "Luigi__91",
        "mrbob007", "thegreatgq", "trigger014", "chinfishem", "omegax921", "cottonmouthxx", "loood",
        "sarahrawrz", "O________________O", "Sicrow7", "Nicole20092002", "Knobking", "Knobking", "Doctor_cake"
    ];
    static _messages = [
        "Lol", "Hi Mom!", ":3", "Roflmfao", "FAIL!", "I herd u liek mudkipz", "IT'S OVER 9000!",
        "whats a boshy", "this is boring", "<message deleted>", "wat gaem is dis guise", "gfsahkjsagkasgf",
        "did solgryn made this", "hey I'm new here", "can I be a mod?", "i'm leaving", "can I post a link?",
        "is this for pc?", "lol u died lol lol u died", "turn on slowmode", "kappa",
        "lolomgwtgdairyqueenlolomgbbtheq", "!topic", "what is this crap", "chocolate raiiiiiiiiiiiiiiiiiin",
        "HAHAHA", "FAIIIL", "OMG", "ROOOFL!!!", "HE DIED?! LUL", "YEES", "KAZOOOM", "OMG FINALLY!",
        "YEEEEEESSSHHH", "YEAAA!!!11!!!1"
    ];
    var _name_id = irandom(array_length(_names) - 1);
    var _message_id = irandom_range(_first_message, _last_message);
    var _name = _chat.arena && _name_id == 30 ? "Ultrajman" : _names[_name_id];
    var _message = _messages[_message_id - 1];
    if (_message_id == 11 || _message_id == 20) {
        // These events assign the username string and leave the message empty.
        _name = _message;
        _message = "";
    }
    var _line = _name + ": " + _message;
    var _rows = _chat.rows;
    array_push(_rows, { x: _x, y: _y, text: _line, width: 8 * string_length(_line) });
    _chat.rows = _rows;
}

function secret_jtv_chat_new(_x, _y, _ceiling, _initial_x, _initial_y, _arena = false) {
    var _chat = {
        x: _x, y: _y, ceiling: _ceiling, arena: _arena,
        ticks: 0, delay: 20, rows: []
    };
    secret_jtv_chat_add_row(_chat, 1, 25, _initial_x, _initial_y);
    return _chat;
}

function secret_jtv_chat_shift(_chat, _pixels) {
    var _rows = _chat.rows;
    var _count = array_length(_rows);
    var _expired = 0;
    for (var _i = 0; _i < _count; ++_i) {
        var _row = _rows[_i];
        _row.y -= _pixels;
        if (_row.y < _chat.ceiling) {
            ++_expired;
        }
    }
    if (_expired > 0) {
        array_delete(_rows, 0, _expired);
        _chat.rows = _rows;
    }
}

function secret_jtv_chat_step(_chat, _first_message, _last_message, _delay_advance) {
    _chat.ticks += _delay_advance;
    if (_chat.ticks <= _chat.delay) {
        return false;
    }
    _chat.ticks = 0;
    _chat.delay = irandom_range(10, 49);
    secret_jtv_chat_shift(_chat, 16);
    secret_jtv_chat_add_row(_chat, _first_message, _last_message, _chat.x, _chat.y);
    return true;
}

function secret_jtv_chat_draw(_chat) {
    var _camera = camera_get_active();
    var _top = camera_get_view_y(_camera);
    var _bottom = _top + camera_get_view_height(_camera);
    var _left = camera_get_view_x(_camera);
    var _right = _left + camera_get_view_width(_camera);
    var _alpha = _chat.arena ? 1 - 40 / 128 : 1;
    var _rows = _chat.rows;
    var _count = array_length(_rows);
    for (var _row_index = 0; _row_index < _count; ++_row_index) {
        var _row = _rows[_row_index];
        if (_row.y + 16 <= _top || _row.y >= _bottom || _row.x + _row.width <= _left || _row.x >= _right) {
            continue;
        }
        var _draw_x = _row.x;
        var _length = string_length(_row.text);
        for (var _i = 1; _i <= _length; ++_i) {
            var _glyph = ord(string_char_at(_row.text, _i)) - 32;
            if (_glyph > 0) {
                draw_sprite_part_ext(spr_secret_jtv_chat_font, 0, (_glyph mod 32) * 7, (_glyph div 32) * 16,
                    7, 16, _draw_x, _row.y, 1, 1, c_white, _alpha);
            }
            _draw_x += 7;
        }
    }
}

function secret_jtv_dialogue_setup() {
    // G947 creates subsequent lines 16 pixels above Active 26 at (1939, 1858).
    arena_chat = secret_jtv_chat_new(1939, 1842, 1626, 1945, 1636, true);
    arena_chat_phase = SecretJtvChatPhase.Idle;
}

function secret_jtv_dialogue_step(_phase) {
    // G807–809 clear the line already on screen when the fight starts.
    if (arena_chat_phase == SecretJtvChatPhase.Idle && _phase == SecretJtvChatPhase.Active) {
        secret_jtv_chat_shift(arena_chat, 32);
    }
    arena_chat_phase = _phase;
    switch (_phase) {
        case SecretJtvChatPhase.Dead:
            return secret_jtv_chat_step(arena_chat, 26, 30, 3.5);
        case SecretJtvChatPhase.Victory:
            return secret_jtv_chat_step(arena_chat, 31, 35, 3.5);
    }
    return secret_jtv_chat_step(arena_chat, 1, 25, 0.5);
}

function secret_jtv_dialogue_draw() {
    secret_jtv_chat_draw(arena_chat);
}
