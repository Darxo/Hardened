::Hardened.HooksMod.hook("scripts/skills/actives/fire_handgonne_skill", function(q) {
	q.onAdded = @(__original) function()
	{
		__original();

		// Copy of how vanilla adds the reload skill duing onUse
		local skillToAdd = ::new("scripts/skills/actives/reload_handgonne_skill");
		skillToAdd.setItem(this.getItem());
		this.getContainer().add(skillToAdd);
	}
});
