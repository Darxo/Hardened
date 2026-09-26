this.perk_hd_judgement <- ::inherit("scripts/skills/skill", {
	m = {
		HD_HitChanceModifier = 10,
	},
	function create()
	{
		this.m.ID = "perk.hd_judgement";
		this.m.Name = ::Const.Strings.PerkName.HD_Judgement;
		this.m.Icon = "ui/perks/perk_hd_judgement.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.HD_isSkillValid(_skill) && this.HD_isTargetValid(_targetEntity))
		{
			_properties.MeleeSkill += this.HD_getHitchanceModifier();
			_properties.RangedSkill += this.HD_getHitchanceModifier();
		}
	}

// MSU Functions
	function onGetHitFactors( _skill, _targetTile, _tooltip )
	{
		if (!this.HD_isSkillValid(_skill)) return;
		if (!_targetTile.IsOccupiedByActor) return;
		if (!this.HD_isTargetValid(_targetTile.getEntity())) return;

		_tooltip.push({
			icon = "ui/tooltips/positive.png",
			text = ::MSU.Text.colorPositive((this.HD_getHitchanceModifier()) + "% ") + ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedPerkName(this)),
		});
	}

// New Functions
	function HD_getHitchanceModifier()
	{
		return this.m.HD_HitChanceModifier;
	}

	function HD_isSkillValid( _skill )
	{
		return _skill.isAttack();
	}

	function HD_isTargetValid( _targetEntity )
	{
		return _targetEntity.isTurnStarted();
	}
});
