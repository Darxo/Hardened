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
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push(
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::MSU.Text.colorNegative((this.m.InitiativeMultiplier * 100.0) - 100 + "%") + " Initiative"
			}
		)
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
