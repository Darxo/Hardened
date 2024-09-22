::MSU.AI.addBehavior("HD_Defend_Stance", "HD.Defend_Stance", ::Const.AI.Behavior.Order.Spearwall, ::Const.AI.Behavior.Score.Spearwall);

// Adjusted Vanilla Values
::Const.AI.Behavior.AttackRangedHitBystandersMult = 0.25;	// In Vanilla this is 0.75 - Stop being baited into shooting into big blobs over better targets

// New Hardened Values
::Const.AI.Behavior.StanceRangedTargetMult <- 0.8;	// Don't stand around being a target with a lot of ranged enemies
::Const.AI.Behavior.StanceMeleeTargetMult <- 1.1;
