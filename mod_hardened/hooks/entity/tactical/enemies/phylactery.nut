::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/phylactery", function(q) {
	q.onRoundStart = @(__original) function()
	{
		__original();

		// Feat: Phylacteries that are already discovered by the player now always keep their tile lit up for the player
		local myTile = this.getTile();
		if (myTile.IsDiscovered)
		{
			myTile.addVisibilityForFaction(::Const.Faction.Player);
		}
	}
});
