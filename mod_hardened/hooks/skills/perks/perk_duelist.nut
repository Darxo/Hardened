::Hardened.wipeClass("scripts/skills/perks/perk_duelist");

::Hardened.HooksMod.hook("scripts/skills/perks/perk_duelist", function(q) {
	// Private
	q.m.ArmorPenetrationModifierFull <- 0.30;	// This modifier is added while 0 or 1 enemies are adjacent
	q.m.ArmorPenetrationModifierHalf <- 0.15;	// This modifier is added to Armor Penetration while 2 enemies are adjacent
	q.m.ReachModifierFull <- 2;					// This modifier is added to Reach while 0 or 1 enemies are adjacent
	q.m.ReachModifierHalf <- 1;					// This modifier is added to Reach  while 2 enemies are adjacent

	q.create <- function()
	{
		this.m.ID = "perk.duelist";
		this.m.Name = ::Const.Strings.PerkName.Duelist;
		this.m.Description = ::Const.Strings.PerkDescription.Duelist;
		this.m.Icon = "skills/passive_03.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	q.onUpdate <- function( _properties )	// This will maybe cause issues with Lunge.
	{
		local mainhandItem = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (mainhandItem == null) return;
		if (mainhandItem.isItemType(::Const.Items.ItemType.OneHanded) == false) return;

		_properties.DamageDirectAdd += this.getArmorPenetrationModifier();
		_properties.Reach += this.getReachModifier();
	}

// New Functions
	q.getArmorPenetrationModifier <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return this.m.ArmorPenetrationModifierFull;

		local numAdjacentEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true).len();
		if (numAdjacentEnemies <= 1) return this.m.ArmorPenetrationModifierFull;
		if (numAdjacentEnemies == 2) return this.m.ArmorPenetrationModifierHalf;
		return 0;
	}

	q.getReachModifier <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return this.m.ReachModifierFull;

		local numAdjacentEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true).len();
		if (numAdjacentEnemies <= 1) return this.m.ReachModifierFull;
		if (numAdjacentEnemies == 2) return this.m.ReachModifierHalf;
		return 0;
	}
});
