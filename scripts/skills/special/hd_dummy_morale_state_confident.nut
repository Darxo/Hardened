this.hd_dummy_morale_state_confident <- ::inherit("scripts/skills/special/hd_dummy_morale_state", {
	m = {},

	function create()
	{
		this.m.TargetMoraleState = ::Const.MoraleState.Confident;
		this.hd_dummy_morale_state.create();
	}
});
