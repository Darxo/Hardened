::Hardened.HooksMod.hook("scripts/items/armor/adorned_mail_shirt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1050; // In Reforged this is 800. In Vanilla this is 1050
		this.m.Condition = 150; // In Reforged this is 130. In Vanilla this is 150
		this.m.ConditionMax = 150; // In Reforged this is 130. In Vanilla this is 150
		this.m.StaminaModifier = -16; // In Reforged this is 11. In Vanilla this is 16
	}
});
