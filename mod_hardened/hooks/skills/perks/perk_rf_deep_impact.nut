::Hardened.wipeClass("scripts/skills/perks/perk_rf_deep_impact");

// Our Implementation is not perfect. It can't deal with any delayed skills like Ranged Attacks or Lunge/Charge like abilities
// However we can deal with proxy-activations where one skill activates another one within it, if those happen instantly with no delay of course
::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_deep_impact", function(q) {
	// Public
	q.m.DamagePctPerActionPoint <- 0.1;
	q.m.OneHandedMultiplier <- 2.0;		// One Handed weapons gain this much more damage

	// Private
	q.m.CurrentDamageMult <- 1.0;	// Damage bonus so its preserved throughout multiple skill uses
	q.m.FullForcedInitiatorSkill <- null;	// Reference of the last FullForcedSkill while we are still within that skills execution

	q.create <- function()
	{
		this.m.ID = "perk.rf_deep_impact";
		this.m.Name = ::Const.Strings.PerkName.RF_DeepImpact;
		this.m.Description = ::Const.Strings.PerkDescription.RF_DeepImpact;
		this.m.Icon = "ui/perks/perk_rf_deep_impact.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	q.onAdded <- function()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon != null) this.onEquip(weapon);
	}

	q.onEquip <- function( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Weapon) && _item.isWeaponType(::Const.Items.WeaponType.Hammer))
		{
			_item.addSkill(::new("scripts/skills/actives/rf_pummel_skill"));
		}
	}

	q.onUpdate <- function( _properties )
	{
		foreach (skill in this.getContainer().m.Skills)
		{
			if (skill.getID() == "actives.shatter")
			{
				skill.m.KnockbackChance = 100;
			}
		}
	}
});
