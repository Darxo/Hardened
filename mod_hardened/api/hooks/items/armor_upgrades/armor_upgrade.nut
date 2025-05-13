::Hardened.HooksMod.hook("scripts/items/armor_upgrades/armor_upgrade", function(q) {
	q.getWeight = @() function()	// Vanilla spagetthi code: Attachement's StaminaModifier are reversed. They actually resemble Weight very closely
	{
		local staminaModifier = this.m.StaminaModifier;	// There is no getStaminaModifier defined for armor_upgrades in Vanilla
		return ::Math.max(0, staminaModifier);
	}
});

::Hardened.HooksMod.hookTree("scripts/items/armor_upgrades/armor_upgrade", function(q) {
	q.onUse = @(__original) function( _actor, _item = null )
	{
		local ret = __original(_actor, _item);

		if (ret)
		{
			::World.Statistics.getFlags().increment("ArmorAttachementsApplied");
		}

		return ret;
	}
});
