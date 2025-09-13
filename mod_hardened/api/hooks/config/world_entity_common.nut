local oldAssignTroops = ::Const.World.Common.assignTroops;
::Const.World.Common.assignTroops = function( _worldParty, _partyList, _resources, _minibossify = 0, _weightMode = 1 )
{
	_resources *= ::Hardened.Global.getWorldDifficultyMult();
	return oldAssignTroops(_worldParty, _partyList, _resources, _minibossify, _weightMode);
}

local oldAddUnitsToCombat = ::Const.World.Common.assignTroops;
::Const.World.Common.addUnitsToCombat = function( _into, _partyList, _resources, _faction, _minibossify = 0 )
{
	_resources *= ::Hardened.Global.getWorldDifficultyMult();
	oldAddUnitsToCombat(_into, _partyList, _resources, _faction, _minibossify);
}
