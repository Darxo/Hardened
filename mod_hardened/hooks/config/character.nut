// Adjusting Vanilla Values
::Const.CharacterProperties.InitiativeAfterWaitMult = 1.0;	// This debuff is now applied via a new effect

// New Values
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

// If set to "false", then this prevents this actor from ever having a zone of control
// Is set to "true", nothing happens
::Const.CharacterProperties.CanExertZoneOfControl <- true;

// Shield damage dealt by this character is multiplied with this value
// 	- Actual Effect: Shield damage taken is multiplied by this value, if this actor used the last skill during this combat
::Const.CharacterProperties.ShieldDamageMult <- 1.0;

// Shield damage taken by this character is multiplied with this value
::Const.CharacterProperties.ShieldDamageReceivedMult <- 1.0;

// Any condition loss via the vanilla "function lowerCondition" is scaled by this value
// Will only react to changes made in regular "onUpdate" or "onAfterUpdate" cycles
::Const.CharacterProperties.WeaponDurabilityLossMult <- 1.0;
