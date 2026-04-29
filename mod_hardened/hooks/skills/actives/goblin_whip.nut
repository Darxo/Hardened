::Hardened.HooksMod.hook("scripts/skills/actives/goblin_whip", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local actor = this.getContainer().getActor();
		if (actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because you are [engaged in melee|Concept.ZoneOfControl]"),
			});
		}
		else
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used while [engaged in melee|Concept.ZoneOfControl]"),
			});
		}

		return ret;
	}

	q.isUsable = @(__original) function()
	{
		if (!::Tactical.isActive()) return false;

		// Feat: Goblin Leader can now only whip goblins to confident, while not engaged in melee
		local tile = this.getContainer().getActor().getTile();
		return __original() && !tile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}
});
