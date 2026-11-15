// G1159 starts 16 pixels behind the player. G1155 reads zeroes from the empty history.
follow_history = array_create(17, { x: 0, y: 0, pose: PlayerPose.Idle, facing: 1, grounded: false });
follow_cursor = 0;
follow_pose = PlayerPose.Idle;
follow_animation_steps = 0;
follow_animation_paused = false;
var _character = stock_character(108);
follow_poses = _character.poses;
image_speed = 0;
