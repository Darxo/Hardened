::Hardened.HooksMod.hook("scripts/skills/actives/explode_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();

		this.m.Name = "Self Destruct";	// Vanilla: Explode
		this.m.Description = "Initiate your own demise.";	// Reforged: Explode into a shrapnel of bone damaging everyone next to you.
		this.m.IsAttack = false;
	}}.create;

	// Overwrite, because
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Kill yourself"),
		});

		local actor = this.getContainer().getActor();
		local hasAdjacentEnemy = false;
		foreach (nextTile in ::MSU.Tile.getNeighbors(actor.getTile()))
		{
			if (!nextTile.IsOccupiedByActor) continue;
			if (::Math.abs(actor.getTile().Level - nextTile.Level) > 1) continue;

			local target = nextTile.getEntity();
			if (!target.isAlive()) continue;
			if (target.isAlliedWith(actor)) continue;

			hasAdjacentEnemy = true;
			break;
		}

		if (hasAdjacentEnemy)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = ::Reforged.Mod.Tooltips.parseString("Requires an adjacent enemy"),
			});
		}
		else
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used, because you have no adjacent enemy"),
			});
		}

		return ret;
	}}.getTooltip;

	// Overwrite, because we remove the vanilla combat log and we pass our actor and this skill into the kill function
	q.onUse = @() { function onUse( _user, _targetTile )
	{
		::Time.scheduleEvent(::TimeUnit.Virtual, 300, function ( _data )
		{
			_user.kill(_data.User, _data.Skill);
		}, { User = _user, Skill = this });
		return true;
	}}.onUse;
});
