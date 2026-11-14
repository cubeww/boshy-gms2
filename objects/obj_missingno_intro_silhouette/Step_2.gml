var _boss = instance_find(obj_missingno, 0);
if (_boss == noone) {
    instance_destroy();
    exit;
}
if (_boss.fight_age >= 400 && _boss.fight_age <= 600) {
    // G722 sends the outline from right to left below the arena.
    x -= 25;
}
if (bbox_right < 0 || _boss.fight_age > 600) {
    instance_destroy();
}
