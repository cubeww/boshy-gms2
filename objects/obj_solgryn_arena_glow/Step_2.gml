if (drift == 0) {
    exit;
}

var _boss = instance_find(obj_solgryn, 0);
if (_boss != noone && _boss.fight_age >= 5150) {
    instance_destroy();
    exit;
}

// G1109–1112 uses two different thresholds to wrap the white and red fog.
x += drift;
if (x <= wrap_left) {
    x = 640;
}
