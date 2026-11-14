// The chest uses the same animation and per-slot save timing as other secret items.
var _entries = [];
with (obj_secret_chest) {
    array_push(_entries, pickup);
}
prehistorik_pickups_setup(_entries, spr_desert_pickup_reveal, show_trophy);
