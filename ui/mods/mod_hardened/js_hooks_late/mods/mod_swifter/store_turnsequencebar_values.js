/*
Swifter has a system where the vanilla delays on the js side are affected by the current speed-multiplier
This introduces a weird bug when applied to already extremely short delays, like that of mResizeFirstSlotTimeIfPreviousWasHiddenToPlayer (Vanilla: 30ms)
	Entities moving in the first slot sometimes vanish on higher game speed
Our fix is to remove that swifter entry, so swifter will leave the vanilla value untouched
*/
delete Swifter.TurnSequenceBarValues.mResizeFirstSlotTimeIfPreviousWasHiddenToPlayer;
