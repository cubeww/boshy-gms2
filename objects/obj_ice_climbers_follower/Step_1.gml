// Fusion advances the follower before the chest events stop or resume its animation.
follow_animation_paused = !flying && instance_exists(rider)
    && rider.chest_pose_age >= 200 && rider.chest_pose_age < 250;
