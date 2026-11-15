enum SecretOneBlock {
    Coin,
    MultiCoin,
    Brick,
    Poison,
    OneUp
}

enum SecretOneWalker {
    Goomba,
    Koopa,
    PoisonMushroom,
    OneUp
}

function secret_1_1_spawn_effect(_x, _y, _layer, _sprite, _vx, _vy, _gravity) {
    var _effect = instance_create_layer(_x, _y, _layer, obj_secret_1_1_effect);
    _effect.sprite_index = _sprite;
    _effect.velocity_x = _vx;
    _effect.velocity_y = _vy;
    _effect.effect_gravity = _gravity;
}

function secret_1_1_bump_block(_block) {
    with (_block) {
        switch (block_kind) {
            case SecretOneBlock.Brick:
                // G789–795 and G836–840 each scatter four chips.
                var _fragment = sprite_index == spr_secret_1_1_underground_brick
                    ? spr_secret_1_1_underground_brick_fragment : spr_secret_1_1_brick_fragment;
                secret_1_1_spawn_effect(x, y, layer, _fragment, 3, -5, 0.3);
                secret_1_1_spawn_effect(x, y, layer, _fragment, -3, -5, 0.3);
                secret_1_1_spawn_effect(x, y, layer, _fragment, 3, -2, 0.3);
                secret_1_1_spawn_effect(x, y, layer, _fragment, -3, -2, 0.3);
                audio_play_sound(snd_secret_1_1_brick_shatter, 1, false);
                instance_destroy();
                break;
            case SecretOneBlock.Coin:
            case SecretOneBlock.MultiCoin:
                if (coins_left > 0) {
                    secret_1_1_spawn_effect(x + 8, y + 8, layer, spr_secret_1_1_coin_burst, 0, -6, 0.4);
                    audio_play_sound(snd_kid_icarus_coin, 1, false);
                    if (--coins_left == 0) {
                        sprite_index = spr_secret_1_1_used_block;
                    }
                    if (block_kind == SecretOneBlock.MultiCoin) {
                        y -= 5;
                        bump_steps = 5;
                    }
                }
                break;
            case SecretOneBlock.Poison:
            case SecretOneBlock.OneUp:
                if (coins_left > 0) {
                    coins_left = 0;
                    sprite_index = spr_secret_1_1_used_block;
                    var _item = instance_create_layer(x + 8, y, layer, obj_secret_1_1_walker);
                    if (block_kind == SecretOneBlock.OneUp) {
                        _item.walker_kind = SecretOneWalker.OneUp;
                        _item.sprite_index = spr_secret_1_1_one_up;
                    } else {
                        _item.walker_kind = SecretOneWalker.PoisonMushroom;
                        _item.sprite_index = spr_secret_1_1_poison_mushroom;
                    }
                    audio_play_sound(snd_secret_1_1_mushroom_release, 1, false);
                }
                break;
        }
    }
}

function secret_1_1_move_y(_player) {
    if (_player.vsp < 0) {
        // G11, G789 and G797 use the separate, higher Up 2 probe.
        var _x = _player.probe_x;
        var _y = _player.probe_y;
        var _block = collision_rectangle(_x - 6, _y - 20, _x + 5, _y - 19, obj_secret_1_1_block, true, false);
        if (_block == noone && instance_exists(inst_secret_1_1_block_275)) {
            var _hidden = inst_secret_1_1_block_275;
            if (_hidden.coins_left > 0 && _x + 5 >= _hidden.x && _x - 6 < _hidden.x + 16
                && _y - 19 >= _hidden.y && _y - 20 < _hidden.y + 16) {
                _block = _hidden;
            }
        }
        if (_block != noone) {
            secret_1_1_bump_block(_block);
            _player.vsp = 0;
            return true;
        }
    } else if (_player.vsp > 0) {
        // G780/G781 and G858/G859 test the Down probe during descent.
        with (obj_secret_1_1_walker) {
            if ((walker_kind == SecretOneWalker.Goomba || walker_kind == SecretOneWalker.Koopa)
                && _player.probe_overlaps(_player.down_probe, id)) {
                _player.vsp = -6;
                _player.grounded = false;
                _player.air_jump_available = true;
                _player.jump_cut_enabled = false;
                audio_play_sound(snd_prehistorik_kick, 1, false);
                if (walker_kind == SecretOneWalker.Goomba) {
                    instance_destroy();
                } else {
                    if (shell_state == 0) {
                        sprite_index = spr_secret_1_1_koopa_shell;
                        shell_state = 1;
                    } else {
                        shell_state = shell_state == 1 ? 2 : 1;
                        shell_touching = shell_state == 2;
                    }
                    _player.y -= 4;
                    _player.refresh_collision_probes();
                }
                return true;
            }
        }
    }
    return false;
}
