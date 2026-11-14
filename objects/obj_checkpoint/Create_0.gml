// Draw the save block behind the player on the gameplay layer.
depth += 1;
image_speed = 0;
image_index = 0;

activate = function() {
    if (image_index == 0) {
        image_index = 1;
    }
};
