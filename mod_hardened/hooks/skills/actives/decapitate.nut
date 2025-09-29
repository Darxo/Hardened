::Hardened.HooksMod.hook("scripts/skills/actives/decapitate", function(q) {
	// Fix: display the actual minimum armor penetration (ignoring remaining armor reduction) as the minimum value for weapon skills instead of hard-coded 0
	// decapitate is one of the few vanilla skills, which does not use getDefaultTooltip to display and has custom logic for calculating its damage
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

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

		return ret;
	}
});
