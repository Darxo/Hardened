::Hardened.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
	// Public
	q.m.AmmoWeight <- 0.0;			// Every Ammo in this weapon applies this value as a Weight while equipped in additiona to the base weight of this item

	q.getTooltip = @(__original) function()
	{
		// We pretend like every item has a Weight so that Vanilla always produces its weight tooltip at the same consistent position
		// This is important, because Vanilla does a StaminaModifier check on the member, instead of using the getter. So it will not work with our ammunition/throwing items which have no base weight
		local oldStaminaModifier = this.m.StaminaModifier;
		this.m.StaminaModifier = -1;	// Any negative number will work
		local ret = __original();
		this.m.StaminaModifier = oldStaminaModifier;

		foreach (entry in ret)
		{
			if (entry.id == 64 && entry.icon == "ui/icons/direct_damage.png")
			{
				entry.text = ::MSU.String.replace(entry.text, "of damage ignores armor", ::Reforged.Mod.Tooltips.parseString("[Armor Penetration|Concept.ArmorPenetration]"));
			}
			else if (entry.id == 10 && entry.icon == "ui/icons/ammo.png")
			{
				// Vanilla does not show the maximum ammunition. We now also color the remaining ammunition in the negative color if it is 0
				entry.text = "Remaining Ammo: " + ::MSU.Text.colorizeValue(this.getAmmo(), {CompareTo = 1}) + " / " + this.getAmmoMax();
			}
		}

		if (this.m.AmmoWeight != 0.0)
		{
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/bag.png",
				text = "Weight per Ammo: " + ::MSU.Text.colorNegative(this.getAmmoWeight()),
			});
		}

		if (this.m.AmmoMax != 0)
		{
			ret.push({
				id = 16,
				type = "text",
				icon = "ui/icons/asset_ammo.png",
				text = "Refill cost per Ammo: " + ::MSU.Text.colorNegative(this.getAmmoCost()),
			});
		}

		return ret;
	}

	q.lowerCondition = @(__original) function(_value = ::Const.Combat.WeaponDurabilityLossOnHit)
	{
		// In vanilla it is assumed that this weapon is already equipped to someone when this function is called
		local scaledValue = _value * this.getContainer().getActor().getCurrentProperties().WeaponDurabilityLossMult;
		__original(scaledValue);
	}

	q.onUpdateProperties = @(__original) function( _properties )
	{
		// Switcheroo because the vanilla function accesses the StaminaModifier variable directly instead of using the getter function
		local oldStaminaModifier = this.m.StaminaModifier;
		this.m.StaminaModifier = this.getStaminaModifier();
		__original(_properties);
		this.m.StaminaModifier = oldStaminaModifier;
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		this.m.Ammo = ::Math.min(this.m.Ammo, this.m.AmmoMax);	// Prevent Ammo from ever being larger than AmmoMax
	}

// New Function
	q.isHybridWeapon <- function()
	{
		return ((this.m.WeaponType & (this.m.WeaponType - 1)) != 0);
	}

	q.getCombinedAmmoWeight <- function()
	{
		return ::Math.ceil(this.getAmmo() * this.getAmmoWeight());
	}

	q.getAmmoWeight <- function()
	{
		return this.m.AmmoWeight;
	}
});

::Hardened.HooksMod.hookTree("scripts/items/weapons/weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Ammo = ::Math.min(this.m.Ammo, this.m.AmmoMax);	// Prevent Ammo from ever being larger than AmmoMax
	}

	// We replace the vanilla weight tooltip on all items with a more descriptive and hyperlinked term
	q.getStaminaModifier = @(__original) function()
	{
		return __original() - this.getCombinedAmmoWeight();
	}
});
