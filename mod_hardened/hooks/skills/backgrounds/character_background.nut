::Hardened.HooksMod.hook("scripts/skills/backgrounds/character_background", function(q) {
	// Public
	q.m.CostMultPerVeteranLevel = 1.015;	// Vanilla: 1.03
	q.m.HD_HitpointModifier <- 5;	// All backgrounds grant this much additional Hitpoints

	// Private
	q.m.HD_PerkGroupsBoughtFlag <- "HD_perkGroupsBought";

	q.create = @(__original) function()
	{
		__original();

		// Reforged uses this table for generating background ranges and predictions, so we adjust it too
		this.m.BaseAttributes.Hitpoints[0] += this.m.HD_HitpointModifier;
		this.m.BaseAttributes.Hitpoints[1] += this.m.HD_HitpointModifier;
	}

	q.buildAttributes = @(__original) function()
	{
		__original();

		// Feat: all player characters now have +5 Hitpoints at all times
		// This is a global balance change that goes hand-in-hand with all low-tier injuries being easier to inflict (see character_injuries)
		this.getContainer().getActor().getBaseProperties().Hitpoints += this.m.HD_HitpointModifier;
	}
});

::Hardened.HooksMod.hookTree("scripts/skills/backgrounds/character_background", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		local perkGroupsBought = this.getContainer().getActor().getFlags().getAsInt(this.m.HD_PerkGroupsBoughtFlag);
		if (perkGroupsBought > 0)
		{
			ret.push({
				id = 50,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "Perk Groups bought: " + perkGroupsBought + "/" + ::Hardened.Const.TrainablePGCAmount,
			});
		}

		return ret;
	}}.getTooltip;
})
