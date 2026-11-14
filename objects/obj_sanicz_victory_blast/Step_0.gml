// The source Active 92 plays its Disappear clip once at 45% speed.
var _frame = (++blast_steps * 45 - 1) div 100;
if (_frame >= image_number) {
    instance_destroy();
    exit;
}
image_index = _frame;
