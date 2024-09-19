::Hardened.wipeClass("scripts/skills/perks/perk_rf_king_of_all_weapons");

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_king_of_all_weapons", function(q) {
	q.m.HD_DamageTotalMult <- 0.9;
	q.m.HD_FatigueCostMult <- 0.0;

	q.create <- function()
	{
		this.m.ID = "perk.rf_king_of_all_weapons";
		this.m.Name = ::Const.Strings.PerkName.RF_KingOfAllWeapons;
		this.m.Description = "This character is exceptionally skilled with the spear, which is known by many to be the king of all weapons.";
		this.m.Icon = "ui/perks/perk_rf_king_of_all_weapons.png";
		this.m.IconMini = "perk_rf_king_of_all_weapons_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.VeryLast;
	}

	q.onAdded <- function()
	{
		// Quick and Dirty way to balance out enemies getting King of all Weapons, because that perk
		if (!this.getContainer().getActor().isPlayerControlled())
		{
			this.getContainer().getActor().getSkills().add(::new("scripts/skills/perks/perk_rf_double_strike"));
		}
	}

	q.onUpdate <- function( _properties )
	{
		local actor = this.getContainer().getActor();
		local mainhand = actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (mainhand != null && mainhand.isWeaponType(::Const.Items.WeaponType.Spear) && !actor.isDisarmed())
		{
			_properties.DamageTotalMult *= this.m.HD_DamageTotalMult;
		}
	}

	q.onAfterUpdate <- function( _properties )
	{
		// Reduce fatigue cost of all spear attacks
		foreach (skill in this.getContainer().m.Skills)
		{
			if (!skill.isGarbage() && this.isSkillValid(skill))
			{
				skill.m.FatigueCostMult *= this.m.HD_FatigueCostMult;
			}
		}
	}

// New Function
	q.isSkillValid <- function( _skill )
	{
		if (_skill.isRanged() || !_skill.isAttack())
		{
			return false;
		}

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Spear);
	}
});
