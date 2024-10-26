::Hardened.HooksMod.hook("scripts/ui/screens/character/character_screen", function(q) {
	q.m.DistributedXPFraction <- 0.5;
	q.m.MaximumXPFractionPerBrother <- 0.1;

	q.onDismissCharacter = @(__original) function( _data )
	{
		local bro = ::Tactical.getEntityByID(_data[0]);
		if (bro == null) return __original();

		local payCompensation = _data[1];
		if (payCompensation)
		{
			::Hardened.util.shareExperience(bro.getXP() * this.m.DistributedXPFraction, this.m.MaximumXPFractionPerBrother, [bro.getID()]);
		}

		__original(_data);

	}
});
