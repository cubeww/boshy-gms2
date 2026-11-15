var _target = follow_history[follow_cursor];
// G1155 reads the delayed pose and approaches its sampled position at 40 percent per step.
x = floor(lerp(x, _target.x, 0.4) + clamp(_target.x, -1, 1));
y = floor(lerp(y, _target.y, 0.4) + clamp(_target.y, -1, 1));
var _pose = _target.pose;
var _facing = _target.facing;

// G1147 leaves the follower alive after the player disappears.
if (instance_exists(rider) && !rider.dead) {
    var _keys = global.settings.keys;
    var _moving = keyboard_check(_keys.left) || keyboard_check(_keys.right);
    var _grounded = !flying && rider.grounded;
    if (_moving || !_grounded || !_target.grounded) {
        // D = 80 was the number of tokens to skip, with five tokens per recorded step.
        follow_history[follow_cursor] = {
            x: floor(rider.x),
            y: floor(rider.y),
            pose: flying ? PlayerPose.Idle : rider.pose,
            facing: flying ? 1 : rider.facing,
            grounded: _grounded
        };
        follow_cursor = (follow_cursor + 1) mod array_length(follow_history);
    } else {
        // G1161 stops the walk once both climbers are grounded and the player releases both directions.
        _pose = PlayerPose.Idle;
    }
    if (!flying) {
        image_angle = rider.image_angle;
        image_xscale = rider.image_xscale;
    }
}

if (_pose == PlayerPose.Shoot) {
    // Fusion falls back to the idle animation because the follower has no shooting clip.
    _pose = PlayerPose.Idle;
}
sprite_index = _facing < 0 ? spr_stock_ice_climbers_follower_left : spr_stock_ice_climbers_follower_right;
if (follow_pose == _pose) {
    if (!follow_animation_paused) {
        ++follow_animation_steps;
    }
} else {
    follow_pose = _pose;
    follow_animation_steps = 0;
}
var _clip = follow_poses[follow_pose];
var _frame = floor(follow_animation_steps * _clip.rate) mod array_length(_clip.frames);
image_index = _clip.frames[_frame];
