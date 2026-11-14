var _boss = instance_find(obj_solgryn, 0);
if (_boss != noone && _boss.fight_age < 5150) {
    // G788/886 emits two Active 23 sprites at random points along the lower edge.
    repeat (2) {
        array_push(sparks, { x: x + irandom(639), y: y, scale: 1, angle: irandom(359), vertical_speed: 0 });
    }
}

// G1145–1147 shares the phase between sideways drift and the expiry check.
for (var _index = array_length(sparks) - 1; _index >= 0; --_index) {
    var _spark = sparks[_index];
    _spark.draw_x = floor(_spark.x);
    _spark.draw_y = floor(_spark.y);
    _spark.x += dcos(_spark.angle * 5);
    ++_spark.angle;
    _spark.scale -= irandom(49) * 0.0005;
    _spark.vertical_speed -= 0.1 - irandom(9) * 0.01;
    _spark.y += _spark.vertical_speed;
    if (_spark.angle >= 300) {
        array_delete(sparks, _index, 1);
    }
}
