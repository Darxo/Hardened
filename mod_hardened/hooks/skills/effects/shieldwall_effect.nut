::Hardened.HooksMod.hook("scripts/skills/effects/shieldwall_effect", function(q) {
	q.getTooltip = @(__original) function()
	{
		if (this.getContainer().getActor().getID() ==  ::MSU.getDummyPlayer().getID())
		{
			return this.skill.getTooltip();		// This tooltip is more resilient against a shield missing
		}
		else
		{
			return __original();
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// In Vanilla shieldwall_effect will be removed, whenever shieldwall (skill) is removed. But in Hardened someone without shieldwall (skill) can gain that effect
		// This effect would not be removed when they switch away from the shield, causing glitches. So now we implement a check, that vanilla should have implemented themselves
		local item = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
		if (item == null || !item.isItemType(::Const.Items.ItemType.Shield))
		{
			this.removeSelf();
		}
		else
		{
			__original(_properties);
		}
	}
});
