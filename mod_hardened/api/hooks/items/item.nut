::Hardened.HooksMod.hookTree("scripts/items/item", function(q) {
	// Public
	if (!"StaminaModifier" in q.m) q.m.StaminaModifier <- 0;

	q.create = @(__original) function()
	{
		__original();
		this.m.Condition = ::Math.minf(this.m.Condition, this.m.ConditionMax);	// Prevent Condition from ever being larger than ConditionMax
	}
});

::Hardened.HooksMod.hook("scripts/items/item", function(q) {
// New Getter/Setter
	q.getWeight <- function()
	{
		local staminaModifier = this.getStaminaModifier();
		return ::Math.max(0, -1 * staminaModifier);
	}

	// Set the stamina modifier of the item to the inverse of the passed value
	q.setWeight <- function( _weight )
	{
		this.m.StaminaModifier = -1 * _weight;
	}

	q.isNamed <- function()
	{
		return this.isItemType(::Const.Items.ItemType.Named);
	}

	// @return the brush name of this item, if it exists
	// @return null otherwise
	q.HD_getBrush <- function()
	{
		return null;
	}

	// @return the brush name of the silhouette that should be displayed for when this item is in a bag slot
	// @return null if no brush exists to be displayed
	// @return null if no silhouette should be displayed (e.g. due to mod settings)
	q.HD_getSilhouette <- function()
	{
		return this.HD_getBrush();
	}
});
