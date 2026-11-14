var _phase = age div 2;
var _amplitude = _phase == 0 ? 0 : max(0, 15 - _phase * 2);
var _direction = _phase mod 2 == 1 ? 1 : -1;
draw_boshy_text(message, x, y + _direction * _amplitude);
