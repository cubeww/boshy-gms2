animation_progress += 15;
var _frame = animation_progress div 100;
if (_frame >= image_number) {
    instance_destroy();
    exit;
}
image_index = _frame;
