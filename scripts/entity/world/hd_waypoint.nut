this.hd_waypoint <- this.inherit("scripts/entity/world/party", {
	m = {
		CustomID = "",
	},

	function getID()
	{
		return this.m.CustomID;
	}

	function create()
	{
		this.party.create();

		// Similar to the player, we must make sure Controller are only attached to real AI world parties
		// Otherwise, the WayPoint will start sharing KnownOpponents with nearby "Allies",
		// 	which can confuse them by adding those allies as their own opponents
		this.m.Controller = null;
	}

	function onInit()
	{
		this.party.onInit();
		this.m.IsAttackable = false
		// this.m.IsPlayer = true;
		this.addSprite("waypoint");
	}

	function init( _waypointBrush )
	{
		local waypoint = this.getSprite("waypoint");
		waypoint.setBrush(_waypointBrush);
		waypoint.setOffset(this.createVec(0, 50));
		this.setVisibleInFogOfWar(true);	// So that the waypoint is always displayed
		this.m.CustomID = ::World.State.getPlayer().getID();
	}
});

