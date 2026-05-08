::Hardened.HooksMod.hook("scripts/skills/actives/swallow_whole_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttack = false;	// Vanilla: true; We turn this off as it otherwise synergises with various perks
		this.m.IsUsingHitchance = false;	// Vanilla: true
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local actor = this.getContainer().getActor();
		if (actor.getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because you are [rooted|Concept.Rooted]"),
			});
		}
		else
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used while [rooted|Concept.Rooted]"),
			});
		}

		return ret;
	}


	q.isUsable = @(__original) function()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			return false;
		}

		return __original();
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		// This skill is no longer an attack, so we need to manually make sure you can't use it on allies
		if (ret && this.getContainer().getActor().isAlliedWith(_targetTile.getEntity())) ret = false;

		return ret;
	}
});
