this.hd_reload_disorientation_effect <- ::inherit("scripts/skills/skill", {
	m = {
		RangedSkillModifier = -10,
		RangedDefenseModifier = -10
	},
	function create()
	{
		this.m.ID = "effects.hd_reload_disorientation";
		this.m.Name = "Reload Disorientation";
		this.m.Description = "This character focussed on the lengthy process of reloading their weapon ignoring anything else going on in the distance. This effect lasts until the start of their next turn.";
		this.m.Icon = "skills/rf_reload_disorientation_effect.png";
		this.m.IconMini = "rf_reload_disorientation_effect_mini";	// Todo, add mini icon for better visibility
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsStacking = false;		// This debuff does not stack
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();

		tooltip.push({
			id = 10,
			type = "text",
			icon = "ui/icons/ranged_skill.png",
			text = ::MSU.Text.colorizeValue(this.m.RangedSkillModifier) + " Ranged Defense"
		});

		tooltip.push({
			id = 11,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = ::MSU.Text.colorizeValue(this.m.RangedDefenseModifier) + " Ranged Defense"
		});

		return tooltip;
	}

	function onUpdate( _properties )
	{
		_properties.RangedSkill += this.m.RangedSkillModifier;
		_properties.RangedDefense += this.m.RangedDefenseModifier;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}
});
