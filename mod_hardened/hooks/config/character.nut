::Const.CharacterProperties.InitiativeAfterWaitMult = 1.0;	// This debuff is now applied via a new effect

::Const.CharacterProperties.ReachAdvantageMult <- ::Reforged.Reach.ReachAdvantageMult;
::Const.CharacterProperties.getReachAdvantageMult <- function()
{
	return this.ReachAdvantageMult;
}

::Const.CharacterProperties.ReachAdvantageBonus <- ::Reforged.Reach.ReachAdvantageBonus;
::Const.CharacterProperties.getReachAdvantageBonus <- function()
{
	return this.ReachAdvantageBonus;
}
