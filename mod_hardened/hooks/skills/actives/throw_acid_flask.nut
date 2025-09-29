::Hardened.HooksMod.hook("scripts/skills/actives/throw_acid_flask", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttack = false;	// This skill is no longer considered an attack. This flag didn't make sense in vanilla anyways
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		// Now that this skill is no longer considered an attack, we need to manually exclude allies
		return __original(_originTile, _targetTile) && !this.getContainer().getActor().isAlliedWith(_targetTile.getEntity());
	}

// New Functions
	// Our slingItemSkill mechanic (see inherit_helper.nut) requires those thrown object skills to contain an onApply function
	// That is true for many throw item skills, except throw_acid_flask, so we introduce that function here and redirect it to the onApplyAcid function
	q.onApply <- function( _data )
	{
		return this.onApplyAcid(_data);
	}
});

