::Hardened.HooksMod.hook("scripts/skills/actives/rf_take_aim_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Put additional effort into getting a better aim with crossbows or further aim with firearms.";
		this.m.SoundOnUse = [	// Reforged: []
			"sounds/combat/reload_01.wav",
			"sounds/combat/reload_02.wav",
		];
		this.m.ActionPointCost = 3;		// Reforged: 2
		this.m.FatigueCost = 25;		// In Reforged this is 25
	}

	// Overwrite, because we want to remove the reforged condition change for isHidden and always show it
	q.isHidden = @() function()
	{
		return this.skill.isHidden();
	}

	// Overwrite, because Reforged checks for isLoaded in their implementation, which does not exist on all weapons we allow now
	q.getTooltip = @() function()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		local takeAimEffect = ::new("scripts/skills/effects/rf_take_aim_effect");
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain [Taking Aim|Skill+rf_take_aim_effect]"),
			children = takeAimEffect.getTooltip().slice(2), 	// slice 2 to remove name and description
		});

		return ret;
	}

	q.isUsable = @() function()
	{
		if (!this.isEnabled()) return false;

		local actor = this.getContainer().getActor();
		if (actor.isEngagedInMelee()) return false;
		if (this.getContainer().hasSkill("effects.rf_take_aim")) return false;

		// We make sure, that this character has at least one usable attack skill, before allowing them to use this skill
		foreach (_weaponSkill in this.getContainer().getActor().getMainhandItem().m.SkillPtrs)
		{
			if (!_weaponSkill.isAttack()) continue;
			if (!_weaponSkill.isUsable()) continue;		// This does not check for ap and fatigue cost but that is fine
			return true;
		}

		return false;
	}

// Reforged Functions
	// Overwrite, because we rework the conditions defined by Reforged
	q.isEnabled = @() function()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();
		if (::MSU.isNull(weapon)) return false;

		if (weapon.isWeaponType(::Const.Items.WeaponType.Crossbow)) return true;
		if (weapon.isWeaponType(::Const.Items.WeaponType.Firearm)) return true;

		return false;
	}
});
