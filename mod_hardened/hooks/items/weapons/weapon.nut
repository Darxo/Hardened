::Hardened.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 64 && entry.icon == "ui/icons/direct_damage.png")
			{
				entry.text = ::MSU.String.replace(entry.text, "of damage ignores armor", ::Reforged.Mod.Tooltips.parseString("[Armor Penetration|Concept.ArmorPenetration]"));
				break;
			}
		}

		return ret;
	}

	q.lowerCondition = @(__original) function(_value = ::Const.Combat.WeaponDurabilityLossOnHit)
	{
		// In vanilla it is assumed that this weapon is already equipped to someone when this function is called
		local scaledValue = _value * this.getContainer().getActor().getCurrentProperties().WeaponDurabilityLossMult;
		__original(scaledValue);
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
});

::Hardened.HooksMod.hookTree("scripts/items/weapons/weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Ammo = ::Math.min(this.m.Ammo, this.m.AmmoMax);	// Prevent Ammo from ever being larger than AmmoMax
	}
});
