function ninja_gaiden_traps_on_jump() {
    with (obj_ninja_gaiden_jump_spike) {
        spike_flipped = !spike_flipped;
    }
}

function ninja_phase_pillars_activate() {
    with (obj_ninja_gaiden_spike_column) {
        column_raised = true;
    }
}
