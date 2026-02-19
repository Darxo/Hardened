this.hd_wait_effect <- this.inherit("scripts/skills/skill", {
	m = {
		InitiativeMultiplier = ::Const.Combat.InitiativeAfterWaitMult	// This is 0.75 in vanilla
	},

	function create()
	{
		this.m.ID = "effects.hd_wait";
		this.m.Name = "Waiting";
		this.m.Icon = "ui/traits/trait_icon_25.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.InitiativeMultiplier) + " [Initiative|Concept.Initiative]"),
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your [turn|Concept.Turn]"),
		});

		return ret;
	}

	function onAdded()
	{
		if (this.getContainer().hasSkill("perk.relentless"))
		{
			this.removeSelf();
		}
	}

	function onUpdate( _properties )
	{
		_properties.InitiativeMult *= 0.75;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

});
