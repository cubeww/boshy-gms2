++arena_steps;
// Fusion groups 844–845 scroll the background two pixels per step.
for (var _i = 0; _i < array_length(question_marks); ++_i) {
    var _mark = question_marks[_i];
    if (_mark.x < -64) {
        _mark.x = 640;
    }
    _mark.x -= 2;
}
