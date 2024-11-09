::Hardened.HooksMod.hook("scripts/ui/global/data_helper", function(q) {
	q.addCharacterToUIData = @(__original) function( _entity, _target )
	{
		__original(_entity, _target);
		_target.id <- _entity.getID();	// This is a little redundant, but we need it for the experience tooltip
	}
});
