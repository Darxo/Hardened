::Hardened.HooksMod.hook("scripts/entity/tactical/human", function(q) {
	// Feat: We make Humans use the base-actor feature of not playing the same sound effect in a row
	// Overwrite, because there is barely anything in the vanilla function and the one thing that IS in it (::Sound.play) is what we need to prevent
	q.playSound = @() function( _type, _volume, _pitch = 1.0 )
	{
		return this.actor.playSound(_type, _volume, _pitch);
	}
});
