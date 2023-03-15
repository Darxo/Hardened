::mods_hookExactClass("entity/tactical/player", function(o) {

	local onInit = o.onInit;
	o.onInit = function()
	{
		onInit();
		this.getSkills().removeAllByID("special.rf_veteran_levels");
	}
});
