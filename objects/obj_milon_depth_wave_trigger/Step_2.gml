// Fusion G757 is limited to one activation per visit to the room.
var _player = instance_find(obj_player, 0);
if (milon_in_zone(_player, trigger_zone[0], trigger_zone[1], trigger_zone[2], trigger_zone[3])) {
    instance_create_depth(x, y, depth - 1, obj_milon_depth_wave_shot, {
        travel_direction: -1, travel_speed: 6, image_xscale: 5, image_yscale: 5
    });
    instance_destroy();
}
