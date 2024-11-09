// We prevent the generateName function from generating the exact same name in two consecutive calls
local lastGeneratedName = "";
local oldGenerateName = ::Const.World.Common.generateName;
::Const.World.Common.generateName = function( _list )
{
	local ret = oldGenerateName(_list);

	for (local i = 0; i < 10; ++i)
	{
		if (ret != lastGeneratedName) break;
		ret = oldGenerateName(_list);
	}
	lastGeneratedName = ret;

	return ret;
}
