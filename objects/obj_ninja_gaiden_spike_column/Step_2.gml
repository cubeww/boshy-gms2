if (column_raised) {
    // G816–817 keep raising the columns once the flyer has been shot.
    --y;
    if (bbox_bottom < 0) {
        instance_destroy();
    }
}
