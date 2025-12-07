::Hardened.HooksMod.hook("scripts/states/world_state", function(q) {
	// Private
	q.m.HD_LastUniqueLocationDiscoveredSoundTime <- 0.0;

	q.showCombatDialog = @(__original) function(_isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true, _properties = null, _pos = null)
	{
		if (::World.Assets.m.IsAlwaysShowingScoutingReport)
		{
			local mockObject = ::Hardened.mockFunction(::World.Assets.getOrigin(), "getID", function() {
				if (::Hardened.getFunctionCaller(1) == "showCombatDialog")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
				{
					return { done = true, value = "scenario.rangers" };
				}
			});

			__original(_isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking, _properties, _pos);
			mockObject.cleanup();
		}
		else
		{
			__original(_isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking, _properties, _pos);
		}
	}

// New Functions
	// Play the sound effect for discovering a unique location on the world map
	// Make sure, that this sound effect is not played too quickly in succession (e.g. when revealing the whole map at once)
	// This function has a similar structure to the vanilla "world_state::playEnemyDiscoveredSound" one
	q.HD_playUniqueLocationDiscoveredSound <- function()
	{
		if (this.m.HD_LastUniqueLocationDiscoveredSoundTime + 8.0 < ::Time.getRealTimeF())
		{
			this.m.HD_LastUniqueLocationDiscoveredSoundTime = ::Time.getRealTimeF();
			::Sound.play(::MSU.Array.rand(::Const.Sound.HD_UniqueLocationDiscoveredOnWorldmap), 2.5);	// These sfx ended up being pretty quiet, so we boost their volume here
		}
	}
});
