this.hd_hexe_racial <- this.inherit("scripts/skills/skill", {
	m = {
		NegativeStatusEffectDurationModifier = 1,
	},

	function create()
	{
		this.m.ID = "racial.HD_hexe";
		this.m.Name = "Hexe";
		this.m.Icon = "ui/orientation/hexe_01_orientation.png";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.NegativeStatusEffectDurationModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Negative status effect with a finite duration last " + ::MSU.Text.colorizeValue(this.m.NegativeStatusEffectDurationModifier, {AddSign = true, InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Turn|Concept.Turn]"),
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.NegativeStatusEffectDuration += this.m.NegativeStatusEffectDurationModifier;
	}
});
