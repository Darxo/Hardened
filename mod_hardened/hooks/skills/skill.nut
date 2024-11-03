::Hardened.HooksMod.hook("scripts/skills/skill", function(q) {
	q.isDuelistValid = @() function()
	{
		local mainhandItem = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (::MSU.isNull(mainhandItem)) return false;
		if (!mainhandItem.isItemType(::Const.Items.ItemType.OneHanded)) return false;

		return true;
	}

	q.getHitFactors = @(__original) function( _targetTile )
	{
		local ret = __original(_targetTile);

		// New Entries
		if (_targetTile.IsOccupiedByActor)
		{
			local target = _targetTile.getEntity();
			local properties = this.m.Container.buildPropertiesForUse(this, target);

			// Headshot chance
			if (this.isAttack())
			{
				local headshotChance = properties.getHeadHitchance(::Const.BodyPart.Head, this.getContainer().getActor(), this, target);
				ret.insert(0, {
					icon = "ui/icons/chance_to_hit_head.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(headshotChance, {AddPercent = true}) + " headshot chance"),
				});
			}
		}

		return ret;
	}
});
