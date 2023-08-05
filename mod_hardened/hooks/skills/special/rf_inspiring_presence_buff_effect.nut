::mods_hookExactClass("skills/special/rf_inspiring_presence_buff_effect", function (o) {
	o.onAdded <- function()
	{
		this.removeSelf();
	}
});
