var _player = instance_find(obj_player, 0);
var _view_left = inst_secret_1_1_controller.scroll_view_left;
var _view_top = inst_secret_1_1_controller.scroll_view_top;
if (bbox_right < _view_left - 16 || bbox_left > _view_left + 640 + 16
    || bbox_bottom < _view_top - 16 || bbox_top > _view_top + 480 + 16) {
    exit;
}

// G767–779, G800–808 and G843–857 share a foot-point vertical loop.
if (collision_point(x, y + 8, terrain, true, false) == noone) {
    y = floor(y + vertical_speed);
    vertical_speed += 0.1;
} else {
    vertical_speed = min(0, vertical_speed);
}
if (collision_point(x, y + 7, terrain, true, false) != noone) {
    --y;
}

var _walk = 1;
if (walker_kind == SecretOneWalker.Koopa) {
    // G858–866 use a stationary shell, then a four-times-speed kick.
    _walk = shell_state == 0 ? 1 : (shell_state == 2 ? 4 : 0);
}
if (_walk > 0) {
    var _wall = collision_point(x + 8 * walk_direction, y, terrain, true, false) != noone;
    var _avoids_ledges = walker_kind == SecretOneWalker.Koopa && shell_state == 0;
    var _ledge = _avoids_ledges && collision_point(x, y + 9, terrain, true, false) != noone
        && collision_point(x + 8 * walk_direction, y + 8, terrain, true, false) == noone;
    if (_wall || _ledge) {
        walk_direction = -walk_direction;
    }
    x += walk_direction * _walk;
}

if (walker_kind == SecretOneWalker.Koopa && shell_state == 0) {
    sprite_index = walk_direction < 0 ? spr_secret_1_1_koopa_left : spr_secret_1_1_koopa_right;
}
if (shell_state == 2) {
    var _goomba = instance_place(x, y, obj_secret_1_1_walker);
    if (_goomba != noone && _goomba.walker_kind == SecretOneWalker.Goomba) {
        instance_destroy(_goomba);
        audio_play_sound(snd_prehistorik_kick, 1, false);
    }
}
if (_player == noone || _player.input_locked) {
    exit;
}
var _touching = _player.boshy_mask_meeting(id);
if (!_touching) {
    shell_touching = false;
    exit;
}

switch (walker_kind) {
    case SecretOneWalker.PoisonMushroom:
        // G809–811 play the power-up cue, grow the player, then kill after 50 steps.
        if (!global.debug_invincible) {
            _player.secret_1_1_poison_steps = 1;
            _player.input_locked = true;
            _player.hsp = 0;
            _player.vsp = 0;
        }
        audio_play_sound(snd_mario_power_up, 1, false);
        instance_destroy();
        break;
    case SecretOneWalker.OneUp:
        // G822–823 always play the cue but record the trophy once per slot.
        audio_play_sound(snd_kid_icarus_blob_growth, 1, false);
        if (game_trophy_unlock("1-up")) {
            inst_secret_1_1_controller.show_trophy("1-up GET!");
        }
        instance_destroy();
        break;
    case SecretOneWalker.Koopa:
        if (shell_state == 1) {
            if (_player.vsp <= 0) {
                shell_state = 2;
                walk_direction = _player.facing;
                shell_touching = true;
                audio_play_sound(snd_prehistorik_kick, 1, false);
            }
            break;
        }
        if (shell_touching) {
            break;
        }
        if (_player.vsp <= 0) {
            _player.die();
        }
        break;
    default:
        if (_player.vsp <= 0) {
            _player.die();
        }
        break;
}
