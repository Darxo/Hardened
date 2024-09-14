::Hardened.HooksMod.hook("scripts/skills/special/double_grip", function(q) {
	q.m.HD_DamageMult <- 1.2;
	q.m.HD_NonAttackFatigueMult <- 0.8;

	q.create = @(__original) function()
	{
		__original();
		this.m.IconMini = "";
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
	}

	// Overwrite vanilla function to replace its hard-coded effect
	q.onUpdate = @() function( _properties )
	{
		if (this.canDoubleGrip())
		{
			_properties.MeleeDamageMult *= this.m.HD_DamageMult;
		}
	}

// Private Vanilla Functions
	q.canDoubleGrip = @(__original) function()
	{
		if (this.getContainer().getActor().isDisarmed())
		{
			return false;
		}

		return __original();
	}

});
