if (widget_variant == 4) {
    // Groups 729–731 select a visible spawner every 1500 ms, then offset the sparks by 0–199 pixels.
    if (++spawn_steps mod 75 == 0 && castlevania_widget_inside_view(x, y, sprite_index, 8)) {
        instance_create_depth(x + irandom(199), y, depth, obj_castlevania_forest_effect, {
            forest_effect: CastlevaniaForestEffect.GhoulSparks
        });
    }
    exit;
}

// Groups 838–840 recreate the skeleton on each entrance into its camera page.
var _inside_view = castlevania_widget_inside_view(x, y, sprite_index);
if (_inside_view && !was_inside_view) {
    instance_create_depth(x, y, depth, obj_castlevania_widget, { widget_variant: 3 });
}
was_inside_view = _inside_view;
