::Hardened.HooksMod.hook("scripts/camera/tactical_camera_director", function(q) {
	// Vanilla Fix: We allow input while the camera being moved by the player, therefor allowing combining multiple camera directions and zooming+moving
	// Overwrite, because we need to replace the vanilla !this.isMoving() condition with out new this.m.Events.len() > 0 condition
	q.isInputAllowed = @() function()
	{
		if (::Tactical.TurnSequenceBar.getActiveEntity() == null) return false;
		if (!::Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled()) return false;	// The player may only do input while its their turn
		if (this.m.Events.len() > 0) return false;	// If there are active events, then the player may not do inputs

		return true;
	}
});
