::Hardened.HooksMod.hook("scripts/skills/actives/recover_skill", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (!this.getContainer().hasSkill("perk.relentless"))
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Gain the [Waiting|Skill+hd_wait_effect] effect"),
			});
		}

		return ret;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);
		if (ret)
		{
			this.getContainer().add(::new("scripts/skills/effects/hd_wait_effect"));	// This will remove itself if it detects the presence of Relentless
		}
		return ret;
	}
});
