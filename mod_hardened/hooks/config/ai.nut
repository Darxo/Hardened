::MSU.AI.addBehavior("HD_Bandage_Ally", "HD.Bandage_Ally", 100, 100);
::MSU.AI.addBehavior("HD_Defend_Stance", "HD.Defend_Stance", ::Const.AI.Behavior.Order.Spearwall, ::Const.AI.Behavior.Score.Spearwall);

// Adjusted Vanilla Values
{
	// Stop being baited into shooting into big blobs over better targets
	::Const.AI.Behavior.AttackRangedHitBystandersMult = 0.15;	// In Vanilla this is 0.75

	// Make it more likely that necrosavants stay on the same tile to utilize 2 attack
	::Const.AI.Behavior.DarkflightStayOnTileBonus = 4.0;	// In Vanilla this is 2.5

	// We flip EngageRanged and Reload around because the AI is currently moving around too frequently from perfectly fine positions
	::Const.AI.Behavior.Score.EngageRanged = 90;	// Vanilla: 120
}

// New Hardened Values
{
	::Const.AI.Behavior.StanceRangedTargetMult <- 0.8;	// Don't stand around being a target with a lot of ranged enemies
	::Const.AI.Behavior.StanceMeleeTargetMult <- 1.1;

	// Nets
	::Const.AI.Behavior.ThrowNetMeleeDefenseMult <- 1.0;	// How much do we value Melee Defense on the target when considering netting them?
	::Const.AI.Behavior.ThrowNetInitiativeMult <- 0.50;	// How much do we value Initiative on the target when considering netting them?
	::Const.AI.Behavior.ThrowNetTargetAllyHeatMult <- 0.90; // How much more valueable does a target become for netting for each of its allies around it? This is applied once at a distance of 3 tiles and thrice at a distance of 1 tiles
	::Const.AI.Behavior.ThrowNetTargetHostileHeatMult <- 1.10; // How much more valueable does a target become for netting for each of its hostiles around it? This is applied once at a distance of 3 tiles and thrice at a distance of 1 tiles

	// Throwables
	::Const.AI.Behavior.OffhandDiscardDoubleGripMult <- 2.0;	// When we consider using an offhand item while we are engaged in melee considering that using it would active double grip
}


