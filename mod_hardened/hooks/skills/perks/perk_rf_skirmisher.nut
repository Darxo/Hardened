::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_skirmisher", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.IsHidden = true;
	}

	q.getInitiativeBonus = @() function()
	{
		return ::Math.floor(this.getContainer().getActor().getItems().getWeight([::Const.ItemSlot.Body]) * 0.5);
	}
});
