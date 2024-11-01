this.hd_non_combatant_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.hd_non_combatant";
		this.m.Name = "Non-Combatant";
		this.m.Description = "This character does not directly partake in the battle.";
		this.m.Icon = "skills/donkey_orientation.png";	// Same as the orientation icon used in vanilla for donkeys
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
			icon = "ui/icons/special.png",
			text = "This character does not need to be killed in order to win",
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Does not count for [surrounding|Concept.Surrounding]"),
		});

		return ret;
	}

	function onAdded()
	{
		this.getContainer().getActor().m.GrantsXPOnDeath = false;
	}
});
