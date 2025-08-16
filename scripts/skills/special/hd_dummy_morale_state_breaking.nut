this.hd_dummy_morale_state_breaking <- ::inherit("scripts/skills/special/hd_dummy_morale_state", {
	m = {},

	function create()
	{
		this.m.TargetMoraleState = ::Const.MoraleState.Breaking;
		this.hd_dummy_morale_state.create();
	}
});
