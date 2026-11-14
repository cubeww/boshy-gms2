var _boss = instance_find(obj_solgryn, 0);
if (_boss == noone || _boss.fight_age < 15250) {
    exit;
}

// G846 raises the base by two pixels per step. G1363 keeps the fire oscillating afterward.
var _raise_steps = clamp(_boss.fight_age - 15249, 0, 56);
var _top = ystart + 114 - _raise_steps * 2 + dsin((elapsed_steps * 20 div 6) + xstart) * 30 - 50;
gpu_set_blendmode(bm_add);
draw_sprite(sprite_index, image_index, x, floor(_top));
gpu_set_blendmode(bm_normal);
