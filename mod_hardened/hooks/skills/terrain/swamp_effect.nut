::Const.Tactical.TerrainEffectTooltip[::Const.Tactical.TerrainType.Swamp] = [
	{
		id = 5,
		type = "text",
		icon = "/ui/icons/melee_defense.png",
		text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(0.75) + " [Melee Defense|Concept.MeleeDefense]"),
	},
	{
		id = 6,
		type = "text",
		icon = "/ui/icons/ranged_defense.png",
		text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(0.75) + " [Ranged Defense|Concept.RangeDefense]"),
	},
	{
		id = 12,
		type = "text",
		icon = "/ui/icons/initiative.png",
		text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(0.75) + " [Initiative|Concept.Initiative]"),
	},
];

::Hardened.HooksMod.hook("scripts/skills/terrain/swamp_effect", function(q) {
	q.m.InitiativeMult <- 0.75;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10 && entry.icon == "/ui/icons/melee_skill.png")
			{
				entry.icon = "ui/icons/initiative.png";
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.InitiativeMult) + " [Initiative|Concept.Initiative]");
				break;
			}
		}

		return ret;
	}

	// Revert any changes done to MeleeSkillMult
	q.onUpdate = @(__original) function(_properties)
	{
		local oldMeleeSkillMult = _properties.MeleeSkillMult;
		__original(_properties);
		_properties.MeleeSkillMult = oldMeleeSkillMult;

		_properties.InitiativeMult *= this.m.InitiativeMult;
	}
});
