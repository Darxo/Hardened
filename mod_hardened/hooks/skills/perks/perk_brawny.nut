::Hardened.HooksMod.hook("scripts/skills/perks/perk_brawny", function(q) {
	q.onCombatStarted = @(__original) function()
	{
		__original();
		local actor = this.getContainer().getActor();
		if (actor.getFaction() != ::Const.Faction.Player)
		{
			local fat = actor.getItems().getStaminaModifier([::Const.ItemSlot.Body, ::Const.ItemSlot.Head]);
			actor.m.BaseProperties.Stamina -= ::Math.floor(fat * 0.3);
			this.removeSelf();
		}
	}
});

::Hardened.HooksMod.hook("scripts/skills/perks/perk_fortified_mind", function(q) {
	q.onCombatStarted = @(__original) function()
	{
		__original();
		local actor = this.getContainer().getActor();
		if (actor.getFaction() != ::Const.Faction.Player)
		{
			actor.m.BaseProperties.BraveryMult *= 1.25;
			this.removeSelf();
		}
	}
});

::Hardened.HooksMod.hook("scripts/skills/perks/perk_colossus", function(q) {
	q.onCombatStarted = @(__original) function()
	{
		__original();
		local actor = this.getContainer().getActor();
		if (actor.getFaction() != ::Const.Faction.Player)
		{
			actor.m.BaseProperties.HitpointsMult *= 1.25;
			this.removeSelf();
		}
	}
});

