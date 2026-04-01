::Const.World.Assets.MedicinePerInjuryDay = 2.0;	// In Vanilla this is 1.0
::Const.World.Assets.RelationUnitKilled = -3.0;		// In Vanilla this is -0.5

// Vanilla Contract Difficulty (number of skulls) is multiplied twice with the contract pay. Once raw; and once to the power of this value
// That causes contracts to not pay relative to the danger you are facing. 1 skull contracts pay very badly and 3 skull contracts pay overly well
// Setting this to 0 will completely nullify the multiplier because any value^0 = 1
::Const.World.Assets.ContractRewardPOW = 0.0;		// Vanilla: 1.3

// We make cancelling contracts a bit more viable and less punishing
::Const.World.Assets.RelationContractCancel = -5.0;		// Vanilla: -10.0
::Const.World.Assets.RelationContractCancelAdvance = -15.0;		// Vanilla: -10.0
::Const.World.Assets.ReputationOnContractCancel = -50;		// Vanilla: -100
::Const.World.Assets.ReputationOnContractFail = -50;		// Vanilla: -75

// We make poor performing players lose Renown slightly faster, so they are quicker falling back to easier difficulties
::Const.World.Assets.ReputationDaily = -5;	// Vanilla -3
// For well performing players, we improve the location reputation to balance out the daily tax
::Const.World.Assets.ReputationOnVictoryVSLocation = 15;	// Vanilla 10

// New Values
// This controls what percentage of a recruits hiring cost is needed to try them out
::Const.World.Assets.TryoutCostPct <- 0.2;	// In Vanilla this is 0.1
::Const.World.Assets.HD_RelationAttackedThem <- -5.0;	// Relationship penalty, when we enter a fight against any enemy faction (including temporary enemies)
::Const.World.Assets.HD_MoraleReputationAttackedThem <- -2;	// Morale Reputation hit, when we enter a fight against a temporary enemy

::Const.World.Assets.HD_BaseLootBuyPrice <- 1.5;	// Buying back Loot is this much more expensive. This is important to fix an exploit of buying those back for cheaper

// Renown-Hit, when you cancel a contract for which you took payment in advance
::Const.World.Assets.HD_ReputationOnContractCancelAdvance <- -50;		// Vanilla: -100
