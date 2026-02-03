::Hardened.HooksMod.hook("scripts/skills/backgrounds/character_background", function(q) {
	// Public
	q.m.CostMultPerVeteranLevel = 1.015;	// Vanilla: 1.03

	// Private
	q.m.HD_PerkGroupsBoughtFlag <- "HD_perkGroupsBought";
})

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
