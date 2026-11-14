var _cloud = instance_find(obj_credits_cloud, 0);
// G1 reads the cloud's position before the movement events.
page_top = clamp(_cloud.y - 340, 0, room_height - 480);
camera_set_view_pos(view_camera[0], 0, page_top);
++credits_age;
