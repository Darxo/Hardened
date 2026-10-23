::Hardened.HooksMod.hook("scripts/items/weapons/barbarians/drum_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 400;				// Vanilla: 0
		this.m.ConditionMax = 1;		// Vanilla: 0
		this.m.BlockedSlotType = ::Const.ItemSlot.Offhand;	// Vanilla Fix: Make this item block the offhand slot, like the two-handed weapon it is
		this.m.IsDoubleGrippable = false;	// Vanilla Fix: This is a two-handed weapon so it should never be double-grippable
		this.m.IsDroppedAsLoot = true;		// Feat: Allow this item to be dropped and looted during battle
		this.m.StaminaModifier = -10;	// Vanilla: 0

		this.m.RegularDamage = 0;
		this.m.RegularDamageMax = 0;
		this.m.RangeMax = 0;		// Vanilla: 6
		this.m.RangeIdeal = 5;		// Vanilla: 6
	}
});
