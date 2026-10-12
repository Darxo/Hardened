::Hardened.Deployment.RegionPlan <- class {
	Player = null;			// Region reserved for the player
	PersonalAlly = null;	// Ally spawning directly alongside the player
	Default = [];			// Normal participant placement. Front: Enemies; Back: Allies

	constructor()
	{
		this.Player = null;
		this.PersonalAlly = null;
		this.Default = [];
	}
};
