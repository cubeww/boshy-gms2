// Room Start runs after the chests' Instance Creation Code has set their contents.
var _entries = [];
with (obj_secret_chest) {
    array_push(_entries, pickup);
}
prehistorik_pickups_setup(_entries, spr_mega_man_world_pickup_reveals, show_trophy);
