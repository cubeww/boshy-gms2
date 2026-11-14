// Groups 818–823 rearm a spawner only after it reaches the viewport border.
var _inside_view = castlevania_widget_inside_view(x, y, sprite_index);
if (_inside_view && !was_inside_view) {
    instance_create_depth(x, y, depth, obj_castlevania_widget, { widget_variant: spawn_variant });
}
was_inside_view = _inside_view;
