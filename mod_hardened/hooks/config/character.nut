::Const.CharacterProperties.InitiativeAfterWaitMult = 1.0;	// This debuff is now applied via a new effect

// New Values
::Const.CharacterProperties.ShieldDamageMult <- 1.0;
::Const.CharacterProperties.CanEnemiesHaveReachAdvantage <- true;
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

::Const.CharacterProperties.CanExertZoneOfControl <- true;	// Additional property for controlling whether a actor actually can have zone of control
