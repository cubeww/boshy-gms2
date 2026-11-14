var _deaths = global.run.world_deaths;
var _text = string(_deaths);
if (_deaths > 0) {
    _text += _deaths == 1 ? " DEATH" : " DEATHS";
}
draw_boshy_text(_text, x + 5, y + 22);
