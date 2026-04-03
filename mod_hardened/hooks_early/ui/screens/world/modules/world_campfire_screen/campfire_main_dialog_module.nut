::Hardened.HooksMod.hook("scripts/ui/screens/world/modules/world_campfire_screen/campfire_main_dialog_module", function(q)
{
	// Overwrite, because we can't adjust anything to overwrite the texts in a way that we need
	// We make this function a bit more moddable by extracting functionality into new functions
	q.onCartClicked = @() function()
	{
		if (::World.Retinue.getInventoryUpgrades() >= ::Const.World.InventoryUpgradeCosts.len()) return;

		if (this.HD_isCartAffordable())
		{
			this.showDialogPopup(::Const.Strings.InventoryUpgradeHeader[::World.Retinue.getInventoryUpgrades()], this.HD_getCartBuyConfirmationText(), onUpgradeInventorySpace.bindenv(this), null);
		}
		else
		{
			this.showDialogPopup(::Const.Strings.InventoryUpgradeHeader[::World.Retinue.getInventoryUpgrades()], this.HD_getCartNotEnoughCrownsText(), null, null, true);
		}
	}

// New Functions
	q.HD_isCartAffordable <- function()
	{
		return ::World.Assets.getMoney() >= ::Const.World.InventoryUpgradeCosts[::World.Retinue.getInventoryUpgrades()]
	}

	q.HD_getCartBuyConfirmationText <- function()
	{
		return "You can choose to " + ::Const.Strings.InventoryUpgradeText[::World.Retinue.getInventoryUpgrades()] + " to improve your logistical captabilities for the cost of " + ::Const.Strings.InventoryUpgradeCosts[::World.Retinue.getInventoryUpgrades()] + " crowns. Is this what you want to do?";
	}

	q.HD_getCartNotEnoughCrownsText <- function()
	{
		return "Sadly, you can not afford the " + ::Const.Strings.InventoryUpgradeCosts[::World.Retinue.getInventoryUpgrades()] + " crowns necessary to " + ::Const.Strings.InventoryUpgradeText[::World.Retinue.getInventoryUpgrades()] + ".";
	}
});
