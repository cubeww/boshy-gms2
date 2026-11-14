// The source animation uses a 45% frame advance and plays once.
var _frame = max(0, (++blast_age * 45 - 1) div 100);
if (_frame >= image_number) {
    instance_destroy();
    exit;
}
image_index = _frame;
