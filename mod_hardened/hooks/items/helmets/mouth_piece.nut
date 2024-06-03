::Hardened.HooksMod.hook("scripts/items/helmets/mouth_piece", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ID = "armor.head.mouth_piece";	// Vanilla has the name "armor.head.witchhunter_hat" here which is already taken
	}
});
