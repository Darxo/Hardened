::Const.World.Assets.MedicinePerInjuryDay = 2.0;	// In Vanilla this is 1.0
::Const.World.Assets.RelationUnitKilled = -3.0;		// In Vanilla this is -0.5

// Vanilla Contract Difficulty (number of skulls) is multiplied twice with the contract pay. Once raw; and once to the power of this value
// That causes contracts to not pay relative to the danger you are facing. 1 skull contracts pay very badly and 3 skull contracts pay overly well
// Setting this to 0 will completely nullify the multiplier because any value^0 = 1
::Const.World.Assets.ContractRewardPOW = 0.0;		// Vanilla: 1.3

// New Values
// This controls what percentage of a recruits hiring cost is needed to try them out
::Const.World.Assets.TryoutCostPct <- 0.2;	// In Vanilla this is 0.1
::Const.World.Assets.HD_RelationAttackedThem <- -5.0;	// Relationship penalty, when we enter a fight against any enemy faction (including temporary enemies)
::Const.World.Assets.HD_MoraleReputationAttackedThem <- -2;	// Morale Reputation hit, when we enter a fight against a temporary enemy

::Const.World.Assets.HD_BaseLootBuyPrice <- 1.5;	// Buying back Loot is this much more expensive. This is important to fix an exploit of buying those back for cheaper
