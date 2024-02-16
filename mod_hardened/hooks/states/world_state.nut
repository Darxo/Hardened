::Hardened.HooksMod.hook("scripts/states/world_state", function(q) {
	q.onShow = @(__original) function()
	{
		__original();

		// These two lines in combination will force reveal all enemies that the player should be able to see. They fix the bug where you don't see enemies when loading a game
		::World.setPlayerPos(this.getPlayer().getPos());
		::World.setPlayerVisionRadius(this.getPlayer().getVisionRadius());
	}
});
