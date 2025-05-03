this.hd_reload_disorientation_effect <- ::inherit("scripts/skills/skill", {
	m = {
		RangedSkillModifier = -15,
		RangedDefenseMult = 0.65,
	},
	function create()
	{
		this.m.ID = "effects.hd_reload_disorientation";
		this.m.Name = "Reload Disorientation";
		this.m.Description = "This character focussed on the lengthy process of reloading their weapon ignoring anything else going on in the distance.";
		this.m.Icon = "skills/hd_reload_disorientation_effect.png";
		this.m.IconMini = "hd_reload_disorientation_effect_mini";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.RangedSkillModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.RangedSkillModifier, {AddSign = true}) + " [Ranged Skill|Concept.RangeSkill]"),
			});
		}

		if (this.m.RangedDefenseMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.RangedDefenseMult) + " [Ranged Defense|Concept.RangeDefense]"),
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your [turn|Concept.Turn]"),
		});

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.RangedSkill += this.m.RangedSkillModifier;
		_properties.RangedDefenseMult *= this.m.RangedDefenseMult;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

// Modular Vanilla Functions
	function getQueryTargetValueMult( _user, _target, _skill )
	{
		if (_user.getID() == this.getContainer().getActor().getID() && _user.getID() != _target.getID())	// We must be the _user
		{
			if (_skill == null) return ret;
			if (_skill.isAttack() && _skill.isRanged())
			{
				return 0.7;	// _user should wait out reload disorientation, instead of shooting right away
			}
		}

		return 1.0;
	}
});
