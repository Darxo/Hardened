::Hardened.HooksMod.hook("scripts/skills/perks/perk_shield_expert", function(q) {
	q.m.ShieldDamageMult <- 0.5;

	q.onUpdate = @() function( _properties )	// overwrite: no longer sets IsSpecializedInShields to true
	{
		if (this.getContainer().getActor().isArmedWithShield())
		{
			_properties.ShieldDamageMult *= this.m.ShieldDamageMult;
			_properties.IsAffectedByReach = false;
		}
	}
});
