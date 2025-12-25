::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_man_of_steel", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsHidingIconMini = true;	// We hide the mini-icon to reduce bloat during battle as its existance conveys no situation-specific information
	}

	q.isHidden = @() function()
	{
		return this.getDirectDamageReceivedMult() == 1.0;
	}

	// Overwrite, because we apply our damage mitigation under completely different rules
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/direct_damage.png",
			text = ::Reforged.Mod.Tooltips.parseString("Take " + ::MSU.Text.colorizeMultWithText(this.getDirectDamageReceivedMult(), {InvertColor = true}) + " [Armor Penetration|Concept.ArmorPenetration] Damage from Attacks"),
		});

		return ret;
	}

	// Overwrite because we use out own function to applying the mitigation and we reduce the reforged conditions
	q.onBeforeDamageReceived = @() function( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null || !_skill.isAttack()) return;

		_properties.DamageReceivedDirectMult *= this.getDirectDamageReceivedMult();
	}

// New Functions
	q.getDirectDamageReceivedMult <- function()
	{
		local chestWeight = this.getContainer().getActor().getItems().getWeight([::Const.ItemSlot.Body]);
		local helmetWeight = this.getContainer().getActor().getItems().getWeight([::Const.ItemSlot.Head]);
		local lowestWeight = helmetWeight < chestWeight ? helmetWeight : chestWeight;
		return 1.0 - (lowestWeight / 100.0);
	}
});
