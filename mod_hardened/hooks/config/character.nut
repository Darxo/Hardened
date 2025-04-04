// Adjusting Vanilla Values
::Const.CharacterProperties.InitiativeAfterWaitMult = 1.0;	// This debuff is now applied via a new effect

// Overwrite vanilla function
local oldGetHitChance = ::Const.CharacterProperties.getHitchance;
::Const.CharacterProperties.getHitchance = function( _bodyPart )
{
	if (::Hardened.Temp.UserWantingToHit == null)
	{
		return oldGetHitChance(_bodyPart);
	}
	else
	{
		// SkillToBeHitWith is a WeakTableRef. In theory that should cause (skill == this) tests to fail, but somehow they don't. If they ever do then the solution would be to call `get()` here
		return this.getHeadHitchance(_bodyPart, ::Hardened.Temp.UserWantingToHit, ::Hardened.Temp.SkillToBeHitWith, ::Hardened.Temp.TargetToBeHit);
	}
}

local oldGetClone = ::Const.CharacterProperties.getClone;
::Const.CharacterProperties.getClone = function()
{
	local ret = oldGetClone();
	ret.WeightStaminaMult = clone this.WeightStaminaMult;
	ret.WeightInitiativeMult = clone this.WeightInitiativeMult;
	return ret;
}

::Const.CharacterProperties.WeightStaminaMult <- array(::Const.ItemSlotSpaces.len(), 1.0);		// StaminaMult for every equipment slot
::Const.CharacterProperties.WeightInitiativeMult <- array(::Const.ItemSlotSpaces.len(), 1.0);		// InitiativeMult for every equipment slot
::Const.CharacterProperties.WeightStaminaMult[::Const.ItemSlot.Bag] = 0.5;
::Const.CharacterProperties.WeightInitiativeMult[::Const.ItemSlot.Bag] = 0.5;

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

// Headshot chance of Attacks targeting this character, will be modified by this value during attacks & expected damage calculation
// If you want incoming attacks to be a guaranteed headshot you probably wanna give them a very high value here
::Const.CharacterProperties.HeadshotReceivedChance <- 0;

// Headshot chance of Attacks targeting this character, will be multiplied by this value during attacks & expected damage calculation
// If this is 0, incoming attacks will never hit the head
::Const.CharacterProperties.HeadshotReceivedChanceMult <- 1.0;

// New Functions
::Const.CharacterProperties.getHeadHitchance <- function( _bodyPart, _user = null, _skill = null, _target = null )
{
	if (::MSU.isNull(_user) || ::MSU.isNull(_skill) || ::MSU.isNull(_target))
	{
		return oldGetHitChance(_bodyPart);
	}

	local defenderProps = _target.getSkills().buildPropertiesForDefense(_user, _skill);

	local headshotChance = this.HitChance[::Const.BodyPart.Head] + defenderProps.HeadshotReceivedChance;

	headshotChance *= this.HitChanceMult[::Const.BodyPart.Head];
	headshotChance *= defenderProps.HeadshotReceivedChanceMult;
	headshotChance = ::Math.min(100.0, ::Math.floor(headshotChance));

	if (_bodyPart == ::Const.BodyPart.Head)
	{
		return headshotChance;
	}
	else
	{
		return 100.0 - headshotChance;
	}
}

// New function for gaining the Stamina before weight reductions
::Const.CharacterProperties.getStamina <- function()
{
	// A negative Stamina should get worse from a positive StaminaMult, so we reverse the effect of the StaminaMult in this case
	local staminaMult = (this.Stamina >= 0) ? this.StaminaMult : (1 / this.StaminaMult);
	return ::Math.floor(this.Stamina * staminaMult);
}

// Const.Combat
::Const.Combat.SpawnArrowDecalAttempts = 10;	// In Vanila this is 3; potentially causing several missiles producing now decal on impact. Not sure why though
