::Hardened.HooksMod.hook("scripts/skills/perks/perk_duelist", function(q) {
	q.m.DamageDirectAddBonus <- 0.3;
	q.m.ReachBonus <- 2;

	q.onUpdate = @() function( _properties )	// This will maybe cause issues with Lunge.
	{
		local mainhandItem = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (mainhandItem == null) return;
		if (mainhandItem.isItemType(::Const.Items.ItemType.OneHanded) == false) return;

		local multiplier = this.getBonusMultiplier();
		_properties.DamageDirectAdd += (this.m.DamageDirectAddBonus * multiplier);
		_properties.Reach += (this.m.ReachBonus * multiplier);
	}

// New Functions
	q.getBonusMultiplier <- function()
	{
		if (!this.getContainer().getActor().isPlacedOnMap()) return 1.0;	// Outside of battle this is treated as being fully active
		local numAdjacentEnemies = ::Tactical.Entities.getHostileActors(this.getContainer().getActor().getFaction(), this.getContainer().getActor().getTile(), 1, true).len();
		if (numAdjacentEnemies == 0) return 1.0;	// Maybe not allow this?
		if (numAdjacentEnemies == 1) return 1.0;
		if (numAdjacentEnemies == 2) return 0.5;
		return 0.0;
	}

	if (q.contains("onAnySkillUsed")) delete q.onAnySkillUsed;
	if (q.contains("onBeingAttacked")) delete q.onBeingAttacked;
});
