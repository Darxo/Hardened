local hookInjuries = function( _injuryCollection, _bodyPart )
{
	foreach (injuryEntry in _injuryCollection)
	{
		::Hardened.HooksMod.hook("scripts/skills/" + injuryEntry.Script, function(q) {
			q.create = @(__original) function()
			{
				__original();
				if (this.m.AffectedBodyPart < 0)
				{
					this.m.AffectedBodyPart = _bodyPart;
				}
				else if (this.m.AffectedBodyPart != _bodyPart)	// Our injury is already registered as the other body part, so it is probably meant to be one for the full body
				{
					this.m.AffectedBodyPart = ::Const.BodyPart.All;
				}
			}
		});
	}
}

// Body Injuries
hookInjuries(::Const.Injury.BluntBody, ::Const.BodyPart.Body);
hookInjuries(::Const.Injury.CuttingBody, ::Const.BodyPart.Body);
hookInjuries(::Const.Injury.PiercingBody, ::Const.BodyPart.Body);
hookInjuries(::Const.Injury.BurningBody, ::Const.BodyPart.Body);

// Head Injuries
hookInjuries(::Const.Injury.BluntHead, ::Const.BodyPart.Head);
hookInjuries(::Const.Injury.CuttingHead, ::Const.BodyPart.Head);
hookInjuries(::Const.Injury.PiercingHead, ::Const.BodyPart.Head);
hookInjuries(::Const.Injury.BurningHead, ::Const.BodyPart.Head);
