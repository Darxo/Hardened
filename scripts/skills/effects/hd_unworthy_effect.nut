this.hd_unworthy_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.hd_unworthy_opponent";
		this.m.Name = "Unworthy";
		this.m.Description = "This character is unworthy.";
		this.m.Icon = "ui/traits/trait_icon_17.png";	// Vanilla icon for the trait Dumb
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
			icon = "ui/icons/xp_received.png",
			text = "This characters grants no experience on death",
		});

		return ret;
	}

	function onAdded()
	{
		this.getContainer().getActor().m.GrantsXPOnDeath = false;
	}
});
