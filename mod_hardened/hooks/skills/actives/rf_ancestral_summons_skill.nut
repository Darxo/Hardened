::Hardened.HooksMod.hook("scripts/skills/actives/rf_ancestral_summons_skill", function(q) {
	q.spawnUndead = @(__original) { function spawnUndead( _user, _tile )
	{
		__original(_user, _tile);

		if (!::MSU.isNull(::Hardened.Private.LastSpawnedActor))
		{
			// We don't want these reanimations to be farmed forever by the player for loot and xp
			local skills = ::Hardened.Private.LastSpawnedActor.getSkills();
			skills.add(::new("scripts/skills/special/hd_unworthy_effect"));
			skills.add(::new("scripts/skills/special/hd_worthless_effect"));
		}
	}}.spawnUndead;
});
