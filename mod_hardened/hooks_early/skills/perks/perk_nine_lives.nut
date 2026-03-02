::Hardened.HooksMod.hook("scripts/skills/perks/perk_nine_lives", function(q) {
	// Overwrite, because we want to remove a vanilla code line
	q.setSpent = @() function( _newSpent )
	{
		// This perk no longer grants heighened reflexes effect when triggered
		this.m.IsSpent = _newSpent;
		this.m.LastFrameUsed = ::Time.getFrame();
	}
});
