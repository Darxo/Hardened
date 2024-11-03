::Hardened.HooksMod.hook("scripts/items/item_container", function(q) {
// New Getter/Setter
	q.getWeight <- function( _slots = null )
	{
		local staminaModifier = this.getStaminaModifier(_slots);
		return ::Math.max(0, -1 * staminaModifier);
	}
});
