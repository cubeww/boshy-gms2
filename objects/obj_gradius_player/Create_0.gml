dead = false;
vertical_speed = -100;
flight_speed = 1;
pending_upgrade = 0;
missiles_enabled = false;
double_enabled = false;
laser_enabled = false;
scene_steps = 0;
shot_repeat_steps = 5;
laser_option_repeat_steps = 5;
death_blast_ms = 50;
rider_frame = 0;
image_speed = 0;
image_index = 0;

character = game_character_definition(global.profile.character_id);
if (is_undefined(character)) {
    character = boshy_character();
}

options = [];

gradius_player_die = function(_outside_room = false) {
    if (dead || (global.debug_invincible && !_outside_room)) {
        return;
    }

    dead = true;
    vertical_speed = -10;
    gradius_fail(x, y);
};

gradius_check_hazards = function() {
    if (dead) {
        return;
    }

    // Fusion Group 45 tests the 1x Boshy rider rather than the enlarged hull.
    var _pose = image_index;
    image_index = rider_frame;
    var _hit = place_meeting(x, y, obj_hazard);
    image_index = _pose;
    if (_hit) {
        gradius_player_die();
    }
};
