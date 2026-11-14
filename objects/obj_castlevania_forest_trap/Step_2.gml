var _player = instance_find(obj_player, 0);
switch (trap_kind) {
    case CastlevaniaForestTrap.CurseSign:
        // Groups 735–738 drop the sign once, then bounce off the backdrop.
        if (!trap_active && _player != noone && _player.x >= 833 && _player.x < 870
            && _player.y >= 574 && _player.y < 932) {
            trap_active = true;
        }
        if (trap_active) {
            y = floor(y + vertical_speed);
            if (!sign_bounced && place_meeting(x, y, obj_player_backdrop)) {
                sign_bounced = true;
                vertical_speed = -10;
            }
            if (sign_bounced) {
                vertical_speed += 0.6;
            }
        }
        break;
    case CastlevaniaForestTrap.FlamingOrb:
        // Groups 742–743 launch and spin the enlarged orb.
        if (!trap_active && _player != noone && _player.x >= 492 && _player.x < 601
            && _player.y >= 788 && _player.y < 1421) {
            trap_active = true;
            vertical_speed = -25;
            image_xscale = 10;
            image_yscale = 10;
            image_angle = -90;
        }
        if (trap_active) {
            y += vertical_speed;
            ++vertical_speed;
            image_angle = (image_angle + 4) mod 360;
        }
        break;
    case CastlevaniaForestTrap.SlidingSpike:
        // Groups 745–747 send the enlarged spike across the upper route.
        if (!trap_active && _player != noone && _player.x >= -9 && _player.x < 366
            && _player.y >= 472 && _player.y < 788) {
            trap_active = true;
        }
        if (trap_active) {
            x += 5;
        }
        break;
    case CastlevaniaForestTrap.Pillar:
        // Groups 786–787 bob each pillar around its authored position.
        y = floor(ystart + dsin(++stage_steps * 10) * 8);
        break;
}
