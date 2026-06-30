Hardened.Hooks.XBBCODE_process = XBBCODE.process;
XBBCODE.process = function(config)
{
	var ret = Hardened.Hooks.XBBCODE_process(config);

	ret.html = ret.html.replace(
		/(?:\[|&#91;)wbr(?:\]|&#93;)(?:\[|&#91;)\/wbr(?:\]|&#93;)/g,
		"<wbr>"
	);

	return ret;
};
