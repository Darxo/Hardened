::Hardened.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
	// Public
	q.m.AmmoWeight <- 0.0;			// Every Ammo in this weapon applies this value as a Weight while equipped in additiona to the base weight of this item

	q.getTooltip = @(__original) function()
	{
		// Vanilla accesses the Stamina value directly, which would circumvent our AmmoWeight behavior
		// That's why we do a switcheroo here and briefly switch out the member variable with the Weight we want vanilla do display
		local oldStaminaModifier = this.m.StaminaModifier;
		this.m.StaminaModifier = this.getStaminaModifier();
		local ret = __original();
		this.m.StaminaModifier = oldStaminaModifier;

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

// Hardened Functions
	q.HD_getBrush = @(__original) function()
	{
		if (this.m.ArmamentIcon == "") return __original();

		local ret = this.m.ArmamentIcon;

		if (this.m.IsBloodied && ::doesBrushExist(ret + "_bloodied"))
		{
			ret += "_bloodied";
		}

		return ret;
	}

	q.HD_getSilhouette = @(__original) function()
	{
		if (this.m.ShowArmamentIcon)
			return __original();
		else
			return null;
	}

// New Functions
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

	q.getStaminaModifier = @(__original) function()
	{
		return __original() - this.getCombinedAmmoWeight();
	}
});
