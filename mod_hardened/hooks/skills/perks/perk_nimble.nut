::Hardened.HooksMod.hook("scripts/skills/perks/perk_nimble", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// Remove the existing tooltips
		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			local entry = ret[index];
			if (entry.id == 12 && entry.icon == "ui/icons/rf_reach.png")
			{
				ret.remove(index);
			}
			else if (entry.id == 13)	// Remove mention about effectiveness difference depending on weight
			{
				ret.remove(index);
			}
		}

		local armorDamageMult = this.getArmorDamage();
		if (armorDamageMult > 1.0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Take " + ::MSU.Text.colorizeMultWithText(armorDamageMult, {InvertColor = true}) + " armor damage from attacks",
			});
		}

		return ret;
	}

	q.getHitpointsDamage = @() function()
	{
		return 0.4;
	}

	q.getArmorDamage = @() function()
	{
		local weight = this.getContainer().getActor().getItems().getWeight([::Const.ItemSlot.Body, ::Const.ItemSlot.Head]);
		return 1.0 + (weight / 100.0);
	}

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		// Do nothing: Nimble no longer grants reach ignore
	}
});
