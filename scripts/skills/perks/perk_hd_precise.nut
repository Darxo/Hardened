this.perk_hd_precise <- ::inherit("scripts/skills/skill", {
	m = {
		HD_HitChanceModifier = 5,
		HD_HitChanceMaxModifier = 5,
	},
	function create()
	{
		this.m.ID = "perk.hd_precise";
		this.m.Name = ::Const.Strings.PerkName.HD_Versatile;
		this.m.Icon = "ui/perks/perk_rf_swordmaster_versatile_swordsman.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += this.m.HD_HitChanceModifier;
		_properties.RangedSkill += this.m.HD_HitChanceModifier;
		_properties.HD_HitChanceMax += this.m.HD_HitChanceMaxModifier;
	}
});
