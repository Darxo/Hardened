::Hardened.HooksMod.hook("scripts/ambitions/ambitions/allied_nobles_ambition", function(q) {
	q.onReward = @(__original) function()
	{
		__original();

		// We do the same thing as vanilla for finding out the faction type for the equipment
		local banner = 1;
		foreach (ally in ::World.FactionManager.getAlliedFactions(::Const.Faction.Player))
		{
			local faction = ::World.FactionManager.getFaction(ally);
			if (faction != null && faction.getType() == ::Const.FactionType.NobleHouse && faction.getPlayerRelation() >= 90.0)
			{
				banner = faction.getBanner();
				break;
			}
		}

		// Feat: The Allied Noble ambition now also rewards a heraldic cape upgrade
		local item = ::new("scripts/items/armor_upgrades/rf_heraldic_cape_upgrade");
		item.setVariant(banner);
		::World.Assets.getStash().add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "You gain " + ::Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}
});
