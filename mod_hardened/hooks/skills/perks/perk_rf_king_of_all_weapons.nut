::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_king_of_all_weapons", function(q) {
	q.m.HD_DamageTotalMult <- 0.9;
	q.m.HD_FatigueCostMult <- 0.0;

	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointsModifier = 0;
		this.m.DamageTotalMult = 0;
	}

	q.isHidden = @() function()
	{
		return true;	// This perk no longer displays any tooltip
	}

	// Overwrite original for performance reasons
	q.onAfterUpdate = @() function( _properties )
	{
		// Reduce fatigue cost of all spear attacks
		foreach (skill in this.getContainer().m.Skills)
		{
			if (!skill.isGarbage() && this.isSkillValid(skill))
			{
				skill.m.FatigueCostMult *= this.m.HD_FatigueCostMult;
			}
		}
	}

// New Overrides
	q.onUpdate = @() function( _properties )
	{
		local actor = this.getContainer().getActor();
		local mainhand = actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (mainhand != null && mainhand.isWeaponType(::Const.Items.WeaponType.Spear) && !actor.isDisarmed())
		{
			_properties.DamageTotalMult *= this.m.HD_DamageTotalMult;
		}
	}
});
