::Hardened.HooksMod.hook("scripts/items/shields/shield", function(q) {
	q.applyShieldDamage = @(__original) function( _damage, _playHitSound = true )
	{
		_damage = ::Math.max(1, ::Math.ceil(_damage * this.getContainer().getActor().getCurrentProperties().ShieldDamageMult));

		return __original(_damage, _playHitSound);
	}

	q.RF_getDefenseMult = @() function()
	{
		return 1.0;	// Fatigue no longer affects the shield defense in any way
	}
});

::Reforged.HooksMod.hookTree("scripts/items/shields/shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ReachIgnore = 0;	// ReachIgnore is effectively removed from all shields
	}
});
