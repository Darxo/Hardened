::Hardened.HooksMod.hook("scripts/items/weapons/oriental/handgonne", function(q) {
	// Overwrite, because we don't want Reforged to add a reload skill with +2 Fatigue Cost here
	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		this.addSkill(::new("scripts/skills/actives/fire_handgonne_skill"));
		this.addSkill(::new("scripts/skills/actives/reload_handgonne_skill"));
	}
});
