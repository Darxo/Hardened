// This is a 1-1 copy of the reforged "Through the Ranks perk", so that it does not need to be removed from NPCs
this.hd_through_the_ranks <- ::inherit("scripts/skills/skill", {
	m = {
		RangedSkillMult = 0.5,
	},
	function create()
	{
		this.m.ID = "effects.hd_through_the_ranks";
		this.m.Name = "Through the Ranks";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("You have " + ::MSU.Text.colorizeMultWithText(this.m.RangedSkillMult) + " [Ranged Skill|Concept.RangeSkill] against allies.");
		this.m.Icon = "ui/perks/perk_rf_through_the_ranks.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && _skill.isRanged() && _targetEntity != null && _targetEntity.getID() != this.getContainer().getActor().getID() && _targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			_properties.RangedSkillMult *= this.m.RangedSkillMult;
		}
	}
});
