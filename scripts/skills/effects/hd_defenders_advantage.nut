// This special effect is meant to be given to all defender of a fortified camp, to make them more capable and smarter while defending
this.hd_defenders_advantage <- this.inherit("scripts/skills/skill", {
	m = {
		VisionModifier = 2,
		BraveryModifier = 10,
	},

	function create()
	{
		this.m.ID = "effects.hd_defenders_advantage";
		this.m.Name = "Defenders Advantage";
		this.m.Description = "You are defending a place that you know in and out."
		this.m.Icon = "ui/orientation/palisade_01_orientation.png";		// Same icon as "This location has fortifications"
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.VisionModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/vision.png",
				text = ::MSU.Text.colorizeValue(this.m.VisionModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Vision|Concept.SightDistance]"),
			});
		}

		if (this.m.BraveryModifier != 0)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::MSU.Text.colorizeValue(this.m.BraveryModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery]"),
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Vision += this.m.VisionModifier;
		_properties.Bravery += this.m.BraveryModifier;
	}
});
