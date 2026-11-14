spark_clock += 40;
if (spark_clock > 100) {
    spark_clock -= 100;
    ++image_index;
    if (image_index >= image_number) {
        instance_destroy();
    }
}
