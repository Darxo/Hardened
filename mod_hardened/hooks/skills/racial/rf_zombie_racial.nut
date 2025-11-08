::Hardened.HooksMod.hook("scripts/skills/racial/rf_zombie_racial", function(q) {
	q.m.FireDamageMult <- 1.5;

	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueDealtPerHitMultModifier = 0;	// Reforged: 1.0
	}

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		if (this.m.FireDamageMult != 1.0)
		{
			ret.push({
				id = 25,
				type = "text",
				icon = "ui/icons/campfire.png",
				text = "Your Hitpoints take " + ::MSU.Text.colorizeMultWithText(this.m.FireDamageMult, {InvertColor = true}) + " Fire Damage",
			});
		}

		return ret;
	}}.getTooltip;

	q.onBeforeDamageReceived = @(__original) { function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		__original(_attacker, _skill, _hitInfo, _properties);

		switch (_hitInfo.DamageType)
		{
			case ::Const.Damage.DamageType.Burning:
				_properties.DamageReceivedRegularMult *= this.m.FireDamageMult;
				break;
		}
	}}.onBeforeDamageReceived;
});
