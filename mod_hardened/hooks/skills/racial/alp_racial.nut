::Hardened.HooksMod.hook("scripts/skills/racial/alp_racial", function(q) {
	// Public
	q.m.PiercingDamageMult <- 0.5;
	q.m.BiteReachDamageMult <- 0.5;		// Damage Mult from enemies with the skill hd_bite_reach

	q.getName = @() { function getName()
	{
		return this.skill.getName();
	}}.getName;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// We delete the no longer needed damage reduction entries
		::Hardened.util.HD_deleteBulletPoint(ret, function(_entry) {
			if (_entry.id == 11 && _entry.icon == "ui/icons/ranged_defense.png") return true;
			return false;
		});

		// Adjust the one remaining damage reduction tooltip according to our standardized reduction
		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/melee_defense.png")
			{
				entry.text = "Take " + ::MSU.Text.colorizeMultWithText(this.m.PiercingDamageMult, {InvertColor = true}) + " Piercing Damage";
			}
			else if (entry.id == 12 && entry.icon == "ui/icons/melee_defense.png")
			{
				entry.text = "Take " + ::MSU.Text.colorizeMultWithText(this.m.BiteReachDamageMult, {InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" Damage from characters with [$ $|Skill+hd_bite_reach]");
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// We revert the damage mult changes as that effect is now implemented via a new perk
		local oldDamageReceivedTotalMult = _properties.DamageReceivedTotalMult;
		__original(_properties);
		_properties.DamageReceivedTotalMult = oldDamageReceivedTotalMult;
	}

	q.onBeforeDamageReceived = @() { function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		switch (_hitInfo.DamageType)
		{
			case ::Const.Damage.DamageType.Piercing:
				_properties.DamageReceivedRegularMult *= this.m.PiercingDamageMult;
				break;
		}

		if (!::MSU.isNull(_attacker) && _attacker.getSkills().hasSkill("effects.hd_bite_reach"))
		{
			_properties.DamageReceivedRegularMult *= this.m.BiteReachDamageMult;
		}
	}}.onBeforeDamageReceived;

	// Overwrite, because we implement a hard-coded custom animation for rooted alps
	// Should alp teleport ever be allowed while netted, then this must be adjusted
	// Feat: play shake animation on rooted alps when them being rooted was the deciding factor to them not being able to fade
	q.teleport = @() { function teleport( _tag )
	{
		foreach (ally in ::Tactical.Entities.getAllInstancesAsArray())
		{
			if (ally.getType() != ::Const.EntityType.Alp) continue;
			if (ally.getHitpoints() == 0) continue;

			local behav = ally.getAIAgent().getBehavior(::Const.AI.Behavior.ID.AlpTeleport);
			if (behav == null) continue;

			// Switcheroo of IsRooted property, so that we can find out, if IsRooted was the deciding factor to making Fade usable
			local oldIsRooted = ally.getCurrentProperties().IsRooted;
			ally.getCurrentProperties().IsRooted = false;
			behav.onEvaluate(ally);
			ally.getCurrentProperties().IsRooted = oldIsRooted;

			if (behav.m.TargetTile != null)
			{
				if (oldIsRooted)
				{
					::Tactical.getShaker().shake(ally, ::MSU.Array.rand(::MSU.Tile.getNeighbors(ally.getTile())), 4);
				}
				else
				{
					behav.onExecute(ally);
				}
			}
		}
	}}.teleport;
});
