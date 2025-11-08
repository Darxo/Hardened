::Hardened.HooksMod.hook("scripts/skills/racial/spider_racial", function(q) {
	// Public
	q.m.FireDamageMult <- 1.5;

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		if (this.m.FireDamageMult != 1.0)
		{
			ret.push({
				id = 25,
				type = "text",
				icon = "ui/icons/campfire.png",
				text = "Take " + ::MSU.Text.colorizeMultWithText(this.m.FireDamageMult, {InvertColor = true}) + " Fire Damage",
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
				_properties.DamageReceivedTotalMult *= this.m.FireDamageMult;
				break;
		}
	}}.onBeforeDamageReceived;

	// Vanilla Fix: Vanilla never checks, whether _targetEntity is null, before calling a function on it
	// We prevent the vanilla logic from running when _targetEntity is null
	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null) return;

		__original(_skill, _targetEntity, _properties);
	}
});
