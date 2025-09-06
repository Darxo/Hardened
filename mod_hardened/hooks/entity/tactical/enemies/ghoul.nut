::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/ghoul", function(q) {
	q.grow = @(__original) function( _instant = false )
	{
		this.getSkills().removeByID("perk.rf_ghostlike");

		__original(_instant);
	}
});
