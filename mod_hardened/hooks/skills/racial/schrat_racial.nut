::Hardened.HooksMod.hook("scripts/skills/racial/schrat_racial", function(q) {
	// Public
	q.m.PiercingDamageMult <- 0.5;
	q.m.FireDamageMult <- 2.0;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// We delete the no longer needed damage reduction entries
		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			local entry = ret[index];
			if (entry.id == 30 && entry.icon == "skills/status_effect_86.png")
			{
				ret.remove(index);	// Remove the tooltip about the vanilla 70% damage mitigation. That is now implemented via a new perk
			}
			else if (entry.id == 11 && entry.icon == "ui/icons/ranged_defense.png")
			{
				ret.remove(index);
			}
		}

		// Adjust the one remaining damage reduction tooltip according to our standardized reduction
		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/melee_defense.png")
			{
				entry.text = "Take " + ::MSU.Text.colorizeMultWithText(this.m.PiercingDamageMult, {InvertColor = true}) + " Piercing Damage";
			}
			else if (entry.id == 12 && entry.icon == "ui/icons/campfire.png")
			{
				entry.text = "Take " + ::MSU.Text.colorizeMultWithText(this.m.FireDamageMult, {InvertColor = true}) + " Fire Damage";
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// We revert the damage mult changes as that effect is now implemented via a new perk
		local oldDamageReceivedTotalMult = _properties.DamageReceivedTotalMult;
		__original(_properties);
		_properties.DamageReceivedTotalMult = oldDamageReceivedTotalMult;
	}

	q.onBeforeDamageReceived = @() { function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		switch (_hitInfo.DamageType)
		{
			case null:
				break;

			case ::Const.Damage.DamageType.Burning:
				_properties.DamageReceivedRegularMult *= this.m.FireDamageMult;
				break;

			case ::Const.Damage.DamageType.Piercing:
				_properties.DamageReceivedRegularMult *= this.m.PiercingDamageMult;
				break;
		}
	}}.onBeforeDamageReceived;
});
