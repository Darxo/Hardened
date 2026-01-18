::Hardened.HooksMod.hook("scripts/entity/world/attached_location", function(q) {
	q.m.IsRaidable <- false;	// If true, then this attached location can be attacked and temporarily destroyed

	q.create = @(__original) function()
	{
		__original();

		// Attached Locations no longer display their banner by default
		this.m.IsShowingBanner = false;
	}

	q.onAfterInit = @(__original) function()
	{
		__original();
		this.setSpriteScaling("location_banner", true);
		this.setSpriteOffset("location_banner", this.createVec(-55, 20));
	}

	q.setActive = @(__original) function( _active )
	{
		__original(_active);

		if (this.isRaidable())
		{
			this.m.IsSpawningDefenders = _active;
			this.m.IsAttackable = _active;
			this.getSprite("location_banner").Visible = this.m.IsShowingBanner && _active;
		}
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		if (this.isRaidable())
		{
			// The attached_location base class always sets this to false during deserialize, so we need to revert that
			this.setAttackable(this.isActive());
		}

		// Vanilla calls onAfterInit before onDeserialize and it also serializes the offsets of all sprites
		// In order to stay compatible with old saves or those from base Reforged, we adjust the banner offset on every deserialize
		this.setSpriteScaling("location_banner", true);
		this.setSpriteOffset("location_banner", this.createVec(-55, 20));
	}

	q.onCombatLost = @(__original) function()
	{
		__original();

		// Winning against raidable attached locations now sets them to inactive (into a ruined state)
		if (this.isRaidable())
		{
			this.setActive(false);
		}
	}

	q.setSettlement = @(__original) function( _settlement )
	{
		__original(_settlement);

		// Vanilla Fix: Vanilla never calls onSpawned for attached locations
		// We change that using the fact, that every attached location is always attached to a settlement right after spawn
		this.onSpawned();
	}

// New Function
	q.isRaidable <- function()
	{
		return this.m.IsRaidable;
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/world/attached_location", function(q) {
	q.getTooltip = @(__original) function()
	{
		if (!this.isRaidable()) return __original();

		this.m.HD_IsTemporaryUnallied = true;
		local ret = __original();
		this.m.HD_IsTemporaryUnallied = false;
		return ret;
	}
});

