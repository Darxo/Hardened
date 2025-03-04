/// This hook reworks directional sound during combat, by pretending that the position of the sound is at a certain position relative to the camera to produce the desired sound mix.
/// From my tests, Vanilla directional sound is broken.
/// - Everything on your camera or left of it, will blast in your left ear
/// - Everything beyond 4 units right of your camera will blast in your right ear
/// - Between 0.8 and 3.5 units right of your camera is the real directional sound, with 1.5 being the center
/// - But keep in mind that a 32 tile wide compat map is roughly 3600 units in width. The sweet spot for real directional sound is impossibly small to hit naturally
/// This approach does not take the current camera zoom into account. You might expect the directions to strech further along the visible space as you zoom out
/// You might still encounter corrupt/overly loud sound, if you move your camera while the sound is playing (usually happens during NPC turns). I dont know an easy fix for that
local oldPlay = ::Sound.play;
::Sound.play = function(_path, _volume = null, _pos = null, _pitch = null)
{
	if (_volume == null) return oldPlay(_path);
	if (_pos == null) return oldPlay(_path, _volume);

	if (::Hardened.Mod.ModSettings.getSetting("UseSoundEngineFix").getValue() && ::MSU.Utils.hasState("tactical_state"))
	{
		local getMappedValue = function( _x )
		{
			local ret = 1.5;
			if (_x > 0)
			{
				ret += _x / 350.0;
			}
			else
			{
				ret += _x / 1000.0;
			}
			return ret;
		}

		local cameraPos = ::Tactical.getCamera().getPos();
		local xDifference = _pos.X - cameraPos.X;

		_pos = cameraPos;
		_pos.X += getMappedValue(xDifference);
	}

	if (_pitch == null) return oldPlay(_path, _volume, _pos);
	return oldPlay(_path, _volume, _pos, _pitch);
}

/**
# General Information
- Sound works off of a getPos() position object, which has an X and Y.
	- At the bottom left of the map they are both 0. X goes up to ~3800 and Y goes up to ~2560
- Sound direction is generated from using the position of your camera (::Tactical.getCamera().getPos()) in relation to the position passed in the (::Sound.play) call
	- However ::Sound.play does not use ::Tactical.getCamera().getPos() directly, it seems like its implementation accesses the camera position directly, so hooking getPos is out of the question
- The same sound will change panning over the course of its play, if you move the camera related to its position
- I tried comparisons with the vanilla option "Hardware Sound" off, but couldn't hear a difference. Currently I have it always on

# Test directional sound
- You need to be in combat
- Adjust the X offset with various values
	- Notable values are everything from 0.8 to 3.5 in steps of 0.1
	- At high values the sound simply goes more and more quiet

local soundPos = ::Tactical.getCamera().getPos();
soundPos.X += 2.7;
::Sound.play("sounds/inventory/hawk_inventory_01.wav", 1.0, soundPos);

# Play sound at brother location:
- This will help you to hear the differences between vanilla and the sound fix and also get a feeling for how sound behaves where
- Instead of the command below, you can also just use the jump hotkey (J) while debug mode is activated to jump your brother around and produce step sounds

::Sound.play("sounds/inventory/hawk_inventory_01.wav", 1.0, ::getBro("Volmar").getPos());

*/
