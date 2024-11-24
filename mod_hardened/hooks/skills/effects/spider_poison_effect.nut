::Hardened.HooksMod.hook("scripts/skills/effects/spider_poison_effect", function (q) {
	q.m.HitpointRecoveryMult <- 0.5;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.HitpointRecoveryMult *= this.m.HitpointRecoveryMult;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/damage_received.png",
			text = ::Reforged.Mod.Tooltips.parseString("Recover " + ::MSU.Text.colorizeMultWithText(this.m.HitpointRecoveryMult) + " [Hitpoints|Concept.Hitpoints]"),
		});

		return ret;
	}
});
