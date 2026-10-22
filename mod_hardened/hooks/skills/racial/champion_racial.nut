::Hardened.HooksMod.hook("scripts/skills/racial/champion_racial", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		// Feat: Display base troop name in champion racial tooltip
		ret.extend([
			{
				id = 80,
				type = "hint",
				icon = "ui/orientation/" + ::Const.EntityIcon[this.getContainer().getActor().m.Type] + ".png",
				text = "Base Troop: " + ::Const.Strings.EntityName[this.getContainer().getActor().m.Type],
			},
		]);

		return ret;
	}}.getTooltip;
});
