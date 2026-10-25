this.perk_hd_drum_mastery <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		RadiusModifier = 3,
		AdditionalFatigueReceovery = 5,
	},
	function create()
	{
		this.m.ID = "perk.hd_drum_mastery";
		this.m.Name = ::Const.Strings.PerkName.HD_DrumMastery;
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function onAfterUpdate( _properties )
	{
		local drumsOfWar = this.getContainer().getSkillByID("actives.drums_of_war");
		if (drumsOfWar != null)
		{
			drumsOfWar.m.HD_Radius += this.m.RadiusModifier;
			drumsOfWar.m.HD_AdditionalFatigueReceovery += this.m.AdditionalFatigueReceovery;
			drumsOfWar.m.HD_RemoveDazed = true;
		}
	}
});
