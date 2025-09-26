local oldSlingItemSkill = ::Reforged.InheritHelper.slingItemSkill;
::Reforged.InheritHelper.slingItemSkill = function( _superName )
{
	local ret = oldSlingItemSkill(_superName);

	local oldCreate = ret.create;
	ret.create = function()
	{
		oldCreate();
		this.m.IsStacking = true;	// Multiple of the same skills are allowed be present in parallel. If this is false, then we run into a bug when trying to sling the same pot twice during the same fight
	}

	return ret;
}
