hit_points = 20;
phase_hits = 0;
hit_flash_age = -1;
attack_age = 0;
attack_interval = 0;
arc_interval = 0;
animation_age = 0;
defeat_age = 0;
target_x = x;
target_y = y;
eye_angle = 0;
giant_bow = game_campaign_difficulty() == 0;
shot_damage = giant_bow ? 2 : 1;

image_speed = 0;
image_xscale = 2;
image_yscale = 2;
