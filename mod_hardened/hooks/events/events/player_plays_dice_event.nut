::Hardened.HooksMod.hook("scripts/events/events/player_plays_dice_event", function(q) {
	q.onUpdateScore = @(__original) function()
	{
		__original();
		this.m.Score /= 2;	// Vanilla: 10 Score per valid background, we half that chance
	}
});
