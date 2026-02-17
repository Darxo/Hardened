::Hardened.HooksMod.hook("scripts/retinue/followers/brigand_follower", function(q) {
	q.m.HuntingSpeedMult <- 1.2;

	q.create = @(__original) function()
	{
		__original();
		this.m.Effects[0] = "Travel 20% faster while following a visible enemy";
	}

	q.onUpdate = @(__original) function()
	{
		// We no longer reveal caravans on the world map
		::World.Assets.m.IsBrigand = false;
	}

// MSU Functions
	q.getMovementSpeedMult = @() function()
	{
		local ret = 1.0;

		if (this.isFollowingParty())
		{
			ret *= this.m.HuntingSpeedMult;
		}

		return ret;
	}

// New Functions
	q.isFollowingParty <- function()
	{
		local autoAttack = ::World.State.m.AutoAttack;
		if (::MSU.isNull(autoAttack)) return false;
		if (!autoAttack.isAlive()) return false;
		if (autoAttack.isHiddenToPlayer()) return false;
		if (autoAttack.isAlliedWithPlayer()) return false;

		return true;
	}
});
