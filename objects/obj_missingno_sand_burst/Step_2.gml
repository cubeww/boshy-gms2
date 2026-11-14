// G784 increments the burst clock before G787–789 emit the lethal fragments.
++sand_age;
if (sand_age == 10) {
    instance_create_layer(x, y, "Hazards", obj_missingno_sand_projectile,
        { image_angle: image_angle - 10 - irandom(4), travel_speed: 4 });
    instance_create_layer(x, y, "Hazards", obj_missingno_sand_projectile, { image_angle: image_angle });
    instance_create_layer(x, y, "Hazards", obj_missingno_sand_projectile,
        { image_angle: image_angle + 10 + irandom(4), travel_speed: 4 });
}
image_index = sand_age div 4;
if (image_index >= image_number) {
    instance_destroy();
}
