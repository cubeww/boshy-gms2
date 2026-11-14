var _boss = instance_find(obj_solgryn, 0);
if (_boss == noone || _boss.fight_age >= 1450) {
    exit;
}

// G691 rises one pixel every three steps. G694 accelerates the rise from age 1280.
var _age = _boss.fight_age;
var _rise_slow = max(0, min(_age, 1279) div 3 - 33);
var _rise_steps = clamp(_age - 1280, 0, 120);
var _rise_fast = _rise_steps * (_rise_steps + 1) * 0.5;
draw_sprite(sprite_index, 0, x, y - _rise_slow - _rise_fast);
