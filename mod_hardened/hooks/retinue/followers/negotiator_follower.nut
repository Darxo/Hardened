::Hardened.HooksMod.hook("scripts/retinue/followers/negotiator_follower", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Effects = [
			"Allows for more rounds of contract negotiations and without any hit to relation",
			"Bad Relations recover 100% faster",
			"Good Relations decay 15% slower",
		];
	}

	q.onUpdate = @(__original) function()
	{
		// We prevent Vanilla from adjusting the RelationDecayGoodMult
		local oldRelationDecayBadMult = this.World.Assets.m.RelationDecayBadMult;
		__original();
		this.World.Assets.m.RelationDecayBadMult = oldRelationDecayBadMult;

		this.World.Assets.m.RelationDecayBadMult *= 2.0;	// Vanilla: 1.15
	}
});
