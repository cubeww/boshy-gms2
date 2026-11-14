++lava_steps;
var _boss = instance_find(obj_mario, 0);
var _amplitude = _boss == noone ? 10 : _boss.lava_amplitude;
// Fusion group 685 adds the tile's starting X to Timer / 5.
y = floor(ystart - 14 + dsin(lava_steps * 4 + lava_phase) * _amplitude);
