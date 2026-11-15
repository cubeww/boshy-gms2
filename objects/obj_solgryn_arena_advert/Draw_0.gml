var _boss = instance_find(obj_solgryn, 0);
if (_boss == noone || _boss.fight_age >= 1450) {
    exit;
}

// G694 accelerates the rise from age 1280.
var _age = _boss.fight_age;
var _rise_steps = clamp(_age - 1280, 0, 120);
var _rise_fast = _rise_steps * (_rise_steps + 1) * 0.5;
draw_sprite(sprite_index, 0, x, y - _boss.early_advert_rise - _rise_fast);
