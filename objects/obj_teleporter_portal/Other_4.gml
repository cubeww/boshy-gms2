route = teleporter_route(route_handle);
if (is_undefined(route)) {
    instance_destroy();
    exit;
}

stage_controller = instance_find(obj_teleporter, 0);
portal_unlocked = game_has_explored(route.key);
// Fusion uses animation 13 for a locked portal.
image_index = portal_unlocked ? 0 : 2;
