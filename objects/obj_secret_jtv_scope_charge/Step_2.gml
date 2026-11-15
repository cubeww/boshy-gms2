var _boss = inst_secret_jtv_encounter.boss;
if (!instance_exists(_boss) || --charge_steps <= -20) {
    instance_destroy();
    exit;
}
x = _boss.x + eye_offset;
y = _boss.y + 12;
image_xscale += (charge_steps + 1) * 0.015;
image_yscale = image_xscale;
image_angle += abs(charge_steps);
