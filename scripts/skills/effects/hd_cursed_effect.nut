this.hd_cursed_effect <- ::inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "effects.hd_cursed";
		this.m.Name = "Cursed";
		this.m.Description = "Bound by a dark curse, this character cannot find true rest in death.";
		this.m.Icon = "skills/status_effect_07.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
	}

	function onAdded()
	{
		this.getContainer().getActor().m.IsResurrectingOnFatality = true;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();

		tooltip.push({
			id = 10,
			type = "text",
			icon = "ui/icons/chance_to_hit_head.png",
			text = ::Reforged.Mod.Tooltips.parseString("Can resurrect even after a receiving a [Fatality|Concept.Fatality]"),
		});

		return tooltip;
	}
});
