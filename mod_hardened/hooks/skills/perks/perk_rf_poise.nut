::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_poise", function(q) {
	q.m.DirectDamageReceivedMult <- 0.4;
	q.m.IntiativeAsArmorMultFraction <- 0.4;	// This fraction of current Initiative is turned into a percentage and applied as armor reduction

	// Const
	q.m.ArmorDamageReceivedMultMax <- 0.6;

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Deftly shift and twist, even within your armor, to minimize the impact of attacks.";
	}

	q.getTooltip = @() function()	// Overwrite because can't resuse any of reforged' code
	{
		local tooltip = this.skill.getTooltip();

		local directDamageReceivedMult = this.getDirectDamageReceivedMult();
		if (directDamageReceivedMult != 1.0)
		{
			tooltip.push({
				id = 10,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = ::Reforged.Mod.Tooltips.parseString("Take " + ::MSU.Text.colorizeMultWithText(directDamageReceivedMult, {InvertColor = true}) + " [Armor Penetration|Concept.ArmorPenetration] damage from Attacks"),
			});
		}

		local armorDamageReceivedMult = this.getArmorDamageReceivedMult();
		if (armorDamageReceivedMult != 1.0)
		{
			tooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "Take " + ::MSU.Text.colorizeMultWithText(armorDamageReceivedMult, {InvertColor = true}) + " Armor Damage from Attacks",
			});
		}

		return tooltip;
	}

	q.isHidden = @() function()
	{
		return this.m.IsHidden;		// For peformance reasons we just display it all the time because the situations where it would be hidden are now very rare
	}

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		// Do nothing: Poise no longer grants reach ignore
	}

	q.onBeforeDamageReceived = @() function( _attacker, _skill, _hitInfo, _properties )		// Overwrite: Poise no longer provides regular damage reduction
	{
		if (_skill == null || !_skill.isAttack()) return;

		_properties.DamageReceivedDirectMult *= this.getDirectDamageReceivedMult();
		_properties.DamageReceivedArmorMult *= this.getArmorDamageReceivedMult();
	}

// New Functions
	q.getDirectDamageReceivedMult <- function()
	{
		local totalWeight = this.getContainer().getActor().getItems().getWeight([::Const.ItemSlot.Body, ::Const.ItemSlot.Head]);
		local directDamageMult = this.m.DirectDamageReceivedMult + (totalWeight / 100.0);
		return ::Math.minf(1.0, directDamageMult);	// We never want this perk to ever increase damage taken
	}

	q.getArmorDamageReceivedMult <- function()
	{
		local initiative = ::Math.max(0, ::Math.floor(this.getContainer().getActor().getInitiative()));
		local armorMultFraction = initiative * this.m.IntiativeAsArmorMultFraction / 100.0;
		return ::Math.maxf(this.m. ArmorDamageReceivedMultMax, 1.0 - armorMultFraction);	// We turn the fraction into a multiplier for armor damage taken
	}
});
