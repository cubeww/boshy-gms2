if (!global.run.has_checkpoint && !is_undefined(global.run.restart_run)
    && !struct_exists(global.run, "teleporter_entry")) {
    x = 32;
    y = 1097;
    refresh_collision_probes();
}
