::Hardened.HooksMod.hook("scripts/skills/actives/release_falcon_skill", function(q) {
	// Public
	q.m.HD_Radius <- 8;		// Vanilla: 12

	q.create = @(__original) { function create()
	{
		__original();

		this.m.IsTargeted = true;	// Vanilla: false (not targeted)
		this.m.MinRange = 1;
		this.m.MaxRange = 7;	// Vanilla: 1

		this.m.Description = "Release your falcon to gain vision over an area.";
	}}.create;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Target an empty tile. Reveal all tiles within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " of that target until the start of the next round"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of " + ::MSU.Text.colorPositive(this.m.MaxRange) + " tiles",
		});

		if (this.m.Item.isReleased())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Cannot be used, because you already used this skill in this battle",
			});
		}
		else
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = "Can only be used once per battle",
			});
		}

		return ret;
	}

	// Overwrite, because we change how this effect works
	q.onUse = @() function( _user, _targetTile )
	{
		this.m.Item.setReleased(true);

		::Tactical.queryTilesInRange(_targetTile, 1, this.m.HD_Radius, false, [], this.onQueryTile, _user.getFaction());

		if (::Tactical.TurnSequenceBar.getActiveEntity() != null)
		{
			::Tactical.TurnSequenceBar.getActiveEntity().updateVisibilityForFaction();
		}

		return true;
	}
});
