// This skill is just a dummy shell to showcase the effect. It is actually implemented in actor.nut hook of RF_canDropLootForPlayer
this.hd_worthless_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.hd_worthless";
		this.m.Name = "Unworthy";
		this.m.Description = "This character is worthless.";
		this.m.Icon = "ui/backgrounds/background_18.png";	// Vanilla icon for the begger background
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bag.png",
			text = "Drop no items on death",
		});

		return ret;
	}
});
