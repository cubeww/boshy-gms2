// Read the chest contents after the room instances have run their creation code.
var _entries = [];
with (obj_secret_chest) {
    array_push(_entries, pickup);
}
prehistorik_pickups_setup(_entries, spr_kid_icarus_pickup_reveals, show_trophy);
