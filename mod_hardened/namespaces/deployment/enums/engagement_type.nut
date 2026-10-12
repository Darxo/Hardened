::Hardened.Deployment.EngagementType <- {
	/// Player and enemy face each other from opposite sides of the battlefield.
	/// Allies spawn on top of player
	/// Up to 2 different factions may take up spawns top and bottom
	LineBattle = "HD_Line_Battle",

	/// Player joins an ongoing battle between two opposing participants.
	/// Up to 5 additional non-fighting participants may join on top of that
	/// Allies spawn top or bottom of player at border
	JoinBattle = "HD_Join_Battle",

	/// Player is surrounded by an enemy participant.
	GetAmbushed = "HD_Get_Ambushed",

	/// Player surrounds an enemy participant.
	DoAmbush = "HD_Do_Ambush",

	/// Player deploys at the edge while enemies are distributed across the battlefield.
	FightInfestation = "HD_Fight_Infestation",

	/// Player attacks an enemy defending a fortified deployment area.
	AttackFortification = "HD_Attack_Fortification",

	/// Player defends a fortified deployment area against an attacking enemy and spawns outside of the walls
	DefendFortification = "HD_Defend_Fortification",

	/// Deployment regions are defined manually instead of using a predefined engagement layout.
	Custom = "HD_Custom",
};
