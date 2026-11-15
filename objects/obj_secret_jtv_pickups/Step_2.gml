var _player = instance_find(obj_player, 0);
prehistorik_pickups_step(_player);
chest_view_update(game_controller, _player, prehistorik_pickup_slot >= 0 ? prehistorik_pickup_age : -1);
