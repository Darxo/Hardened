this.hd_dummy_morale_state_wavering <- ::inherit("scripts/skills/special/hd_dummy_morale_state", {
	m = {},

	function create()
	{
		this.m.TargetMoraleState = ::Const.MoraleState.Wavering;
		this.hd_dummy_morale_state.create();
	}
});
