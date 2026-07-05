::Hardened.HooksMod.hook("scripts/entity/world/attached_location", function(q) {
	q.m.IsRaidable <- false;	// If true, then this attached location can be attacked and temporarily destroyed
	q.m.GoesIntoLockdown <- false;	// If true, then this locations becomes unattackable while its settlement has the raided_situation

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

		if (_active)
		{
			// Feat: We now also shuffle the CombatSeed whenever an attached location is set to active
			// This will change its tactical map, as this is one of the salts used there
			this.m.CombatSeed = ::Math.rand();
		}

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

		if (this.isRaidable())
		{
			// Winning against a raidable attached locations sets them to inactive
			this.setActive(false);

			// Winning against a raidable attached locations always triggerd a raided situation, if not already present
			if (!this.getSettlement().hasSituation("situation.raided"))
			{
				this.getSettlement().addSituation(::new("scripts/entity/world/settlements/situations/raided_situation"));
			}
		}
	}

	q.setSettlement = @(__original) function( _settlement )
	{
		__original(_settlement);

		// Vanilla Fix: Vanilla never calls onSpawned for attached locations
		// We change that using the fact, that every attached location is always attached to a settlement right after spawn
		this.onSpawned();
	}

	q.isAttackable = @(__original) function()
	{
		if (this.isInLockdown()) return false;

		return __original();
	}

// Hardened Functions
	q.isSouthern = @(__original) function()
	{
		if (this.getSettlement() == null)	// This could happen during map generation, when these are not yet attached to a location
		{
			return __original();
		}
		else
		{
			return this.getSettlement().isSouthern();
		}
	}

// New Functions
	q.isRaidable <- function()
	{
		return this.m.IsRaidable;
	}

	q.isInLockdown <- function()
	{
		if (!this.m.GoesIntoLockdown) return false;
		if (this.getSettlement() == null) return false;		// This could happen during map generation, when these are not yet attached to a location
		if (!this.getSettlement().hasSituation("situation.raided")) return false;

		// Attached Locations that are currently target of a contract are never in lockdown
		if (this.getSettlement().getSprite("selection").Visible) return false;

		return true;
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/world/attached_location", function(q) {
	q.getTooltip = @(__original) function()
	{
		if (!this.isRaidable()) return __original();

		this.m.HD_IsTemporaryUnallied = true;
		local ret = __original();
		this.m.HD_IsTemporaryUnallied = false;

		if (this.isActive() && this.isInLockdown())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/locked_small.png",
				text = "Is in Lockdown and cannot be attacked",
			});
		}

		return ret;
	}
});

