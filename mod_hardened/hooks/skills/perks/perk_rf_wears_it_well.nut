::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_wears_it_well", function(q) {
	q.m.WeightMult <- 0.2;

	q.onUpdate = @() function( _properties )
	{
		local weight = this.getContainer().getActor().getItems().getWeight([::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand]);
		_properties.Stamina += weight * this.m.WeightMult;
	}
});
