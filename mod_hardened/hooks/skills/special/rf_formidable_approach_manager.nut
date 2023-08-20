::mods_hookExactClass("skills/special/rf_formidable_approach_manager", function (o) {
	o.onAdded <- function()
	{
		this.removeSelf();
	}
});
