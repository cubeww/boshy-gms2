// G815/G1156 use the room's millisecond timer. G820/G843 keep a phase per flyer.
switch (flyer_kind) {
    case NinjaGaidenFlyer.ClockSway:
    case NinjaGaidenFlyer.PillarTrigger:
        var _stage = instance_find(obj_ninja_gaiden, 0);
        if (_stage != noone) {
            sway_phase = (_stage.stage_steps * 20) / 3;
        }
        x = floor(xstart + dsin(sway_phase) * 8);
        break;
    case NinjaGaidenFlyer.RandomSway:
        x = floor(xstart + dsin(sway_phase) * 16);
        sway_phase += 5 + irandom(14);
        break;
    case NinjaGaidenFlyer.Pillars:
        x = floor(xstart + dsin(sway_phase) * 16);
        sway_phase += 8;
        break;
}
