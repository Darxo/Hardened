::mods_hookExactClass("entity/tactical/actor", function(o) {
	local oldOnInit = o.onInit;
	o.onInit = function()
	{
		oldOnInit();
		this.getSkills().add(::new("scripts/skills/special/hd_direct_damage_limiter"));
	}

	local oldWait = o.wait;
	o.wait = function()
	{
		oldWait();
		this.getSkills().add(::new("scripts/skills/effects/hd_wait_effect"));
	}
});
