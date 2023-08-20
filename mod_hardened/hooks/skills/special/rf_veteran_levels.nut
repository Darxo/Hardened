::mods_hookExactClass("skills/special/rf_veteran_levels", function (o) {
	o.onAdded <- function()
	{
		this.removeSelf();
	}
});
