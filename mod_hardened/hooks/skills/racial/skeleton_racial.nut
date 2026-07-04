::Hardened.HooksMod.hook("scripts/skills/racial/skeleton_racial", function(q) {
	// Public
	q.m.FatigueEffectMult <- 0.0;	// In Vanilla this is implemented via their faction stats instead
	q.m.FireDamageMult <- 0.25;
	q.m.PiercingDamageMult <- 0.5;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// We delete the no longer needed damage reduction entries
		::Hardened.util.HD_deleteBulletPoint(ret, function(_entry) {
			if (_entry.id == 11 && _entry.icon == "ui/icons/ranged_defense.png") return true;
			return false;
		});

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

		if (this.m.FatigueEffectMult != 1.0)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Build up " + ::MSU.Text.colorizeMultWithText(this.m.FatigueEffectMult, {InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Fatigue|Concept.Fatigue]"),
			});
		}

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		// We set the value here to improve performance and because we assume that this racial effect is never removed from characters
		// In Vanilla this property is defined in the Base Stat definitions of the respective entity types
		this.getContainer().getActor().getBaseProperties().FatigueEffectMult = this.m.FatigueEffectMult;
	}

	q.onBeforeDamageReceived = @() { function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		switch (_hitInfo.DamageType)
		{
			case ::Const.Damage.DamageType.Burning:
				_properties.DamageReceivedRegularMult *= this.m.FireDamageMult;
				break;
			case ::Const.Damage.DamageType.Piercing:
				_properties.DamageReceivedRegularMult *= this.m.PiercingDamageMult;
				break;
		}
	}}.onBeforeDamageReceived;
});
