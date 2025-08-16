::Hardened.HooksMod.hook("scripts/items/armor_upgrades/additional_padding_upgrade", function(q) {
	q.m.DirectDamageReceivedMult <- 0.67;	// Vanilla: 0.66

	// Overwrite, because this now only mitigates attack skills, instead of anything that has an attacker
	q.onBeforeDamageReceived = @() function( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null || !_skill.isAttack()) return;
		if (_hitInfo.BodyPart != ::Const.BodyPart.Body) return;		// Only protects body

		_properties.DamageReceivedDirectMult *= this.getDirectDamageReceivedMult();
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		this.adjustArmorPenetrationTooltip(ret);

		return ret;
	}

	q.onArmorTooltip = @(__original) function( _result )
	{
		__original(_result);
		this.adjustArmorPenetrationTooltip(_result);
	}

// New Functions
	q.getDirectDamageReceivedMult <- function()
	{
		return this.m.DirectDamageReceivedMult;
	}

	q.adjustArmorPenetrationTooltip <- function( _tooltip )
	{
		foreach (index, entry in _tooltip)
		{
			if (entry.id == 15 && entry.icon == "ui/icons/direct_damage.png")
			{
				local directDamageReceivedMult = this.getDirectDamageReceivedMult();
				if (directDamageReceivedMult == 1.0)
				{
					_tooltip.remove(index);
				}
				else
				{
					entry.text = ::Reforged.Mod.Tooltips.parseString("Take " + ::MSU.Text.colorizeMultWithText(directDamageReceivedMult, {InvertColor = true}) + " [Armor Penetration|Concept.ArmorPenetration] damage from Body Attacks");
				}
				break;
			}
		}
	}
});
