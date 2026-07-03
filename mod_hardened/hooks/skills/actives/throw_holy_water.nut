::Hardened.HooksMod.hook("scripts/skills/actives/throw_holy_water", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttack = false;	// This skill is no longer considered an attack. This flag didn't make sense in vanilla anyways
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (id, entry in ret)
		{
			if ("text" in entry && ::String.contains(entry.text, "bystanders"))
			{
				ret.remove(id);
				break;
			}
		}

		return ret;
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		// Now that this skill is no longer considered an attack, we need to manually exclude allies
		return __original(_originTile, _targetTile) && !this.getContainer().getActor().isAlliedWith(_targetTile.getEntity());
	}

// Reforged Functions
	q.onApply = @(__original) function( _data )
	{
		// Feat: Holy Water now only affects the main target
		local oldApplyEffect = this.applyEffect;
		this.applyEffect = function( _target )
		{
			if (!::MSU.isEqual(_target, _data.TargetTile.getEntity())) return;
			oldApplyEffect(_target);
		}

		__original(_data);

		this.applyEffect = oldApplyEffect;
	}
});

