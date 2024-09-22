::Hardened.HooksMod.hook("scripts/skills/perks/perk_shield_expert", function(q) {
	q.m.ShieldDamageReceivedMult <- 0.5;

	q.onUpdate = @() function( _properties )	// overwrite: no longer sets IsSpecializedInShields to true
	{
		if (this.getContainer().getActor().isArmedWithShield())
		{
			_properties.ShieldDamageReceivedMult *= this.m.ShieldDamageReceivedMult;
			_properties.CanEnemiesHaveReachAdvantage = false;
		}
	}

	// Overwrite these two function to disable the no-fatigue-on-miss reforged effect
	q.onBeingAttacked = @() function( _attacker, _skill, _properties ) {}
	q.onMissed = @() function( _attacker, _skill ) {}
});
