// G980–983 reuse the off-stage template's position one time per 50-step interval.
if (++shot_clock >= shot_interval) {
    shot_clock = 0;
    instance_create_layer(x + shot_offset_x, y + shot_offset_y, "Hazards", obj_desert_secret_hazard_shot,
        { travel_x: shot_speed });
}
