::Hardened.HooksMod.hook("scripts/skills/perks/perk_nimble", function(q) {

	q.getTooltip = @(__original) function()
	{
		local ret = __original()

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/reach.png")
			{
				ret.remove(index);
				break;
			}
		}

		local armorDamageMult = this.getArmorDamage();
		if (armorDamageMult > 1.0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Damage to armor from attacks is increased by " + ::MSU.Text.colorizeMult(armorDamageMult, {InvertColor = true}),
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
