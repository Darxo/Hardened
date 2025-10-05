::Hardened.HooksMod.hook("scripts/skills/actives/overhead_strike", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// Fix: display the actual minimum armor penetration (ignoring remaining armor reduction) as the minimum value for weapon skills instead of hard-coded 0
		// overhead_strike is one of the few vanilla skills, which does not use getDefaultTooltip and uses custom logic for calculating its damage tooltip
		foreach (entry in ret)
		{
			if (entry.id == 4 && entry.type == "text" && entry.icon == "ui/icons/regular_damage.png")
			{
				local p = this.getContainer().buildPropertiesForUse(this, null);
				local damage_regular_min = ::Math.floor(p.DamageRegularMin * p.DamageRegularMult * p.DamageTotalMult * p.MeleeDamageMult);
				local damage_direct_min = ::Math.floor(damage_regular_min * ::Math.minf(1.0, p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd + p.DamageDirectMeleeAdd)));
				entry.text = ::MSU.String.replace(entry.text, "of which [color=" + ::Const.UI.Color.DamageValue + "]0[/color]", "of which " + ::MSU.Text.colorDamage(damage_direct_min));
				break;
			}
		}

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png" && ::String.contains(entry.text, "+5%"))
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (_skill == this)
		{
			_properties.MeleeSkill -= 5;	// This reverts the vanilla +5 Modifier
		}
	}
});
