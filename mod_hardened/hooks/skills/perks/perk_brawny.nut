::mods_hookExactClass("skills/perks/perk_brawny", function (o) {

	o.onCombatStarted <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getFaction() != ::Const.Faction.Player)
		{
			local fat = actor.getItems().getStaminaModifier([::Const.ItemSlot.Body, ::Const.ItemSlot.Head]);
			actor.m.BaseProperties.Stamina -= ::Math.floor(fat * 0.3);
			this.removeSelf();
		}
	}
});

::mods_hookExactClass("skills/perks/perk_fortified_mind", function (o) {

	o.onCombatStarted <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getFaction() != ::Const.Faction.Player)
		{
			actor.m.BaseProperties.Bravery += ::Math.floor(actor.m.BaseProperties.Bravery * 0.25);
			this.removeSelf();
		}
	}
});
