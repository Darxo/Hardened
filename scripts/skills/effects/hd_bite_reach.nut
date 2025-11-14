this.hd_bite_reach <- ::inherit("scripts/skills/skill", {
	m = {
		HeadshotChanceModifier = -10,
		HeadshotReceivedChanceModifier = 10,
	},

	function create()
	{
		this.m.ID = "effects.hd_bite_reach";
		this.m.Name = "Bite Reach";
		this.m.Description = "Your limited size and reliance on head attacks reduces your chance to hit the head.";
		this.m.Icon = "skills/dog_01_orientation.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.isSkillValid(_skill))
		{
			_properties.HitChance[::Const.BodyPart.Head] += this.m.HeadshotChanceModifier;
		}
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (this.isSkillValid(_skill))
		{
			_properties.HeadshotReceivedChance += this.m.HeadshotReceivedChanceModifier;
		}
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.HeadshotChanceModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.HeadshotChanceModifier, {AddPercent = true, AddSign = true}) + " chance to [hit the head|Concept.ChanceToHitHead] with Melee Attacks"),
			});
		}

		if (this.m.HeadshotReceivedChanceModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.HeadshotReceivedChanceModifier, {AddPercent = true, AddSign = true, InvertColor = true}) + " chance to take a [hit to the head|Concept.ChanceToHitHead] from melee attacks"),
			});
		}

		return ret;
	}

// New Functions
	function isSkillValid( _skill )
	{
		return _skill.isAttack() && !_skill.isRanged();
	}
});
