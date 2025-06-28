::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_crossbow", function(q) {
	// Public
	q.m.HD_FatigueCostMult <- 0.75;
	q.m.RequiredWeaponType <- ::Const.Items.WeaponType.Crossbow | ::Const.Items.WeaponType.Firearm;
	q.m.FirearmReloadAPModifier <- -1;	// AP cost of Reload with Handgonnes is modified by this value

	// Overwrite, because we no longer grant an action point discount
	q.onAfterUpdate = @() function( _properties )
	{
		if (!this.isEnabled()) return;

		// Feat: We now implement the fatigue cost discount of masteries within the mastery perk
		if (this.m.HD_FatigueCostMult != 1.0)
		{
			foreach (skill in this.getContainer().m.Skills)
			{
				if (this.isSkillValid(skill))
				{
					skill.m.FatigueCostMult *= this.m.HD_FatigueCostMult;
				}
			}
		}

		if (this.m.FirearmReloadAPModifier != 0)
		{
			foreach (skill in this.getContainer().m.Skills)
			{
				if (skill.getID() == "actives.reload_handgonne")
				{
					skill.m.ActionPointCost += this.m.FirearmReloadAPModifier;	// Reload with Handgonnes is cheaper
					break;
				}
			}
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		if (this.isEnabled())
		{
			local helmet = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Head);
			if (helmet != null && helmet.m.Vision < 0)
			{
				_properties.Vision += 1;
			}
		}
	}

	q.onEquip = @(__original) function( _item )
	{
		__original(_item);
		if (::Tactical.isActive() && ::Time.getRound() > 0)	// Round 0 is not interesting to us for this visibility calculation
		{
			// visibility is usually not changing when switching gear, but with crossbow mastery this can happen now. So we need to manually re-calculate visibility
			this.getContainer().getActor().updateVisibilityForFaction();
		}
	}

// New Reforged Functions
	q.isEnabled <- function()
	{
		if (this.m.RequiredWeaponType == null) return true;

		local weapon = this.getContainer().getActor().getMainhandItem();
		if (::MSU.isNull(weapon)) return false;
		if (!weapon.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!weapon.isWeaponType(this.m.RequiredWeaponType)) return false;

		return true;
	}

	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(this.m.RequiredWeaponType)) return false;

		return true;
	}
});
