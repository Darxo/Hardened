::Hardened.HooksMod.hookTree("scripts/skills/backgrounds/character_background", function(q) {
	// Private
	q.m.HD_PerkGroupsBoughtFlag <- "HD_perkGroupsBought";

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
