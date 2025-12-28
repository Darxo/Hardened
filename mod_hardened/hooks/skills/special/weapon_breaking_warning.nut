::Hardened.HooksMod.hook("scripts/skills/special/weapon_breaking_warning", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "This character\'s weapon is in poor condition.";	// Remove mention of permanently breaking, as that is removed in Reforged

		// Vanilla has no member table so we need to add our member variables like this
		// Public
		this.m.DamageTotalMult <- 0.50;	// Weapon Damage multiplier, while the weapon is in the broken state
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({		// This effect is applied in lowerCondition from weapon.nut
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Weapon will drop to the ground when it loses condition",
		});

		if (this.m.DamageTotalMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "Weapon deals " + ::MSU.Text.colorizeMultWithText(this.m.DamageTotalMult) + " damage",
			});
		}

		return ret;
	}

	// Overwrite, because we only show this effect when the weapon has exactly 0 condition
	q.isHidden = @() function()
	{
		return !this.isEnabled();
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.isEnabled())
		{
			local mainhandItem = this.getMainhandWeapon();
			_properties.DamageRegularMax -= mainhandItem.m.RegularDamageMax * (1.0 - this.m.DamageTotalMult);
			_properties.DamageRegularMin -= mainhandItem.m.RegularDamage * (1.0 - this.m.DamageTotalMult);
		}
	}

// New Functions
	q.getMainhandWeapon <- function()
	{
		local mainhandItem = this.getContainer().getActor().getMainhandItem();
		if (mainhandItem == null) return null;
		if (mainhandItem.isItemType(::Const.Items.ItemType.Weapon) == false) return null;
		return mainhandItem;
	}

	q.isEnabled <- function()
	{
		local mainhandItem = this.getMainhandWeapon();
		if (mainhandItem == null) return false;

		return mainhandItem.getCondition() == 0;
	}
});
