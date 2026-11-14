page_left = 0;
page_top = 0;

// Source layer order and initial coordinates from the Prehistorik frame.
background_elements = [
    { sprite: spr_prehistorik_cloud_far, offset_x: 2, offset_y: 130, drift: -1,
        camera_factor: 0.05, left_margin: 621, wrap_distance: 1182, additive: true },
    { sprite: spr_prehistorik_cloud_far, offset_x: 578, offset_y: 144, drift: -1,
        camera_factor: 0.05, left_margin: 621, wrap_distance: 1182, additive: true },
    { sprite: spr_prehistorik_cloud_mid, offset_x: -22, offset_y: 61, drift: -2,
        camera_factor: 0.05, left_margin: 621, wrap_distance: 1242, additive: false },
    { sprite: spr_prehistorik_cloud_mid, offset_x: 594, offset_y: 74, drift: -2,
        camera_factor: 0.05, left_margin: 621, wrap_distance: 1242, additive: false },
    { sprite: spr_prehistorik_mountains, offset_x: 0, offset_y: 0, drift: 0,
        camera_factor: 0.05, additive: false },
    { sprite: spr_prehistorik_cloud_near, offset_x: 68, offset_y: 14, drift: -3,
        camera_factor: 0, left_margin: 640, wrap_distance: 1380, additive: false },
    { sprite: spr_prehistorik_cloud_near, offset_x: 708, offset_y: 16, drift: -3,
        camera_factor: 0, left_margin: 640, wrap_distance: 1380, additive: false }
];
