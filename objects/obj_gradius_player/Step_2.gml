if (!dead) {
    gradius_collect_capsules();
    if (pending_upgrade > 0 && keyboard_check_pressed(global.settings.keys.jump)) {
        gradius_redeem_upgrade();
    }
}
