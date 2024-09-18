::Hardened.HooksMod.hook("scripts/skills/actives/recover_skill", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Spend your [Wait Action|Concept.Wait]"),
		});

		if (!this.getContainer().hasSkill("perk.relentless"))
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Gain the [Waiting|Skill+hd_wait_effect] debuff"),
			});
		}

		return ret;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		if (__original(_user, _targetTile))
		{
			this.getContainer().getActor().m.IsWaitActionSpent = true;
			this.getContainer().add(::new("scripts/skills/effects/hd_wait_effect"));	// This will remove itself if it detects the presence of Relentless
			return true;
		}
		return false;
	}
});
