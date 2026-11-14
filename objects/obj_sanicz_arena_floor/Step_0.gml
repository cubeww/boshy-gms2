if (sprite_index != spr_sanicz_floor_collapse || image_index >= image_number - 1) {
    exit;
}

// The original clip advances at 28 percent of the frame rate and loops its last image.
collapse_counter += 28;
if (collapse_counter > 100) {
    collapse_counter -= 100;
    ++image_index;
}
