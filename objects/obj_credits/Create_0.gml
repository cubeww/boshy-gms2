credits_age = 0;
page_top = 0;
var _difficulty = game_campaign_difficulty();
easy_credits = _difficulty == 0;
// Practice previews the same scenery as Totally Average mode.
_difficulty = _difficulty < 0 ? 1 : _difficulty;
layer_set_visible("Easy Saver Scenery", _difficulty <= 0);
layer_set_visible("Medium Saver Scenery", _difficulty <= 1);
layer_set_visible("Hard Saver Scenery", _difficulty <= 2);

var _progress = game_current_progress();
if (!_progress.credits_seen) {
    // G61 marks Exploration P without changing the last saved position.
    _progress.credits_seen = true;
    global.profile.dirty = true;
    game_profile_save();
}

var _game = instance_find(obj_game, 0);
if (easy_credits) {
    _game.start_stage_music(snd_credits_easy_music, true, false, 48000);
} else {
    _game.start_stage_music(snd_credits_music, false, false);
}
