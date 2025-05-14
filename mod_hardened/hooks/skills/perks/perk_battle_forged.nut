::Hardened.HooksMod.hook("scripts/skills/perks/perk_battle_forged", function(q) {
	q.m.ArmorConditionToMitigationPct <- 0.05;	// Every combined Armor Condition contributes to this much percentage Armor Mitigation

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Specialize in heavy armor!";
	}

	q.isHidden = @() function()
	{
		return this.getArmorDamageReceivedMult() == 1.0;
	}

	// Overwrite, because we revert vanillas overwrite with a verbose dynamic description
	q.getDescription = @() function()
	{
		return this.m.Description;
	}

	// Overwrite, because we don't re-use any tooltips from vanilla or reforged
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		local armorDamageReceivedMult = this.getArmorDamageReceivedMult();
		if (armorDamageReceivedMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "Take " + ::MSU.Text.colorizeMultWithText(armorDamageReceivedMult, {InvertColor = true}) + " Armor Damage from Attacks",
			});
		}

		return ret;
	}

	// Overwrite because we now calculate the armor mitigation with a helper function and we reduce the conditions for this effect to apply
	q.onBeforeDamageReceived = @() function( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null || !_skill.isAttack()) return;	// In Vanilla this mitigation requires also a valid attacker who is not us
		_properties.DamageReceivedArmorMult *= this.getArmorDamageReceivedMult();
	}

// Reforged Functions
	q.getReachIgnore = @() function()
	{
		return 0;	// Do nothing: Battle Forged no longer grants reach ignore
	}

// New Functions
	q.getArmorDamageReceivedMult <- function()
	{
		local actor = this.getContainer().getActor();
		local armor = actor.getArmor(::Const.BodyPart.Head) + actor.getArmor(::Const.BodyPart.Body);
		// We floor the second decimale place to be in line with the perk description (every full 20 condition = 1% mitigation)
		local armorMitigationPct = ::Math.floor(armor * this.m.ArmorConditionToMitigationPct) / 100.0;
		return ::Math.maxf(1.0 - armorMitigationPct, 0);		// We turn the pct into a multiplier for armor damage taken
	}
});
