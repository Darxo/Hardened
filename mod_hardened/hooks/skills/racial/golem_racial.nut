::Hardened.HooksMod.hook("scripts/skills/racial/golem_racial", function(q) {
	q.m.PiercingDamageMult <- 0.50;
	q.m.FireDamageMult <- 0.0;		// Since this character is immune to burning

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// We delete the additional, no longer needed damage reduction entries
		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			local entry = ret[index];
			if (entry.id == 11 && entry.icon == "ui/icons/ranged_defense.png")
			{
				ret.remove(index);
			}
			else if (entry.id == 12 && entry.icon == "ui/icons/campfire.png")
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
		}

		return ret;
	}

	// Overwrite, because we completely change the damage reductions chosen by Reforged
	q.onBeforeDamageReceived = @() { function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		// Same as Vanilla/Reforged
		if (_skill != null && _skill.getID() == "actives.throw_golem")
		{
			_properties.DamageReceivedTotalMult = 0.0;
			return;
		}

		// We remove Reforged blunt reduction and combine the verbose piercing reduction
		switch (_hitInfo.DamageType)
		{
			case null:
				break;

			case ::Const.Damage.DamageType.Burning:
				_properties.DamageReceivedTotalMult *= this.m.FireDamageMult;
				break;

			case ::Const.Damage.DamageType.Piercing:
			_properties.DamageReceivedTotalMult *= this.m.PiercingDamageMult;
				break;
		}
	}}.onBeforeDamageReceived;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.HitpointsMult *= 0.5;

		local size = this.getContainer().getActor().getSize();
		if (size == 2)
		{
			_properties.DamageRegularMin -= 10;
			_properties.DamageRegularMax -= 10;
			// Medium Golems now deal -10 damage but gain Marksmanship perk in return
		}
		else if (size == 3)
		{
			// Large Golems now deal -10 damage but gain Marksmanship perk in return
			_properties.DamageRegularMin -= 10;
			_properties.DamageRegularMax -= 10;
		}
	}
});
