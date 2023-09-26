::mods_hookExactClass("skills/special/rf_direct_damage_limiter", function (o) {
	o.onAdded <- function()
	{
		this.removeSelf();
	}
});
