::Hardened.HooksMod.hook("scripts/skills/special/double_grip", function(q) {
	// Public
	q.m.HD_DamageMult <- 1.2;
	q.m.HD_NonAttackFatigueMult <- 0.8;

	// When true, double grip will always be active
	// Will always be set to false, after this skills onAfterUpdate has been called
	// Can be set to true by any skills onUpdate function which a SkillOrder below Any
	q.m.HD_ForceActive <- false;

	// Private
	q.m.IsInEffect <- false;	// Helper variable to decide, whether this skill should be visible. This is needed to support 'HD_ForceActive' functionality

	q.create = @(__original) function()
	{
		__original();
		this.m.IconMini = "";	// For clarity during battles this perk no longer displays a mini icon
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/regular_damage.png")
			{
				entry.text = "Deal " + ::MSU.Text.colorizeMultWithText(this.m.HD_DamageMult) + " damage";
				break;
			}
		}

		if (this.m.HD_NonAttackFatigueMult != 1.0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("Non-attack skills cost " + ::MSU.Text.colorizeMultWithText(this.m.HD_NonAttackFatigueMult, {InvertColor = true}) + " [Fatigue|Concept.Fatigue]"),
			});
		}

		return ret;
	}

	// Overwrite because we don't want to directly check for canDoubleGrip
	q.isHidden = @() function()
	{
		return this.skill.isHidden() || !this.m.IsInEffect;
	}

	// Overwrite vanilla function to replace its hard-coded effect
	q.onUpdate = @() function( _properties )
	{
		this.m.IsInEffect = false;
		if (this.canDoubleGrip())
		{
			_properties.MeleeDamageMult *= this.m.HD_DamageMult;
			this.m.IsInEffect = true;
		}
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		if (this.canDoubleGrip())
		{
			foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
			{
				if (!skill.isAttack())
				{
					skill.m.FatigueCostMult *= this.m.HD_NonAttackFatigueMult;
				}
			}
		}
		this.m.HD_ForceActive = false;
	}

// Private Vanilla Functions
	q.canDoubleGrip = @(__original) function()
	{
		local actor = this.getContainer().getActor();
		if (actor.isDisarmed())
		{
			return false;
		}

		if (this.m.HD_ForceActive)
		{
			return true;
		}

		return __original();
	}

});
