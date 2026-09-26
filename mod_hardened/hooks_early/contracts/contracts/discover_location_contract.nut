::Hardened.HooksMod.hook("scripts/contracts/contracts/discover_location_contract", function(q) {
	// Overwrite, because we remove some vanilla conditions, which is extremely hard to do with hooking
	q.setup = @() function()
	{
		local scoutableLocations = [];
		// Feat: Allow many more types of locations to be the target. Vanilla only allows Zombie and Undead locations
		foreach (factionType in ::new("scripts/factions/contracts/discover_location_action").m.HD_ScoutableFactions)
		{
			scoutableLocations.extend(::World.FactionManager.getFactionOfType(factionType).getSettlements());
		}

		local best;
		local lowestDistance = 9000;
		foreach (location in scoutableLocations)
		{
			if (location.isLocationType(::Const.World.LocationType.Unique)) continue;
			if (location.isDiscovered()) continue;

			// Feat: Allow locations that are in undiscovered regions. Vanilla checks for region parameters here
			local distance = this.m.Home.getTile().getDistanceTo(location.getTile());
			if (distance > 20) continue;

			if (distance + ::Math.rand(0, 5) < lowestDistance)
			{
				best = location;
				lowestDistance = distance;
			}
		}

		if (best == null)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Location = ::WeakTableRef(best);
		this.m.Flags.set("Region", ::World.State.getTileRegion(this.m.Location.getTile()).Name);
		this.m.Flags.set("Location", this.m.Location.getName());

		if (this.m.Location.m.VisibilityMult >= 1.0)
		{
			this.HD_setDifficultyTier(1);
		}
		// Feat: Introduce higher contract tiers for locations with lower visibility multiplier
		else if (this.m.Location.m.VisibilityMult >= 0.5)
		{
			this.HD_setDifficultyTier(2);
		}
		else
		{
			this.HD_setDifficultyTier(3);
		}

		// Feat: Remove 100 Crown bonus pay when playing in ExplorationMode
		// Feat: Remove minimum possible reward of 300 crowns
		this.m.Payment.Pool = (100 + lowestDistance * 15.0) * this.getPaymentMult() * this.getReputationToPaymentLightMult();

		if (::Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * ::MSU.Math.randf(1.2, 1.5)));
		this.m.Flags.set("HintBribe", this.beautifyNumber(this.m.Payment.Pool * 0.1));
	}
});
