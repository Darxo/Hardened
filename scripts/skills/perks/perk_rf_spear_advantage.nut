this.perk_rf_spear_advantage <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.rf_spear_advantage";
		this.m.Name = ::Const.Strings.PerkName.RF_SpearAdvantage;
		this.m.Description = "This character is using his spear to great effect, manifesting his advantage in combat.";
		this.m.Icon = "ui/perks/rf_spear_advantage.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isDisarmed()) return false;

		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null || !weapon.isItemType(::Const.Items.ItemType.MeleeWeapon) || !weapon.isWeaponType(::Const.Items.WeaponType.Spear)) return false;

		_properties.ReachMult += (::Reforged.Reach.ReachAdvantageMult - 1.0);
	}
});
