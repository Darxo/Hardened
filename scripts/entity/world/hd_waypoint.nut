this.hd_waypoint <- this.inherit("scripts/entity/world/party", {
	m = {
		CustomID = "",
	},

	function getID()
	{
		return this.m.CustomID;
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
		this.setVisibleInFogOfWar(true);	// So that the waypoint is always displayed
		this.m.CustomID = ::World.State.getPlayer().getID();
	}
});

