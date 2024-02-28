::Hardened.HooksMod.hook("scripts/skills/perks/perk_fortified_mind", function(q) {
	q.m.BaseResolveMult <- 1.3;
	q.m.ResolveModifierPerWeight <- -0.01;

	q.onUpdate = @() function( _properties )
	{
		local helmetWeight = ::Math.max(0, this.getContainer().getActor().getItems().getStaminaModifier([::Const.ItemSlot.Head]) * -1);
		local resolveMult = ::Math.maxf(1.0, this.m.BaseResolveMult + (this.m.ResolveModifierPerWeight * helmetWeight));
		_properties.BraveryMult *= resolveMult;
	}
});
