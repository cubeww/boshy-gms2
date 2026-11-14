// Both chests have their own Room Editor instance creation code.
var _entries = [];
with (obj_secret_chest) {
    array_push(_entries, pickup);
}
prehistorik_pickups_setup(_entries, spr_ninja_gaiden_pickup_reveals, show_trophy);
