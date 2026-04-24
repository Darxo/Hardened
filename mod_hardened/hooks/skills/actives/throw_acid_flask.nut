::Hardened.HooksMod.hook("scripts/skills/actives/throw_acid_flask", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttack = false;	// This skill is no longer considered an attack. This flag didn't make sense in vanilla anyways
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " tiles",
		});

		return ret;
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		// Now that this skill is no longer considered an attack, we need to manually exclude allies
		return __original(_originTile, _targetTile) && !this.getContainer().getActor().isAlliedWith(_targetTile.getEntity());
	}
});

