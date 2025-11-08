::Hardened.HooksMod.hook("scripts/skills/actives/hand_to_hand", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 3;		// Vanilla: 4

		// Hardened Values
		this.m.HD_IsSortedBeforeMainhand = true;
	}

	q.isUsable = @(__original) function()
	{
		return __original() || this.__usesEmptyThrowingWeapon();
	}

	q.isHidden = @(__original) function()
	{
		return __original() && !this.__usesEmptyThrowingWeapon();
	}

// New Functions
	q.__usesEmptyThrowingWeapon <- function()
	{
		local mainhand = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		return (mainhand != null && mainhand.isWeaponType(::Const.Items.WeaponType.Throwing) && mainhand.getAmmo() == 0 && mainhand.getAmmoMax() != 0);
	}
});
