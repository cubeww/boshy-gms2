if (!gameplay_room) {
    exit;
}
if (teleporter_arrival_age >= 0) {
    var _frame = floor(++teleporter_arrival_age * 0.6);
    if (_frame >= sprite_get_number(spr_tutorial_portal_transition)) {
        teleporter_arrival_age = -1;
        teleport_mosaic_columns = 0;
        teleport_mosaic_rows = 0;
    } else {
        teleport_mosaic_columns = max(1, _frame) * 31;
        teleport_mosaic_rows = teleport_mosaic_columns;
    }
}
if (!instance_exists(obj_tutorial_portal) || room == rm_tutorial || room == rm_prize_room) {
    exit;
}

var _player = instance_find(obj_player, 0);
if (inbound_portal != noone) {
    if (_player == noone) {
        inbound_portal.image_index = 0;
        inbound_portal = noone;
        inbound_portal_age = -1;
        teleport_mosaic_columns = 0;
        teleport_mosaic_rows = 0;
        audio_stop_sound(inbound_portal_sound);
        inbound_portal_sound = -1;
        exit;
    }
    teleporter_warp_motion(_player, inbound_portal, ++inbound_portal_age);
    if (_player.touching_hazard() && _player.die()) {
        exit;
    }
    teleporter_apply_exit_mosaic(id, inbound_portal_age);
    if (inbound_portal_age >= 80) {
        game_travel_by_teleporter(rm_teleporter, 320, 240);
    }
    exit;
}
if (_player == noone) {
    exit;
}

with (obj_tutorial_portal) {
    if (!variable_instance_exists(id, "hub_destination") || !hub_destination) {
        continue;
    }
    var _touching = _player.boshy_mask_meeting(id);
    if (!variable_instance_exists(id, "hub_touching")) {
        hub_touching = false;
    }
    var _entered = _touching && !hub_touching;
    hub_touching = _touching;
    if (_entered && !_player.input_locked) {
        other.inbound_portal = id;
        other.inbound_portal_age = 0;
        other.inbound_portal_sound = audio_play_sound(snd_tutorial_teleport, 1, false);
        image_index = 1;
        _player.input_locked = true;
        _player.hsp = 0;
        break;
    }
}
