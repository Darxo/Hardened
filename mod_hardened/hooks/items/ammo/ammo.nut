::Hardened.HooksMod.hook("scripts/items/ammo/ammo", function(q) {
	q.m.AmmoWeight <- 0.0;			// Every Ammo in this bag applies this value as a negative StaminaModifier
	q.m.StaminaModifier <- 0;		// Flat StaminaModifier. In Vanilla this already exists on most other equipables

	q.create = @(__original) function()
	{
		__original();
		this.m.SlotType = ::Const.ItemSlot.Ammo,		// This is a line that Vanilla just forgot to include in this shared parent class
		this.m.ItemType = ::Const.Items.ItemType.Ammo;	// This is a line that Vanilla just forgot to include in this shared parent class
	}

	q.onEquip = @(__original) function()
	{
		__original();
		this.addGenericItemSkill();		// Now that ammunition can inflict a Staminamodifier by design and potentially more effects we force an addGenericItemSkill call
	}

	q.consumeAmmo = @(__original) function()
	{
		__original();

		local actor = this.getContainer().getActor();
		if (this.getAmmo() == 0 && actor.isPlayerControlled() && actor.isPlacedOnMap())
		{
			local tile = actor.getTile();
			if (tile.IsVisibleForPlayer)
			{
				::Tactical.spawnIconEffect("status_effect_63", tile, ::Const.Tactical.Settings.SkillIconOffsetX, ::Const.Tactical.Settings.SkillIconOffsetY, ::Const.Tactical.Settings.SkillIconScale, ::Const.Tactical.Settings.SkillIconFadeInDuration, ::Const.Tactical.Settings.SkillIconStayDuration, ::Const.Tactical.Settings.SkillIconFadeOutDuration, ::Const.Tactical.Settings.SkillIconMovement);
			}
		}
	}

// Function overwrites of 'item.nut' functions

	// New function that new ammunition items can use to reduce the amount of copying the same lines
	q.getTooltip = @(__original) function()
	{
		local ret = __original();   // Name + Description + Category + Value + image

		if (this.getStaminaModifier() != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Maximum Fatigue " + ::MSU.Text.colorizeValue(this.getStaminaModifier(), {AddSign = true}),
			});
		}

		if (this.m.Ammo != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Contains " + ::MSU.Text.colorPositive(this.getAmmo()) + " " + ::Hardened.Const.getAmmoType(this.getAmmoType()).Name,
			});
		}
		else
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::MSU.Text.colorNegative("Is empty and useless"),
			});
		}

		if (this.getAmmoWeight() != 0.0)
		{
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/bag.png",
				text = "Weight per Ammo: " + ::MSU.Text.colorNegative(this.getAmmoWeight()),
			});
		}

		ret.push({
			id = 16,
			type = "text",
			icon = "ui/icons/asset_ammo.png",
			text = "Refill cost per Ammo: " + ::MSU.Text.colorNegative(this.getAmmoCost()),
		});

		return ret;
	}

	q.getStaminaModifier = @() function()
	{
		local staminaModifier = this.m.StaminaModifier;		// flat modifier
		staminaModifier -= this.getCombinedAmmoWeight();		// scaling modifier
		return staminaModifier;
	}

	q.onUpdateProperties = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.Stamina += this.getStaminaModifier();
	}

// New Functions
	q.getCombinedAmmoWeight <- function()
	{
		return ::Math.ceil(this.getAmmo() * this.getAmmoWeight());
	}

	q.getAmmoWeight <- function()
	{
		return this.m.AmmoWeight;
	}
});
