var _frame = (++blast_steps * blast_rate - 1) div 100;
if (_frame >= image_number) {
    instance_destroy();
    exit;
}
image_index = _frame;
