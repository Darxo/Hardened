::Hardened.HooksMod.hook("scripts/items/armor/decayed_reinforced_mail_hauberk", function(q) {
	q.create = @(__original) function()
	{
		__original();

		if (this.m.Variant == 50)	// This variant looks way too similar to worn_mail_shirt, so we remove it from this armor here
		{
			this.setVariant(::MSU.Array.rand([53, 56, 59]));
		}
	}
});
