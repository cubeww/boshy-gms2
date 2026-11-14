// G758–760 publish the integer position before advancing the stored fractional position.
x = floor(travel_x);
travel_x += travel_direction * travel_speed;
if (bbox_right < 0 || bbox_left >= room_width || (image_xscale == 1 && place_meeting(x, y, obj_player_backdrop))) {
    instance_destroy();
}
