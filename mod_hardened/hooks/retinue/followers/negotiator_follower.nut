::Hardened.HooksMod.hook("scripts/retinue/followers/negotiator_follower", function(q) {
	q.onUpdate = @(__original) function()
	{
		// We prevent Vanilla from adjusting the RelationDecayGoodMult
		local oldRelationDecayBadMult = this.World.Assets.m.RelationDecayBadMult;
		__original();
		this.World.Assets.m.RelationDecayBadMult = oldRelationDecayBadMult;

		this.World.Assets.m.RelationDecayBadMult *= 2.0;	// Vanilla: 1.15
	}
});
