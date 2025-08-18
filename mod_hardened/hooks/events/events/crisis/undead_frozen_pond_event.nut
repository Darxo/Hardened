::Hardened.HooksMod.hook("scripts/events/events/crisis/undead_frozen_pond_event", function(q) {
	// Overwrite, because we need to implement a check that prevents the original from sometimes crashing
	// Vanilla Fix: this function from crashing when the player party has no broher with Initiative of 130 or higher
	q.onUpdateScore = @() function()
	{
		if (!this.World.FactionManager.isUndeadScourge()) return;

		local currentTile = ::World.State.getPlayer().getTile();
		if (currentTile.Type != ::Const.World.TerrainType.Snow) return;
		if (currentTile.HasRoad) return;
		if (!::World.Assets.getStash().hasEmptySlot()) return;

		local nearTown = false;
		foreach (t in ::World.EntityManager.getSettlements())
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				nearTown = true;
				break;
			}
		}

		if (nearTown) return;

		local candidates_lightweight = [];
		local candidates = [];
		foreach (bro in ::World.getPlayerRoster().getAll())
		{
			if (bro.getCurrentProperties().getInitiative() >= 130)
			{
				candidates_lightweight.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates_lightweight.len() == 0) return;	// This is the only line that is new
		if (candidates.len() == 0) return;

		this.m.Lightweight = ::MSU.Array.rand(candidates_lightweight);
		this.m.Other = ::MSU.Array.rand(candidates);
		this.m.Score = 20;
	}
});
