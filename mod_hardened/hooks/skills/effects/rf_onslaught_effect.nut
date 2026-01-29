::Hardened.wipeClass("scripts/skills/effects/rf_onslaught_effect", [
	"create",
	"getTooltip",
	"onUpdate",
	"onRoundEnd",
]);

::Hardened.HooksMod.hook("scripts/skills/effects/rf_onslaught_effect", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 12)
			{
				// Adjust line breaker link and remove mention of discount
				entry.text = ::Reforged.Mod.Tooltips.parseString("Gain one use of the [Line Breaker|Skill+hd_onslaught_line_breaker_skill] skill");
				break;
			}
		}

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();
		this.getContainer().add(::new("scripts/skills/actives/hd_onslaught_line_breaker_skill"));
	}

	q.onRemoved = @(__original) function()
	{
		__original();
		this.getContainer().removeByID("actives.hd_onslaught_line_breaker");
	}

	q.onRefresh = @(__original) function()
	{
		__original();
		this.getContainer().add(::new("scripts/skills/actives/hd_onslaught_line_breaker_skill"));
		if (this.m.Overlay != "") this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
	}
});
