::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/hexe", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/racial/hd_hexe_racial"));
	}
});
