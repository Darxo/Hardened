::Hardened.HooksMod.hook("scripts/items/armor/worn_mail_shirt", function(q) {
	q.m.HD_Variants <- [
		23,		// Vanilla Variant
		50,		// Previously this was used by Vanilla for decayed_reinforced_mail_hauberk, but it was too similar to Variant 23, so we move it here
	];

	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 350;				// In Vanilla this is 400
		this.m.ConditionMax = 110; 		// In Vanilla this is 110; In Reforged this is 105
		this.m.StaminaModifier = -14; 	// In Vanilla this is -12

		// If Variant is not 23, it means that another mod also adds custom variants for Worn Mail Shirts
		if (this.m.Variant == 23 ||::Math.rand(1, 2) == 1)
		{
			this.setVariant(::MSU.Array.rand(this.m.HD_Variants));
		}
	}
});
