::Hardened.HooksMod.hook("scripts/skills/perks/perk_nimble", function(q) {
	q.getDescription = @() function()
	{
		// We remove the part about lighter armor granting more bonus
		return "Nimble like a cat! This character is able to partially evade or deflect attacks at the last moment, turning them into glancing hits.";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		::Hardened.util.HD_deleteBulletPoint(ret, function(_entry) {
			if (_entry.id == 6 && _entry.icon == "ui/icons/special.png") return true;		// Remove the vanilla mitigation tooltip
			if (_entry.id == 12 && _entry.icon == "ui/icons/rf_reach.png") return true;		// Remove the reforged reach advantage tooltip
			if (_entry.id == 13 && _entry.icon == "ui/icons/fatigue.png") return true;		// Remove the reforged effectiveness hint
			return false;
		});

		local armorDamageMult = this.getArmorDamage();
		if (armorDamageMult > 1.0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Take " + ::MSU.Text.colorizeMultWithText(armorDamageMult, {InvertColor = true}) + " Armor Damage from Attacks",
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
