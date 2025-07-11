::Hardened.HooksMod.hook("scripts/items/armor/tattered_sackcloth", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 0;			// In Vanilla this is 0
		this.m.ConditionMax = 10; 		// In Vanilla this is 5
		this.m.StaminaModifier = -4; 	// In Vanilla this is 0
	}

	q.updateVariant = @(__original) function()
	{
		__original();
		// In order to make this armor more different from the other better sackcloth variants, we choose to always display it in its damaged sprite form
		this.m.Sprite = this.m.SpriteDamaged;
	}
});
