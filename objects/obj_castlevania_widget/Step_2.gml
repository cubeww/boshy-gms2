if ((widget_variant == 3 || widget_variant == 6 || widget_variant == 11)
    && !castlevania_widget_inside_view(x, y, sprite_index)) {
    instance_destroy();
    exit;
}

if (widget_variant == 4 && ++widget_age >= 150) {
    instance_create_depth(x, y, depth, obj_castlevania_forest_effect, {
        forest_effect: CastlevaniaForestEffect.GhoulFade, effect_left: walk_left
    });
    instance_destroy();
    exit;
}

var _player = instance_find(obj_player, 0);
++pose_steps;
if (widget_variant == 5) {
    if (!castlevania_pillar_runner_step(_player)) {
        exit;
    }
} else {
    castlevania_widget_walk();
    if (widget_variant == 2 && _player != noone) {
        // Groups 696–697 pause this patrol while Boshy is at least 200 pixels away.
        walk_speed = abs(_player.x - x) + abs(_player.y - y) < 200 ? 1 : 0;
    } else if (widget_variant == 4 && instance_exists(inst_castlevania_upper_wrap)
        && place_meeting(x, y, inst_castlevania_upper_wrap)) {
        // Group 789 wraps the ghoul through the same marker as the player.
        x = 1281;
    }
}
castlevania_widget_pose();
