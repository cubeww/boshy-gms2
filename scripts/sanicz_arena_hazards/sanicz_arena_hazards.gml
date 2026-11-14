function sanicz_arena_hazards_step() {
    var _rising = fight_age >= 810 && fight_age < 880;
    var _phase = (scene_steps * 20) div 4;
    var _frame = max(0, (scene_steps * 50 - 1) div 100) mod sprite_get_number(spr_dresser_fire);
    with (obj_sanicz_flame_panel) {
        // Group 1152 raises the fire. Groups 1232–1233 offset each wave by its original X.
        if (_rising) {
            flame_base_y -= 4;
        }
        y = floor(flame_base_y + dsin(_phase + xstart) * 15);
        image_index = _frame;
    }
}

function sanicz_arena_hazards_clear() {
    with (obj_sanicz_flame_panel) {
        instance_destroy();
    }
}
