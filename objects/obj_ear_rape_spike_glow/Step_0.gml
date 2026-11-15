animation_counter += 45;
if (animation_counter > 100) {
    animation_counter -= 100;
    if (++image_index >= image_number) {
        instance_destroy();
    }
}
