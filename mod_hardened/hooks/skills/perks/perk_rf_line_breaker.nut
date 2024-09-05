::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_line_breaker", function(q) {
	// Overwrite Reforged lose adding of line breaker skill
	q.onAdded = @() function()
	{
		local shield = this.getContainer().getActor().getOffhandItem();
		if (shield != null) this.onEquip(shield);
	}

	q.onEquip = @(__original) function( _item )
	{
		__original(_item);
		if (_item.isItemType(::Const.Items.ItemType.Shield))
		{
			_item.addSkill(::new("scripts/skills/actives/rf_line_breaker_skill"));
		}
	}

	q.onRemoved = @() function() {}		// We no longer need to manually remove the skill
});
