::Hardened.HooksMod.hook("scripts/skills/effects/rf_hold_steady_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.BraveryAdd = 0;	// Reforged: 10
	}

	q.onRefresh = @(__original) function()
	{
		__original();
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
	}
});
