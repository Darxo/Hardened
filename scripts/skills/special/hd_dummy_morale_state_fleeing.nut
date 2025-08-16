this.hd_dummy_morale_state_fleeing <- ::inherit("scripts/skills/special/hd_dummy_morale_state", {
	m = {},

	function create()
	{
		this.m.TargetMoraleState = ::Const.MoraleState.Fleeing;
		this.hd_dummy_morale_state.create();
	}
});
