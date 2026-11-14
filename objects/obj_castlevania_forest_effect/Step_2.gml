++effect_steps;
if (forest_effect == CastlevaniaForestEffect.PillarDebris) {
    // Group 790 advances each fragment independently from the moment it is created.
    x += horizontal_speed;
    y = floor(y + vertical_speed);
    vertical_speed += 0.7;
    if (y > room_height) {
        instance_destroy();
    }
    exit;
}

var _rate = forest_effect == CastlevaniaForestEffect.PillarFade ? 10 : 25;
var _frame = (effect_steps * _rate - 1) div 100;
if (_frame < image_number) {
    image_index = _frame;
    exit;
}
if (forest_effect == CastlevaniaForestEffect.GhoulSparks) {
    // Groups 732–734 create the ghoul at the spark position after the final frame.
    instance_create_depth(x, y, depth, obj_castlevania_widget, { widget_variant: 4, walk_left: effect_left });
}
instance_destroy();
