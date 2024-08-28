::Hardened.wipeClass("scripts/skills/perks/perk_rf_whirling_death");

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_whirling_death", function(q) {
	q.create <- function()
	{
		this.m.ID = "perk.rf_whirling_death";
		this.m.Name = ::Const.Strings.PerkName.RF_WhirlingDeath;
		this.m.Description = "This character\'s attacks are like a whirlwind, making it very dangerous to be near them.";
		this.m.Icon = "ui/perks/perk_rf_whirling_death.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	q.onAdded <- function()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon != null) this.onEquip(weapon);
	}

// MSU Functions
	q.onEquip <- function( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Weapon) && _item.isWeaponType(::Const.Items.WeaponType.Flail))
		{
			_item.addSkill(::new("scripts/skills/actives/hd_whirling_death_skill"));
		}
	}
});
