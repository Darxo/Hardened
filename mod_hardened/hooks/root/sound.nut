/// This hook reworks directional sound during combat, by pretending that the position of the sound is at a certain position relative to the camera to produce the desired sound mix.
/// From my tests, Vanilla directional sound is broken.
/// - Everything on your camera or left of it, will blast in your left ear
/// - Everything beyond 4 units right of your camera will blast in your right ear
/// - Between 0.8 and 3.5 units right of your camera is the real directional sound, with 1.5 being the center
/// - But keep in mind that a 32 tile wide compat map is roughly 3600 units in width. The sweet spot for real directional sound is impossibly small to hit naturally
/// This approach does not take the current camera zoom into account. You might expect the directions to strech further along the visible space as you zoom out
/// You might still encounter corrupt/overly loud sound, if you move your camera while the sound is playing. I dont know an easy fix for that
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
